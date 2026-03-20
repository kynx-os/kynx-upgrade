#!/bin/sh
set -eu

cat << 'EOL'
[
  {
    "id": "asia",
    "name": "Asia",
    "countries": ["Iraq", "Saudi Arabia", "United Arab Emirates", "Turkey", "India", "Japan", "Other"]
  },
  {
    "id": "europe",
    "name": "Europe",
    "countries": ["Germany", "France", "United Kingdom", "Italy", "Spain", "Netherlands", "Other"]
  },
  {
    "id": "africa",
    "name": "Africa",
    "countries": ["Egypt", "Libya", "Algeria", "Morocco", "Tunisia", "Other"]
  },
  {
    "id": "north-america",
    "name": "North America",
    "countries": ["United States", "Canada", "Mexico", "Other"]
  },
  {
    "id": "south-america",
    "name": "South America",
    "countries": ["Brazil", "Argentina", "Chile", "Other"]
  },
  {
    "id": "oceania",
    "name": "Oceania",
    "countries": ["Australia", "New Zealand", "Other"]
  },
  {
    "id": "other",
    "name": "Other",
    "countries": ["Other"]
  }
]
EOL
