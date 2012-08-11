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
