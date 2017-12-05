"""
Plot Addresses
"""
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.ticker import FormatStrFormatter
from matplotlib.font_manager import FontProperties
from scipy.stats import norm

if len(sys.argv) != 4:
    print "Usage: python distrib64.addresses.py decimalData [ylabel] [title]"

# Collect the data from the given file
with open (sys.argv[1], "r") as data:
  Title=data.readline()
  ADDRESS=np.array(map(int, data.readline().split(',')))

ADDRESSy = np.array(range(1, len(ADDRESS)+1))

Title = Title.title()
Title = Title.replace("bsd", "BSD")
Title = Title.replace(".", "")
Title = Title.replace(".", "")
Title = Title.replace("64", " 64")
Title = Title.replace("32", " 32")

# Plot The Memory Addresses

plt.figure(num=None, figsize=(5.5, 4), dpi=80, facecolor='w', edgecolor='k')

ax = plt.subplot(111)

plt.hist(ADDRESS)

# Adjust the subplot dimensions to fit the legend

box = ax.get_position()
ax.set_position([box.x0, box.y0 + box.height * 0.1, box.width, box.height * 0.9])

ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05), ncol=8)

ax.xaxis.set_major_formatter(FormatStrFormatter('%x'))
plt.xticks()

xLabel = 'Memory '
yLabel = 'Run Number'
title = 'Address Distribution for %s'%(Title)

if (len(sys.argv) == 4):
  yLabel = sys.argv[2]
  title = sys.argv[3]

plt.xlabel(xLabel)
plt.ylabel(yLabel)
plt.title(title)

saveLocation = './' + sys.argv[1].split('.')[0] + '_distribution.png'

plt.savefig(saveLocation, bbox_inches='tight')

#plt.show()
