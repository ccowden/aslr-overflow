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

def CreateHistogram(filename, numBins = 10, yLabel="Run Number", title=""):
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
    (chisq, p) = chisquare(n)

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

    saveLocation = './' + filename.split('.')[0] + '_distribution.png'

    plt.savefig(saveLocation, bbox_inches='tight')

    #plt.show()

    # return the count for each bin
    return n

def Chi2GOF(filename, distribution):
    (chisq, p) = chisquare(distribution)
    saveLocation = './' + filename.split('.')[0] + '_chisq.txt'
    f = open(saveLocation, "w")
    f.write('{},'.format(chisq))
    f.write('{}'.format(p))
    f.close()

if __name__ == "__main__":
    if len(sys.argv) == 5:
        distrib = CreateHistogram(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
        Chi2GOF(sys.argv[1], distrib)
    elif len(sys.argv) == 3:
        distrib = CreateHistogram(sys.argv[1], sys.argv[2])
        Chi2GOF(sys.argv[1], distrib)
    elif len(sys.argv) == 2:
        distrib = CreateHistogram(sys.argv[1])
        Chi2GOF(sys.argv[1], distrib)
    else:
        print "Usage: python distrib64.addresses.py decimalData.txt numBins [ylabel] [title]"

    
