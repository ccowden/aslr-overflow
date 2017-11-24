"""
Plot Addresses
"""
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.font_manager import FontProperties

# Collect the data from the given file
with open (sys.argv[1], "r") as data:
  Title=data.readline()
  ADDRESS1=np.array(map(int, data.readline().split(',')))
  ADDRESS2=np.array(map(int, data.readline().split(',')))
  ADDRESS3=np.array(map(int, data.readline().split(',')))
  ADDRESS4=np.array(map(int, data.readline().split(',')))
  ADDRESS5=np.array(map(int, data.readline().split(',')))
  ADDRESS6=np.array(map(int, data.readline().split(',')))
  ADDRESS7=np.array(map(int, data.readline().split(',')))
  ADDRESS8=np.array(map(int, data.readline().split(',')))

ADDRESSx = np.array([1] * len(ADDRESS1))

Title = Title.title()
Title = Title.replace("bsd", "BSD")
Title = Title.replace(".", "")
Title = Title.replace("\n", "")
Title = Title.replace("64", " 64")
Title = Title.replace("32", " 32")

# Plot The Memory Addresses

plt.figure(num=None, figsize=(5.5, 4), dpi=80, facecolor='w', edgecolor='k')

ax = plt.subplot(111)

ax.scatter(ADDRESSx, ADDRESS1, c='k', label='Byte 0', edgecolor='none', s=30)
ax.scatter(ADDRESSx + 1, ADDRESS2, c='k', marker="^", label='Byte 1', edgecolor='none', s=30)
ax.scatter(ADDRESSx + 2, ADDRESS3, c='b', marker="s", label='Byte 2', edgecolor='none', s=30)
ax.scatter(ADDRESSx + 3, ADDRESS4, c='m', marker="D", label='Byte 3', edgecolor='none', s=30)
ax.scatter(ADDRESSx + 4, ADDRESS5, c='y', marker="o", label='Byte 4', edgecolor='none', s=30)
ax.scatter(ADDRESSx + 5, ADDRESS6, c='c', marker="p", label='Byte 5', edgecolor='none', s=30)
ax.scatter(ADDRESSx + 6, ADDRESS7, c='r', marker="x", label='Byte 6', edgecolor='none', s=30)
ax.scatter(ADDRESSx + 7, ADDRESS8, c='g', marker="*", label='Byte 7', edgecolor='none', s=30)


# Adjust the subplot dimensions to fit the legend

box = ax.get_position()
ax.set_position([box.x0, box.y0 + box.height * 0.1, box.width, box.height * 0.9])

ax.legend(loc='upper center', bbox_to_anchor=(0.5, -0.05), ncol=4)

plt.xticks(())
plt.yticks(())

plt.xlabel('')
plt.ylabel('hidden() Memory Address')
plt.title('Memory Address Entropy for %s - Flattened'%(Title))

fileName = sys.argv[1].replace("addresses", "flattened");

saveLocation = './' + fileName.split('.')[0] + '_flattened.png'

plt.savefig(saveLocation, bbox_inches='tight')

plt.show()
