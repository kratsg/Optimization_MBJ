import argparse
import subprocess
import os

class CustomFormatter(argparse.ArgumentDefaultsHelpFormatter):
  pass

__version__ = subprocess.check_output(["git", "describe", "--always"], cwd=os.path.dirname(os.path.realpath(__file__))).strip()
__short_hash__ = subprocess.check_output(["git", "rev-parse", "--short", "HEAD"], cwd=os.path.dirname(os.path.realpath(__file__))).strip()

parser = argparse.ArgumentParser(description='Author: A. Cukierman, G. Stark. v.{0}'.format(__version__),
                                 formatter_class=lambda prog: CustomFormatter(prog, max_help_position=30))
parser.add_argument('--lumi', required=False, type=int, dest='lumi', metavar='<L>', help='luminosity to use', default=1)
parser.add_argument('-o', '--output', required=False, type=str, dest='output', metavar='', help='basename to use for output filename', default='output')
parser.add_argument('-d', '--output-dir', required=False, type=str, dest='output_dir', metavar='', help='directory to put it in', default='plots')

parser.add_argument('--do-run1', action='store_true', help='Add Run-1 line to graph')
parser.add_argument('--run1-color', type=int, required=False, help='Color of Run-1 line', default=46)
parser.add_argument('--run1-excl', type=str, required=False, help='CSV file containing Run-1 exclusion points', default='run1_limit.csv')
parser.add_argument('--run1-1sigma', type=str, required=False, help='CSV file containing Run-1 exclusion (+1 sigma) points', default='run1_limit_1sigma.csv')

parser.add_argument('--do-run2', action='store_true', help='Add Run-2 line to graph')
parser.add_argument('--run2-color', type=int, required=False, help='Color of Run-2 line', default=46)
parser.add_argument('--run2-excl', type=str, required=False, help='CSV file containing Run-2 exclusion points', default='run2_limit.csv')
parser.add_argument('--run2-1sigma', type=str, required=False, help='CSV file containing Run-2 exclusion (+1 sigma) points', default='run2_limit_1sigma.csv')


parser.add_argument("--basedir", required=False, type=str, help="base directory", default="SR")
parser.add_argument("--massWindows", required=False, type=str, help="Location of mass windows file", default="mass_windows.txt")

parser.add_argument("--numSRs", required=False, type=int, help="Number of signal regions", default=4)

# parse the arguments, throw errors if missing any
args = parser.parse_args()

import ROOT
ROOT.PyConfig.IgnoreCommandLineOptions = True
ROOT.gROOT.SetBatch(True)
import csv
import glob
import re
import json
from collections import defaultdict
from root_optimize import plotting

def init_canvas():
  c = ROOT.TCanvas("c", "", 0, 0, 800, 600)
  c.SetRightMargin(0.16)
  c.SetTopMargin(0.07)
  return c

def set_bin(h, x, y, val):
  # now, let's find the bin to fill
  b = h.FindFixBin(x, y)
  xx = yy = zz = ROOT.Long(0)
  h.GetBinXYZ(b, xx, yy, zz)
  if xx != 0 or yy != 0 or zz != 0:
    print "bin was already set?\n\txx: {0}\n\tyy: {1}\n\tzz: {2}".format(xx, yy, zz)
    print "x: {0}\ty: {1}".format(x, y)
    print "new value: {0}".format(val)
    print "-"*20
  if val > 0:
    h.SetBinContent(b, val)
  else:
    h.SetBinContent(b, 0.01)

def draw_hist(h, textFormat="1.0f"):
  # now draw it
  h.SetMarkerSize(800)
  h.SetMarkerColor(ROOT.kWhite)
  #ROOT.gStyle.SetPalette(51)
  ROOT.gStyle.SetPaintTextFormat(textFormat)
  h.GetXaxis().SetTitleOffset(1.0)
  h.GetYaxis().SetTitleOffset(1.0)
  h.GetXaxis().SetLabelSize(19)
  h.GetYaxis().SetLabelSize(17)
  h.GetZaxis().SetTitleOffset(1.0)
  h.GetZaxis().SetLabelSize(17)
  h.Draw("TEXT COLZ")

def draw_text(args):
  '''
  txt = ROOT.TLatex()
  txt.SetNDC()
  txt.DrawText(0.32,0.87,"Work-in-Progress")
  #txt.DrawText(0.2,0.82,"Simulation")
  #txt.SetTextSize(0.030)
  txt.SetTextSize(18)
  txt.DrawLatex(0.16,0.95,"#tilde{g}#tilde{g} production, #tilde{g} #rightarrow t #bar{t} + #tilde{#chi}^{0}_{1}")
  txt.DrawLatex(0.62,0.95,"#sqrt{s} = 13 TeV, %d fb^{-1}"% args.lumi)
  txt.SetTextFont(72)
  txt.SetTextSize(0.05)
  txt.DrawText(0.2,0.87,"ATLAS")
  #txt.SetTextFont(12)
  txt.SetTextAngle(0)
  txt.SetTextSize(0.02)
  txt.DrawText(0.33,0.63,"Kinematically Forbidden")
  '''
  txt = ROOT.TLatex()
  txt.SetNDC()
  txt.DrawText(0.32,0.87,"Work-in-Progress")
  txt.DrawText(0.2,0.82,"Simulation")
  #txt.SetTextSize(0.030)
  txt.SetTextSize(12)
  txt.SetTextAngle(31)
  txt.DrawText(0.3,0.63,"Kinematically Forbidden")
  txt.SetTextAngle(0)
  txt.SetTextSize(18)
  txt.DrawLatex(0.16,0.95,"#tilde{g}#tilde{g} production, #tilde{g} #rightarrow t #bar{t} + #tilde{#chi}^{0}_{1}")
  txt.DrawLatex(0.62,0.95,"#sqrt{s} = 13 TeV, %d fb^{-1}"% args.lumi)
  txt.SetTextFont(72)
  txt.SetTextSize(0.05)
  txt.DrawText(0.2,0.87,"ATLAS")

def fix_zaxis(h):
  # fix the ZAxis
  h.GetZaxis().SetRangeUser(1, args.numSRs+1)
  h.GetZaxis().CenterLabels()
  h.GetZaxis().SetTickLength(0)
  h.SetContour(args.numSRs)
  h.GetZaxis().SetNdivisions(args.numSRs, False)

def draw_line():
  topmass = 173.34
  l=ROOT.TLine(1000,1000,2000,2000)
  l.SetLineStyle(2)
  l.DrawLine(1000,1000-2*topmass,1950+3.32,1600)

import array
def get_run1(filename,linestyle,linewidth,linecolor):
  x = array.array('f')
  y = array.array('f')
  n = 0
  with open(filename,'r') as csvfile:
    reader = csv.reader(csvfile, delimiter = ' ')
    for row in reader:
      n += 1
      x.append(float(row[0]))
      y.append(float(row[1]))

  gr = ROOT.TGraph(n,x,y)
  gr.SetLineColor(linecolor)
  gr.SetLineWidth(linewidth)
  gr.SetLineStyle(linestyle)
  return gr

def save_canvas(c, filename):
  c.SaveAs(filename + ".pdf")
  print "Saving file " + filename
  c.Clear()

from rootpy.plotting.style import set_style, get_style
atlas = get_style('ATLAS')
atlas.SetPalette(51)
set_style(atlas)

# given a DID, we get the mass points, translates to a box on the graph for us
with open(args.massWindows, 'r') as f:
  reader = csv.reader(f, delimiter='\t')
  m = list(reader)
mdict = {l[0]: [int(l[1]),int(l[2]),int(l[3])] for l in m}
del m

# start up a dictionary to hold all information
significances = defaultdict(lambda: dict((i,0) for i in range(1, args.numSRs+1)))

p_did = re.compile(r's(\d+)\.b([a-fA-F\d]{32})\.json')

# for each signal region, build up the significance value
for i in range(1,args.numSRs+1):
  files = glob.glob(os.path.join(args.basedir, "SR{0:d}Significances_{1:d}".format(i, args.lumi), "s*.b*.json"))
  for filename in files:
    with open(filename, 'r') as f:
      data = json.load(f)
    did = p_did.search(filename).group(1)
    significances[did][i] = data[0]['significance_scaled']

# find the winning SR
import operator
winners = dict((i, 0) for i in range(1, args.numSRs+1))
for did, vals in significances.iteritems():
  winner = max(vals.iteritems(), key=operator.itemgetter(1))[0]
  winners[winner] += 1
  significances[did]['winner'] = winner

print winners

# do optimal signal regions
c = init_canvas()
h = plotting.init_hist("Optimal Signal Region", 1000, 2000, 0, 1600, 100)
for did, vals in significances.iteritems():
  winningSR = vals['winner']
  mgluino, mstop, mlsp = mdict[did]
  if mstop != 5000: continue
  set_bin(h, mgluino, mlsp, winningSR)

draw_hist(h)
draw_text(args)
fix_zaxis(h)
draw_line()

save_canvas(c, '{0}_optimalSR_grid_lumi{1}'.format(os.path.join(args.output_dir, args.output), args.lumi))

# now make a plot of the actual significances
c = init_canvas()
h = plotting.init_hist("Significance of optimal SR", 1000, 2000, 0, 1600, 100)
for did, vals in significances.iteritems():
  winningSR = vals['winner']
  mgluino, mstop, mlsp = mdict[did]
  if mstop != 5000: continue
  set_bin(h, mgluino, mlsp, vals[winningSR])

draw_hist(h, "1.1f")
draw_text(args)
draw_line()

if args.do_run1:
  gr = plotting.get_run1(args.run1_excl,1,3,args.run1_color)
  gr.Draw("C")
  gr_1sigma = plotting.get_run1(args.run1_1sigma,3,1,args.run1_color)
  gr_1sigma.Draw("C")
  plotting.draw_run1_text(args.run1_color)
if args.do_run2:
  gr = plotting.get_run2(args.run2_excl,1,3,args.run2_color)
  gr.Draw("C")
  gr_1sigma = plotting.get_run2(args.run2_1sigma,3,1,args.run2_color)
  gr_1sigma.Draw("C")
  plotting.draw_run2_text(args.run2_color)

save_canvas(c, '{0}_optimalSR_sig_lumi{1}'.format(os.path.join(args.output_dir, args.output), args.lumi))

