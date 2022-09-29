import os
import requests
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

lichessId = os.environ.get("LICHESS_ID")
darkOutput = os.environ.get("OUTPUT_DARK")
lightOutput = os.environ.get("OUTPUT_LIGHT")

# Get Lichess rating history
response = requests.get('https://lichess.org/api/user/' + lichessId + '/rating-history')

# Sanity check
print(response)

# [{ 'name': string, 'points': [[year, month, day, rating]]}]
json = response.json()
records = []
for variant in json:
  name = variant['name']
  for record in variant['points']:
    records.append((name, record[0], record[1], record[2], record[3]))

df = pd.DataFrame.from_records(np.array(records,
  dtype=[('variant','U32'),('year','u4'),('month','u4'),('day','u4'),('rating','u4')]))

df['month'] = df['month']+1 # months are 0-based in Lichess

df['date'] = pd.to_datetime(df[['year','month','day']])

sns.set_theme(style="ticks", palette=sns.color_palette("rocket_r"))
sns.relplot(data=df, x='date', y='rating', hue='variant', kind='line', aspect=1.6)
plt.savefig(lightOutput)


sns.set(rc={
  'axes.facecolor':'#0d1117',
  'axes.edgecolor': '#c9d1d9',
  'axes.grid': False,
  'axes.labelcolor': '#c9d1d9',
  'figure.facecolor':'#0d1117',
  'grid.color': '#0d1117',
  'text.color': '#c9d1d9',
  'xtick.color': '#c9d1d9',
  'ytick.color': '#c9d1d9',
}, palette=sns.color_palette("rocket_r"))
sns.relplot(data=df, x='date', y='rating', hue='variant', kind='line', aspect=1.6)
plt.savefig(darkOutput)
