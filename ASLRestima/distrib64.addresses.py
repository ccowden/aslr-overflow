"""
Plot Addresses
"""
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.ticker import FormatStrFormatter
from matplotlib.font_manager import FontProperties
from scipy.stats import chisquare

def CreateHistogram(filename, suppressPlots, numBins = 20, yLabel="Run Number", title=""):
    # Collect the data from the given file
    with open (filename, "r") as data:
        Title=data.readline()
        ADDRESS=np.array(map(int, data.readline().split(',')))

    Title = Title.title()
    Title = Title.replace("bsd", "BSD")
    Title = Title.replace(".", "")
    Title = Title.replace(".", "")
    Title = Title.replace("64", " 64")
    Title = Title.replace("32", " 32")

    # Plot The Memory Addresses

    plt.figure(num=None, figsize=(5.5, 4), dpi=80, facecolor='w', edgecolor='k')

    ax = plt.subplot(111)

    (n, bins, patches) = plt.hist(ADDRESS, bins=numBins)

    # Adjust the subplot dimensions to fit the legend

    box = ax.get_position()
    ax.set_position([box.x0, box.y0 + box.height * 0.1, box.width, box.height * 0.9])

    ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05), ncol=8)

    ax.xaxis.set_major_formatter(FormatStrFormatter('%x'))
    plt.xticks()

    xLabel = 'Memory '
    if title == "":
        title = 'Address Distribution for %s'%(Title)

    plt.xlabel(xLabel)
    plt.ylabel(yLabel)
    plt.title(title)

    saveLocation = './graphs/' + filename.split('.')[0] + '_distribution.png'

    plt.savefig(saveLocation, bbox_inches='tight')

    if (suppressPlots == False):
         plt.show()

    # return the count for each bin
    return n

#Performs a one-sided Chi2 Goodness Of Fit Test
def Chi2GOF(distribution):
    (chisq, p) = chisquare(distribution)

    print "Chi Square Goodness of Fit Analysis"
    print 'Entries per bin: {}'.format(distribution)
    print "H0: The data is consistent with an equal/constant distribution"
    print "Ha: The data is inconsistent with an equal/constant distribution"
    print 'Chisq statistic: {},'.format(chisq)
    print 'PValue: {}\n'.format(p)

    if ((1-p) > .05):
    	print "With an alpha of .05, we would reject the null hypothesis.\nIt is unlikely that the data comes from a truly random distribution.\n"
    else:
        print "With an alpha of .05, we would fail to reject the null hypothesis.\nWe cannot say with certainty whether or not it comes from a truly random distribution.\n\n"


if __name__ == "__main__":
    if len(sys.argv) == 6:
        distrib = CreateHistogram(sys.argv[1], bool(sys.argv[2]), int(sys.argv[3]), sys.argv[4], sys.argv[5])
        Chi2GOF(distrib)
    elif len(sys.argv) == 4:
        distrib = CreateHistogram(sys.argv[1], bool(sys.argv[2]), int(sys.argv[3]))
        Chi2GOF(distrib)
    elif len(sys.argv) == 3:
        distrib = CreateHistogram(sys.argv[1], bool(sys.argv[2]))
        Chi2GOF(distrib)
    else:
        print "Usage: python distrib64.addresses.py decimalData.txt suppressPlots [numBins] [ylabel] [title]"

    
