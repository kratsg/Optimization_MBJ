from root_optimize import plotting
import os

if __name__ == '__main__':
  import argparse
  import subprocess

  class CustomFormatter(argparse.ArgumentDefaultsHelpFormatter):
    pass

  __version__ = subprocess.check_output(["git", "describe", "--always"], cwd=os.path.dirname(os.path.realpath(__file__))).strip()
  __short_hash__ = subprocess.check_output(["git", "rev-parse", "--short", "HEAD"], cwd=os.path.dirname(os.path.realpath(__file__))).strip()

  parser = argparse.ArgumentParser(description='Author: A. Cukierman, G. Stark. v.{0}'.format(__version__),
                                   formatter_class=lambda prog: CustomFormatter(prog, max_help_position=30))
  parser.add_argument('--summary', type=str, required=True, help='Summary json')
  parser.add_argument('--lumi', type=float, required=False, help='Luminosity to write on plot [ifb]', default=35)
  parser.add_argument('--text-file', type=str, required=False, help='text csv file', default=None)
  parser.add_argument('--out-directory', type=str, required=False, help='output directory', default='plots')
  parser.add_argument('-o', '--output', type=str, required=False, help='Name to put in output filenames', default='output')
  parser.add_argument('--g-min', type=float, required=False, help='Minimum gluino mass', default=200)
  parser.add_argument('--g-max', type=float, required=False, help='Maximum gluino mass', default=2500)
  parser.add_argument('--l-min', type=float, required=False, help='Minimum LSP mass', default=0)
  parser.add_argument('--l-max', type=float, required=False, help='Maximum LSP mass', default=2300)
  parser.add_argument('--bin-size', type=float, required=False, help='Size of bins to use', default=100)
  parser.add_argument('--x-dim', type=float, required=False, help='x-dimension of figure', default=800)
  parser.add_argument('--y-dim', type=float, required=False, help='y-dimension of figure', default=600)
  parser.add_argument('--top-mass', type=float, required=False, help='Mass of top quark [GeV]. Mainly meant to draw exclusion line.', default=173.34)
  parser.add_argument('--do-run1', action='store_true', help='Add Run-1 line to graph')
  parser.add_argument('--run1-color', type=int, required=False, help='Color of Run-1 line', default=46)
  parser.add_argument('--run1-excl', type=str, required=False, help='CSV file containing Run-1 exclusion points', default='run1_limit.csv')
  parser.add_argument('--run1-1sigma', type=str, required=False, help='CSV file containing Run-1 exclusion (+1 sigma) points', default='run1_limit_1sigma.csv')

  parser.add_argument('--do-run2', action='store_true', help='Add Run-2 line to graph')
  parser.add_argument('--run2-color', type=int, required=False, help='Color of Run-2 line', default=46)
  parser.add_argument('--run2-excl', type=str, required=False, help='CSV file containing Run-2 exclusion points', default='run2_limit.csv')
  parser.add_argument('--run2-1sigma', type=str, required=False, help='CSV file containing Run-2 exclusion (+1 sigma) points', default='run2_limit_1sigma.csv')

  parser.add_argument('-b', '--batch', dest='batch_mode', action='store_true', help='Enable batch mode for ROOT.')

  # parse the arguments, throw errors if missing any
  args = parser.parse_args()

  def draw_hist(hist, nSigs=1, markercolor=0, drawOpts="TEXT COLZ"):
    hist.SetMarkerSize(800)
    hist.SetMarkerColor(markercolor)
    #gStyle.SetPalette(51)
    ROOT.gStyle.SetPaintTextFormat("1.{0:d}f".format(nSigs));
    hist.GetXaxis().SetTitleOffset(1.0)
    hist.GetYaxis().SetTitleOffset(1.0)
    hist.GetXaxis().SetLabelSize(19)
    hist.GetYaxis().SetLabelSize(17)
    hist.GetZaxis().SetTitleOffset(1.0)
    hist.GetZaxis().SetLabelSize(17)
    hist.Draw(drawOpts)

  def draw_labels(lumi):
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
    txt.DrawLatex(0.16,0.95,"#tilde{g}-#tilde{g} production, #tilde{g} #rightarrow t #bar{t} + #tilde{#chi}^{0}_{1}")
    txt.DrawLatex(0.62,0.95,"L_{int} = %d fb^{-1}, #sqrt{s} = 13 TeV"% lumi)
    txt.SetTextFont(72)
    txt.SetTextSize(0.05)
    txt.DrawText(0.2,0.87,"ATLAS")
    
  def draw_line(x_min, y_min, x_max, y_max, topmass=173.34):
    l=ROOT.TLine(1000,1000,2000,2000)
    l.SetLineStyle(2)
    if x_min - 2*topmass > y_min:
      line_min_x = x_min
      line_min_y = x_min-2*topmass
    else:
      line_min_x = y_min + 2*topmass
      line_min_y = y_min

    if x_max - 2*topmass > y_max:
      line_max_x = y_max + 2*topmass
      line_max_y = y_max
    else:
      line_max_x = x_max
      line_max_y = x_max - 2*topmass

    l.DrawLine(line_min_x, line_min_y, line_max_x, line_max_y)
    # slope should be one as it's: LSP < Gluino - 2*topmass
    slope = float(line_max_y - line_min_y)/(line_max_x - line_min_x)
      
    # Draw Kinematically Forbidden as well
    #txt = ROOT.TLatex()
    #txt.SetNDC()
    #txt.SetTextFont(12)
    #txt.SetTextAngle(31)
    #txt.SetTextSize(0.5)
    #txt.DrawText(0.3,0.63, "Kinematically Forbidden")

  def draw_run2_text(color):
    txt = ROOT.TLatex()
    txt.SetNDC()
    #txt.SetTextAngle(0)
    txt.SetTextFont(42)
    txt.SetTextSize(0.04)
    txt.SetTextColor(color)
    txt.DrawLatex(0.2,0.41,"Moriond 2016 Limit, 3.2 fb^{-1}")

  import ROOT
  ROOT.PyConfig.IgnoreCommandLineOptions = True
  ROOT.gROOT.SetBatch(args.batch_mode)

  import json
  summary = json.load(file(args.summary))

  plot_array={'sig':      [r['significance'] for r in summary],
              'signal':   [r['signal'] for r in summary],
              'bkgd':     [r['bkgd'] for r in summary],
              'mgluino':  [r['m_gluino'] for r in summary],
              'mlsp':     [r['m_lsp'] for r in summary],
              'ratio':    [r['ratio'] for r in summary]}

  plotting.init_palette()

  c = plotting.init_canvas(args.x_dim, args.y_dim)
  labels = ['sig','signal','bkgd', 'ratio']
  zlabels = ['Significance of optimal cuts','Exp. num. signal in optimal cut','Exp. num. bkgd in optimal cut', 'Signal/Background']
  nSigs = [2, 3, 3, 2]
  for label,zlabel,nSig in zip(labels,zlabels,nSigs):
    h = plotting.init_hist(zlabel, args.g_min, args.g_max, args.l_min, args.l_max, args.bin_size)
    plotting.fill_hist(h,plot_array,label, label=='sig')
    draw_hist(h, nSig)
    draw_labels(args.lumi)
    plotting.draw_text(args.text_file)
    draw_line(args.g_min, args.l_min, args.g_max, args.l_max, args.top_mass)
    savefilename = os.path.join(args.out_directory, '_'.join([args.output, label]))
    if args.do_run1:
      gr = plotting.get_run1(args.run1_excl,1,3,args.run1_color)
      gr.Draw("C")
      gr_1sigma = plotting.get_run1(args.run1_1sigma,3,1,args.run1_color)
      gr_1sigma.Draw("C")
      plotting.draw_run1_text(args.run1_color)
      savefilename += "_wrun1"
    if args.do_run2:
      gr = plotting.get_run2(args.run2_excl,1,3,args.run2_color)
      gr.Draw("C")
      gr_1sigma = plotting.get_run2(args.run2_1sigma,3,1,args.run2_color)
      gr_1sigma.Draw("C")
      draw_run2_text(args.run2_color)
      savefilename += "_wrun2"
    #p = exclusion()
    #p.Draw()
    c.SaveAs(savefilename + ".pdf")
    c.SaveAs(savefilename + ".root")
    print "Saving file " + savefilename
    c.Clear()

  exit(0)
