# ==============================================================================
# = paradigm's init.sage                                                       =
# ==============================================================================

# set image viewer for things like plots
sage.misc.viewer.BROWSER = 'sxiv -V'
# set pdf viewer
sage.misc.viewer.PDF_VIEWER = 'mupdf -V'

# make commonly-used variables
# skip e and i, as constants
# skip n and r, as function
# skip x, already variable
# skip j, want to treat as \sqrt{-i}
var('a b c d f g h k l m o p q s t u v w y z')
# use j as \sqrt{-i}, since i is current
j = i
# greek values as vars
# skip pi, as constant
var('alpha beta gamma delta epsilon zeta eta theta iota kappa mu nu xi omicron rho sigma tau upsilon phi chi psi omega')

# shortcuts for units
#class un:
for measurement in units.trait_names():
    for unit in getattr(units,measurement).trait_names():
        # don't use abampere, abvolt,etc
        # seimens is SI, mho is not
        # don't use statvolt nearly as often as volt
        if unit[0:2] != 'ab' and unit != 'mho' and unit != 'statvolt':
            locals()[unit] = getattr(getattr(units,measurement),unit)

# other constants
# dielectric constant/permiability of air/vacuum:
e_0 = 8.854*10^(-12)
# magnetic permeability of air
mu_0 = 0.4*pi*10^(-6)

# set default latex engine to pdflatex
latex.engine('pdflatex')

# write plot points to disk, to be used by external plotter
def write_points(plot, filepath):
    points = plot[0]
    f = open(filepath, 'w')
    for point in zip(points.xdata, points.ydata):
        f.write('%f %f\n' % point)
    f.close()

# shortcuts for real_part and imag_part
rp = real_part
ip = imag_part

# (try to) simplify units sanely
def simplify_unit(given_unit):
    for measurement in units.trait_names():
        for unit in eval('units.' + measurement + '.trait_names()'):
            # don't use abampere, abvolt,etc
            # seimens is SI, mho is not
            # don't use statvolt nearly as often as volt
            if unit[0:2] != 'ab' and unit != 'mho' and unit != 'statvolt':
                try:
                    return given_unit.convert(getattr(getattr(units,measurement),unit))
                    #return eval('(' + str(given_unit) + ').convert(units.' + measurement + '.' + unit + ')')
                except:
                    pass
    return given_unit

def batman_plot(num):
	x,y = var('x,y')
	f1 = ((x/7)^2*sqrt((abs(abs(x)-3))/(abs(x)-3))+(y/3)^2*sqrt((abs(y+3*sqrt(33)/7)/(y+3*sqrt(33)/7)))-1)
	f2 = abs(x/2)-(3*sqrt(33)-7)/112*x^2-3+sqrt(1-(abs(abs(x)-2)-1)^2)-y
	f3 = 9*sqrt(abs((abs(x)-1)*(abs(x)-0.75))/((1-abs(x))*(abs(x)-0.75)))-8*abs(x)-y
	f4 = -y+3*abs(x)+0.75*sqrt(abs((abs(x)-0.75)*(abs(x)-0.5))/(-(abs(x)-0.75)*(abs(x)-0.5)))
	f5 = 2.25*sqrt(abs((x-0.5)*(x+0.5))/(-(x-0.5)*(x+0.5)))-y
	f6 = 6*sqrt(10)/7+(1.5-0.5*abs(x))*sqrt(abs(abs(x)-1)/(abs(x)-1))-6*sqrt(10)/14*sqrt(4-(abs(x)-1)^2)-y
	print "0/6"
	A = implicit_plot(f1,(x,-8,8),(y,-5,5),plot_points=num)
	print "1/6"
	B = implicit_plot(f2,(x,-8,8),(y,-5,5),plot_points=num)
	print "2/6"
	C = implicit_plot(f3,(x,-8,8),(y,-5,5),plot_points=num)
	print "3/6"
	D = implicit_plot(f4,(x,-8,8),(y,-5,5),plot_points=num)
	print "4/6"
	E = implicit_plot(f5,(x,-8,8),(y,-5,5),plot_points=num)
	print "5/6"
	F = implicit_plot(f6,(x,-8,8),(y,-5,5),plot_points=num)
	print "6/6"
	show(A+B+C+D+E+F)
