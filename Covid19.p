# -*- coding: utf-8 -*-
"""Covid19-OMARI_ROUMAISSA_G7.ipynb
{
  "nbformat": 4,
  "nbformat_minor": 0,
  "metadata": {
    "colab": {
      "name": "Covid19-OMARI_ROUMAISSA_G7.ipynb",
      "provenance": [],
      "collapsed_sections": [],
      "toc_visible": true
    },
    "kernelspec": {
      "name": "python3",
      "display_name": "Python 3"
    }
  },
  "cells": [
    {
      "cell_type": "code",
      "metadata": {
        "id": "unZHuNELUcnT",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 35
        },
        "outputId": "bc735111-54c3-49b4-9bd5-dc76d4104041"
      },
      "source": [
        "# import Modules\n",
        "!pip install sqlalchemy \n",
        "import sqlite3\n",
        "import pandas as pd\n",
        "import numpy as np\n",
        "import matplotlib.pyplot as plt\n",
        "import seaborn as sns"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "stream",
          "text": [
            "Requirement already satisfied: sqlalchemy in /usr/local/lib/python3.6/dist-packages (1.3.17)\n"
          ],
          "name": "stdout"
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "du4MYGBAsfUn"
      },
      "source": [
        "con = sqlite3.connect(\"/content/Covid19France.db\")"
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "P8UL33klvfuE"
      },
      "source": [
        "# Set function as our sql_to_pandas\n",
        "\n",
        "def sql_to_df(sql_query):\n",
        "\n",
        "    # Use pandas to pass sql query using connection form SQLite3\n",
        "    df = pd.read_sql(sql_query, con)\n",
        "\n",
        "    # Show the resulting DataFrame\n",
        "    return df"
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "IG48rKKhwZzQ"
      },
      "source": [
        "# **4.1- Requêtes SQL :**"
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "77OL8dU9w770"
      },
      "source": [
        "# 1) Quelle est la région la plus touchée ?"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "0mVgbjtWBUMc",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 194
        },
        "outputId": "a83ab819-ccc2-48d2-c777-a7d3a8832d58"
      },
      "source": [
        "query ='''SELECT reg, SUM(hosp) as hosp\n",
        "          FROM RegionAge \n",
        "          GROUP BY reg \n",
        "          ORDER BY hosp DESC'''\n",
        "\n",
        "\n",
        "# Grab \n",
        "sql_to_df(query).head()"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>reg</th>\n",
              "      <th>hosp</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>11</td>\n",
              "      <td>1166994</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>44</td>\n",
              "      <td>461855</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>84</td>\n",
              "      <td>278698</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>32</td>\n",
              "      <td>233381</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>93</td>\n",
              "      <td>167398</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "   reg     hosp\n",
              "0   11  1166994\n",
              "1   44   461855\n",
              "2   84   278698\n",
              "3   32   233381\n",
              "4   93   167398"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 58
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "EfSX7PoKv7A-"
      },
      "source": [
        "**On peut donc voir que la region la plus touchée (en terme d'hospitalisation covid19) est la Région 11 : L'ile de France** "
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "_luch2F3xXrV"
      },
      "source": [
        "# 2) Quelles sont les classes d'age les plus impactées par ce virus ?"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "JDlABJaerCrs",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 340
        },
        "outputId": "33f00f90-4bcf-4458-dcbc-6970e7468d34"
      },
      "source": [
        "query ='''SELECT cl_age90, SUM(hosp) as hosp\n",
        "          FROM RegionAge\n",
        "          GROUP BY cl_age90\n",
        "          ORDER BY hosp DESC'''\n",
        "\n",
        "# Grab \n",
        "sql_to_df(query).head(10)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>cl_age90</th>\n",
              "      <th>hosp</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>0</td>\n",
              "      <td>1444207</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>89</td>\n",
              "      <td>359131</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>79</td>\n",
              "      <td>325759</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>69</td>\n",
              "      <td>262790</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>90</td>\n",
              "      <td>181631</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>5</th>\n",
              "      <td>59</td>\n",
              "      <td>165643</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>6</th>\n",
              "      <td>49</td>\n",
              "      <td>75641</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>7</th>\n",
              "      <td>39</td>\n",
              "      <td>37430</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>8</th>\n",
              "      <td>29</td>\n",
              "      <td>15330</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>9</th>\n",
              "      <td>9</td>\n",
              "      <td>4343</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "  cl_age90     hosp\n",
              "0        0  1444207\n",
              "1       89   359131\n",
              "2       79   325759\n",
              "3       69   262790\n",
              "4       90   181631\n",
              "5       59   165643\n",
              "6       49    75641\n",
              "7       39    37430\n",
              "8       29    15330\n",
              "9        9     4343"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 60
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "NmD0B2YZyBuK"
      },
      "source": [
        "Les classes d'ages les plus impactés par ce virus sont donc celle supérieurs à 60 ans avec un grand nombre entre 79 et 89 ans ."
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "0YQMyxVHyaSX"
      },
      "source": [
        "# 3) Quels sont les jours de la semaine ou il y a le plus de cas ?"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "NeXMhszZyhVP"
      },
      "source": [
        ""
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "BAO8_GcISdBK",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 429
        },
        "outputId": "d1c4078a-8e1e-4ac0-d477-5daa20b6b01a"
      },
      "source": [
        "import datetime\n",
        "\n",
        "query ='''SELECT jour, hosp\n",
        "          FROM RegionAge \n",
        "          ORDER BY hosp DESC'''\n",
        "\n",
        "# Grab \n",
        "data = sql_to_df(query).head(10)\n",
        "data['Day'] = \"\"\n",
        "for i in range(len(data)):\n",
        "  data['Day'][i] = datetime.datetime.strptime(data['jour'][i], '%Y-%m-%d').strftime('%A')\n",
        "data"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "stream",
          "text": [
            "/usr/local/lib/python3.6/dist-packages/ipykernel_launcher.py:11: SettingWithCopyWarning: \n",
            "A value is trying to be set on a copy of a slice from a DataFrame\n",
            "\n",
            "See the caveats in the documentation: https://pandas.pydata.org/pandas-docs/stable/user_guide/indexing.html#returning-a-view-versus-a-copy\n",
            "  # This is added back by InteractiveShellApp.init_path()\n"
          ],
          "name": "stderr"
        },
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>jour</th>\n",
              "      <th>hosp</th>\n",
              "      <th>Day</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>2020-04-14</td>\n",
              "      <td>13209</td>\n",
              "      <td>Tuesday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>2020-04-13</td>\n",
              "      <td>13196</td>\n",
              "      <td>Monday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>2020-04-12</td>\n",
              "      <td>13165</td>\n",
              "      <td>Sunday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>2020-04-11</td>\n",
              "      <td>13025</td>\n",
              "      <td>Saturday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>2020-04-15</td>\n",
              "      <td>13018</td>\n",
              "      <td>Wednesday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>5</th>\n",
              "      <td>2020-04-10</td>\n",
              "      <td>12861</td>\n",
              "      <td>Friday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>6</th>\n",
              "      <td>2020-04-16</td>\n",
              "      <td>12834</td>\n",
              "      <td>Thursday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>7</th>\n",
              "      <td>2020-04-17</td>\n",
              "      <td>12766</td>\n",
              "      <td>Friday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>8</th>\n",
              "      <td>2020-04-09</td>\n",
              "      <td>12681</td>\n",
              "      <td>Thursday</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>9</th>\n",
              "      <td>2020-04-18</td>\n",
              "      <td>12490</td>\n",
              "      <td>Saturday</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "         jour   hosp        Day\n",
              "0  2020-04-14  13209    Tuesday\n",
              "1  2020-04-13  13196     Monday\n",
              "2  2020-04-12  13165     Sunday\n",
              "3  2020-04-11  13025   Saturday\n",
              "4  2020-04-15  13018  Wednesday\n",
              "5  2020-04-10  12861     Friday\n",
              "6  2020-04-16  12834   Thursday\n",
              "7  2020-04-17  12766     Friday\n",
              "8  2020-04-09  12681   Thursday\n",
              "9  2020-04-18  12490   Saturday"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 62
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "-ZJmnl4Zy3Q0"
      },
      "source": [
        "Les jours de la semaine où il y'a le plus de cas sont le  mardi, lundi et le  dimanche"
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "TYv3tSvLz6aH"
      },
      "source": [
        "# 4) Donner le top 10 des départements les plus touchés, les moins touchés ?"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "bH59x1Cq0NL_"
      },
      "source": [
        ""
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "U0mh6Ob4WzTy",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 340
        },
        "outputId": "6bb7ea49-8dc8-43d0-c998-c5a9381d7755"
      },
      "source": [
        "query ='''SELECT dep, SUM(hosp) as hosp\n",
        "          FROM DepSexe \n",
        "          GROUP BY dep \n",
        "          ORDER BY hosp DESC'''\n",
        "\n",
        "sql_to_df(query).head(10)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>hosp</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>75</td>\n",
              "      <td>274764</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>94</td>\n",
              "      <td>191848</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>92</td>\n",
              "      <td>189891</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>93</td>\n",
              "      <td>149189</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>69</td>\n",
              "      <td>119614</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>5</th>\n",
              "      <td>91</td>\n",
              "      <td>110717</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>6</th>\n",
              "      <td>68</td>\n",
              "      <td>107602</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>7</th>\n",
              "      <td>67</td>\n",
              "      <td>105344</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>8</th>\n",
              "      <td>13</td>\n",
              "      <td>103273</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>9</th>\n",
              "      <td>57</td>\n",
              "      <td>97212</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "  dep    hosp\n",
              "0  75  274764\n",
              "1  94  191848\n",
              "2  92  189891\n",
              "3  93  149189\n",
              "4  69  119614\n",
              "5  91  110717\n",
              "6  68  107602\n",
              "7  67  105344\n",
              "8  13  103273\n",
              "9  57   97212"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 63
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "BtIayHzV09sT"
      },
      "source": [
        "Voici la Liste des 10 départements avec le plus de cas( en somme des hospitalisation covid19)"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "gPHyWKLg1ENb",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 340
        },
        "outputId": "4e9006d5-f580-4db3-f15a-e8aaa205b879"
      },
      "source": [
        "query ='''SELECT dep, SUM(hosp) as hosp\n",
        "          FROM DepSexe \n",
        "          GROUP BY dep \n",
        "          ORDER BY hosp'''\n",
        "\n",
        "sql_to_df(query).head(10)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>hosp</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>None</td>\n",
              "      <td>26</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>48</td>\n",
              "      <td>492</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>973</td>\n",
              "      <td>647</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>2B</td>\n",
              "      <td>1056</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>9</td>\n",
              "      <td>1135</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>5</th>\n",
              "      <td>16</td>\n",
              "      <td>1231</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>6</th>\n",
              "      <td>82</td>\n",
              "      <td>1328</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>7</th>\n",
              "      <td>46</td>\n",
              "      <td>1722</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>8</th>\n",
              "      <td>974</td>\n",
              "      <td>2244</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>9</th>\n",
              "      <td>40</td>\n",
              "      <td>2258</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "    dep  hosp\n",
              "0  None    26\n",
              "1    48   492\n",
              "2   973   647\n",
              "3    2B  1056\n",
              "4     9  1135\n",
              "5    16  1231\n",
              "6    82  1328\n",
              "7    46  1722\n",
              "8   974  2244\n",
              "9    40  2258"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 65
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "AJuKI_JB1xf0"
      },
      "source": [
        "Voici la Liste des 10 départements avec le moin de cas( en somme des hospitalisation covid19)"
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "jh4m9S4014VE"
      },
      "source": [
        "# 5) Donner le Top 5 des régions les plus touchées au mois de Mars ? Avril ? Mai ?"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "PSYa8t-s2MGn",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 194
        },
        "outputId": "724439b1-9c28-49f9-a8b3-d03912644689"
      },
      "source": [
        "query ='''SELECT reg, SUM(hosp) as hosp, jour\n",
        "          FROM RegionAge\n",
        "          WHERE jour BETWEEN '2020-03-01' AND '2020-03-31'\n",
        "          GROUP BY reg\n",
        "          ORDER BY hosp DESC'''\n",
        "\n",
        "# Grab \n",
        "\n",
        "sql_to_df(query).head(5)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>reg</th>\n",
              "      <th>hosp</th>\n",
              "      <th>jour</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>11</td>\n",
              "      <td>121357</td>\n",
              "      <td>2020-03-31</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>44</td>\n",
              "      <td>70444</td>\n",
              "      <td>2020-03-31</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>84</td>\n",
              "      <td>34093</td>\n",
              "      <td>2020-03-31</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>32</td>\n",
              "      <td>22622</td>\n",
              "      <td>2020-03-31</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>93</td>\n",
              "      <td>17898</td>\n",
              "      <td>2020-03-31</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "   reg    hosp        jour\n",
              "0   11  121357  2020-03-31\n",
              "1   44   70444  2020-03-31\n",
              "2   84   34093  2020-03-31\n",
              "3   32   22622  2020-03-31\n",
              "4   93   17898  2020-03-31"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 66
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "plId59Nu2pWf"
      },
      "source": [
        "Au mois de Mars ce sont donc les regions 11, 44, 84, 32, 93 qui ont été le plus touchées \n"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "uFtkXHY22-bw",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 194
        },
        "outputId": "60ea9002-ad42-40a3-a31a-23a0b39cf07f"
      },
      "source": [
        "query ='''SELECT reg, SUM(hosp) as hosp, jour\n",
        "          FROM RegionAge\n",
        "          WHERE jour BETWEEN '2020-04-01' AND '2020-04-31'\n",
        "          GROUP BY reg\n",
        "          ORDER BY hosp DESC'''\n",
        "\n",
        "# Grab \n",
        "sql_to_df(query).head(5)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>reg</th>\n",
              "      <th>hosp</th>\n",
              "      <th>jour</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>11</td>\n",
              "      <td>694422</td>\n",
              "      <td>2020-04-29</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>44</td>\n",
              "      <td>266545</td>\n",
              "      <td>2020-04-29</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>84</td>\n",
              "      <td>165172</td>\n",
              "      <td>2020-04-29</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>32</td>\n",
              "      <td>136053</td>\n",
              "      <td>2020-04-29</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>93</td>\n",
              "      <td>100450</td>\n",
              "      <td>2020-04-29</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "   reg    hosp        jour\n",
              "0   11  694422  2020-04-29\n",
              "1   44  266545  2020-04-29\n",
              "2   84  165172  2020-04-29\n",
              "3   32  136053  2020-04-29\n",
              "4   93  100450  2020-04-29"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 68
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "U3kcXbg43OQN"
      },
      "source": [
        "Au mois d'Avril ce sont donc les regions 11, 44, 84, 32, 93 qui ont été le plus touchées"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "xZE8SCh-3RZj",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 194
        },
        "outputId": "bc34ece3-56b0-4145-e70f-f2fe8d38b6f2"
      },
      "source": [
        "query ='''SELECT reg, SUM(hosp) as hosp, jour\n",
        "          FROM RegionAge\n",
        "          WHERE jour BETWEEN '2020-05-01' AND '2020-05-31'\n",
        "          GROUP BY reg\n",
        "          ORDER BY hosp DESC'''\n",
        "\n",
        "# Grab \n",
        "sql_to_df(query).head(5)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>reg</th>\n",
              "      <th>hosp</th>\n",
              "      <th>jour</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>11</td>\n",
              "      <td>351215</td>\n",
              "      <td>2020-05-19</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>44</td>\n",
              "      <td>124866</td>\n",
              "      <td>2020-05-19</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>84</td>\n",
              "      <td>79433</td>\n",
              "      <td>2020-05-19</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>32</td>\n",
              "      <td>74706</td>\n",
              "      <td>2020-05-19</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>93</td>\n",
              "      <td>49050</td>\n",
              "      <td>2020-05-19</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "   reg    hosp        jour\n",
              "0   11  351215  2020-05-19\n",
              "1   44  124866  2020-05-19\n",
              "2   84   79433  2020-05-19\n",
              "3   32   74706  2020-05-19\n",
              "4   93   49050  2020-05-19"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 69
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "7qrwC9h73dtF"
      },
      "source": [
        "Au mois de Mai ce sont donc les regions 11, 44, 84, 32, 93 qui ont été le plus touchées"
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "1NoMTPP03h2W"
      },
      "source": [
        "# **4.2- Analyse Statistique:**"
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "evNp61yjYU2L"
      },
      "source": [
        "## 1) Visualiser par département le nombre de personnes atteints du Covid 19 "
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "39RyI4fEUrML",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 194
        },
        "outputId": "b2ce79ce-4893-46ee-f771-61fb3cbd15c9"
      },
      "source": [
        "\n",
        "# Load data set des données des urgences et sos médecins\n",
        "data_dep = pd.read_csv('/content/data/sursaud-covid19-hebdomadaire-2020-05-20-19h00.csv',sep=';')\n",
        "data_dep.head()\n"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>semaine</th>\n",
              "      <th>sursaud_cl_age_corona</th>\n",
              "      <th>Nbre_pass_Corona</th>\n",
              "      <th>Nbre_pass_tot</th>\n",
              "      <th>Nbre_hospit_Corona</th>\n",
              "      <th>Nbre_acte_corona</th>\n",
              "      <th>Nbre_acte_tot</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>01</td>\n",
              "      <td>2020-S10</td>\n",
              "      <td>0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>1929.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>01</td>\n",
              "      <td>2020-S10</td>\n",
              "      <td>A</td>\n",
              "      <td>0.0</td>\n",
              "      <td>351.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>01</td>\n",
              "      <td>2020-S10</td>\n",
              "      <td>B</td>\n",
              "      <td>0.0</td>\n",
              "      <td>751.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>01</td>\n",
              "      <td>2020-S10</td>\n",
              "      <td>C</td>\n",
              "      <td>0.0</td>\n",
              "      <td>371.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>01</td>\n",
              "      <td>2020-S10</td>\n",
              "      <td>D</td>\n",
              "      <td>0.0</td>\n",
              "      <td>172.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "  dep   semaine  ... Nbre_acte_corona  Nbre_acte_tot\n",
              "0  01  2020-S10  ...              NaN            NaN\n",
              "1  01  2020-S10  ...              NaN            NaN\n",
              "2  01  2020-S10  ...              NaN            NaN\n",
              "3  01  2020-S10  ...              NaN            NaN\n",
              "4  01  2020-S10  ...              NaN            NaN\n",
              "\n",
              "[5 rows x 8 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 7
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "kzkCT3xhWjnq",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 223
        },
        "outputId": "06dc0a18-836d-4494-ef42-fc6f84334e71"
      },
      "source": [
        "cas_par_dep= data_dep.groupby('dep').sum().sort_values('Nbre_hospit_Corona', ascending = False)\n",
        "cas_par_dep.head()\n"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>Nbre_pass_Corona</th>\n",
              "      <th>Nbre_pass_tot</th>\n",
              "      <th>Nbre_hospit_Corona</th>\n",
              "      <th>Nbre_acte_corona</th>\n",
              "      <th>Nbre_acte_tot</th>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>dep</th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>75</th>\n",
              "      <td>32292.0</td>\n",
              "      <td>157991.0</td>\n",
              "      <td>7679.0</td>\n",
              "      <td>12145.0</td>\n",
              "      <td>103013.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>94</th>\n",
              "      <td>14628.0</td>\n",
              "      <td>110686.0</td>\n",
              "      <td>5754.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>95</th>\n",
              "      <td>15836.0</td>\n",
              "      <td>92795.0</td>\n",
              "      <td>5146.0</td>\n",
              "      <td>3616.0</td>\n",
              "      <td>33199.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>69</th>\n",
              "      <td>9814.0</td>\n",
              "      <td>122522.0</td>\n",
              "      <td>4468.0</td>\n",
              "      <td>5549.0</td>\n",
              "      <td>47333.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>59</th>\n",
              "      <td>11530.0</td>\n",
              "      <td>197415.0</td>\n",
              "      <td>4184.0</td>\n",
              "      <td>2999.0</td>\n",
              "      <td>54832.0</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "     Nbre_pass_Corona  Nbre_pass_tot  ...  Nbre_acte_corona  Nbre_acte_tot\n",
              "dep                                   ...                                 \n",
              "75            32292.0       157991.0  ...           12145.0       103013.0\n",
              "94            14628.0       110686.0  ...               0.0            0.0\n",
              "95            15836.0        92795.0  ...            3616.0        33199.0\n",
              "69             9814.0       122522.0  ...            5549.0        47333.0\n",
              "59            11530.0       197415.0  ...            2999.0        54832.0\n",
              "\n",
              "[5 rows x 5 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 8
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "WRzRJlKd4aGM"
      },
      "source": [
        "# **J'ai utilisé plusieurs types de graphiques pour visualiser par départements mais c'est le plot \"bar\" que je trouve le plus pertinent pourcette visualisation**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "4JWMvm6YX-tD",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 279
        },
        "outputId": "4845c656-b15e-496a-b970-3f9dceebeca5"
      },
      "source": [
        "cas_par_dep.plot();"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAAYoAAAEGCAYAAAB7DNKzAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEgAACxIB0t1+/AAAADh0RVh0U29mdHdhcmUAbWF0cGxvdGxpYiB2ZXJzaW9uMy4yLjEsIGh0dHA6Ly9tYXRwbG90bGliLm9yZy+j8jraAAAgAElEQVR4nOy9d5xV1bn//16nTIGZgaENyKAUEUQZ2oBGg4ANjMYSY4sF0Bt/KBpNU0yuX02uem2JXtBIzJUiMYpdonIVe4ggjDgUke4AQx1gej1l/f5Ye5+zzzn71DkDA6z36zWvfc46u6wzDPuzn7KeR0gp0Wg0Go0mGo4jPQGNRqPRtG+0UGg0Go0mJlooNBqNRhMTLRQajUajiYkWCo1Go9HExHWkJ5BuunXrJvv27Xukp6HRaDRHFV9//fUBKWV3u8+OOaHo27cvJSUlR3oaGo1Gc1QhhNge7TPtetJoNBpNTLRQaDQajSYmcYVCCNFHCPGpEGK9EOJbIcRdxngXIcQSIcRmY5tvjAshxEwhxBYhxBohxEjLuSYb+28WQky2jI8SQqw1jpkphBCxrqHRaDSaw0ciMQov8Gsp5SohRC7wtRBiCTAF+FhK+agQYgYwA7gXuAgYaPycATwHnCGE6AI8ABQD0jjPIillpbHPz4GvgPeBScBi45x219BoNDHweDyUl5fT1NR0pKeiaWdkZWVRWFiI2+1O+Ji4QiGl3APsMV7XCiG+A3oDlwHjjd3mA5+hbuKXAS9KVURquRCisxCil7HvEinlIQBDbCYJIT4D8qSUy43xF4HLUUIR7RoajSYG5eXl5Obm0rdvXwwDXaNBSsnBgwcpLy+nX79+CR+XVIxCCNEXGIF68i8wRARgL1BgvO4N7LQcVm6MxRovtxknxjU0Gk0Mmpqa6Nq1qxYJTQhCCLp27Zq0pZmwUAghcoA3gLullDXWzwzroU3L0Ma6hhDiViFEiRCipKKioi2nodEcNWiR0NiRyt9FQkIhhHCjROIlKeWbxvA+w6WEsd1vjO8C+lgOLzTGYo0X2ozHukYIUsrnpZTFUsri7t1t14ukn4qN8P2/Ds+1NBqN5giSSNaTAF4AvpNS/tny0SLAzFyaDLxjGb/JyH46E6g23EcfABcKIfKN7KULgQ+Mz2qEEGca17op7Fx21zjy/OtP8M9fHOlZaDQaTZuTiEVxNnAjcK4QotT4+RHwKHCBEGIzcL7xHlTW0jZgC/A34HYAI4j9X8BK4+ePZmDb2Od/jWO2ogLZxLjGkae5FjyNR3oWGk27RQjBr3/968D7J598kgcffBCAKVOm8Prrrx+hmaWPxYsXU1xczJAhQxgxYkTI9z2WSCTraSkQzal1ns3+Epge5VxzgDk24yXA6TbjB+2u0S7wNICv5UjPQqNpt2RmZvLmm29y33330a1bt6SP93q9uFztt8rQunXruOOOO3jvvfcYPHgwPp+P559/PuHj2/v3s3J0zLI94mkEn+dIz0Kjicsf/vkt63fXxN8xCYackMcDPz4t5j4ul4tbb72Vp556iocffjji848++ohHH32Umpoa/vznP3PJJZcwb9483nzzTerq6vD5fLz//vvceeedrFu3Do/Hw4MPPshll11me7158+bx1ltvUV1dza5du7jhhht44IEHALj88svZuXMnTU1N3HXXXdx66634fD5uueUWSkpKEEJw880388tf/pKZM2cye/ZsXC4XQ4YM4ZVXXrG93uOPP87vf/97Bg8eDIDT6eS2224DoKysjJtvvpkDBw7QvXt35s6dy4knnsiUKVPIysrim2++4eyzz+amm25i2rRpNDQ0MGDAAObMmUN+fj7jx4/njDPO4NNPP6WqqooXXniBsWPHUlZWxo033kh9fT0AzzzzDGeddVZi/2itQAtFqmiLQqOJy/Tp0ykqKuKee+6J+KysrIwVK1awdetWJkyYwJYtWwBYtWoVa9asoUuXLvzud7/j3HPPZc6cOVRVVTFmzBjOP/98OnbsaHu9FStWsG7dOjp06MDo0aO5+OKLKS4uZs6cOXTp0oXGxkZGjx7NlVdeSVlZGbt27WLdunUAVFVVAfDoo4/y/fffk5mZGRizY926dVFdTXfeeSeTJ09m8uTJzJkzh1/84he8/fbbgFrj8uWXX+J0OikqKmLWrFmMGzeO//f//h9/+MMfePrppwFlcaxYsYL333+fP/zhD3z00Uf06NGDJUuWkJWVxebNm7nuuusOSxFULRSp4mkEbzNICToNUdOOiffk35bk5eVx0003MXPmTLKzs0M+u/rqq3E4HAwcOJD+/fuzYcMGAC644AK6dOkCwIcffsiiRYt48sknAbU+ZMeOHZx66qm217vgggvo2rUrAD/5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\n",
            "text/plain": [
              "<Figure size 432x288 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "ith3ebwEoBz8"
      },
      "source": [
        ""
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "aYT97uclncNl",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 399
        },
        "outputId": "a6284277-5169-469b-a8de-39af5d6f8a81"
      },
      "source": [
        "df_mean= data_dep.groupby('dep', as_index=False).sum().sort_values(['Nbre_hospit_Corona'], ascending=False)\n",
        "df_mean\n"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>Nbre_pass_Corona</th>\n",
              "      <th>Nbre_pass_tot</th>\n",
              "      <th>Nbre_hospit_Corona</th>\n",
              "      <th>Nbre_acte_corona</th>\n",
              "      <th>Nbre_acte_tot</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>75</th>\n",
              "      <td>75</td>\n",
              "      <td>32292.0</td>\n",
              "      <td>157991.0</td>\n",
              "      <td>7679.0</td>\n",
              "      <td>12145.0</td>\n",
              "      <td>103013.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>94</th>\n",
              "      <td>94</td>\n",
              "      <td>14628.0</td>\n",
              "      <td>110686.0</td>\n",
              "      <td>5754.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>95</th>\n",
              "      <td>95</td>\n",
              "      <td>15836.0</td>\n",
              "      <td>92795.0</td>\n",
              "      <td>5146.0</td>\n",
              "      <td>3616.0</td>\n",
              "      <td>33199.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>69</th>\n",
              "      <td>69</td>\n",
              "      <td>9814.0</td>\n",
              "      <td>122522.0</td>\n",
              "      <td>4468.0</td>\n",
              "      <td>5549.0</td>\n",
              "      <td>47333.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>59</th>\n",
              "      <td>59</td>\n",
              "      <td>11530.0</td>\n",
              "      <td>197415.0</td>\n",
              "      <td>4184.0</td>\n",
              "      <td>2999.0</td>\n",
              "      <td>54832.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>43</th>\n",
              "      <td>43</td>\n",
              "      <td>28.0</td>\n",
              "      <td>2950.0</td>\n",
              "      <td>14.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>11</th>\n",
              "      <td>12</td>\n",
              "      <td>30.0</td>\n",
              "      <td>13012.0</td>\n",
              "      <td>10.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>102</th>\n",
              "      <td>977</td>\n",
              "      <td>78.0</td>\n",
              "      <td>2436.0</td>\n",
              "      <td>8.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>97</th>\n",
              "      <td>972</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>266.0</td>\n",
              "      <td>15826.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>100</th>\n",
              "      <td>975</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>104 rows × 6 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "     dep  Nbre_pass_Corona  ...  Nbre_acte_corona  Nbre_acte_tot\n",
              "75    75           32292.0  ...           12145.0       103013.0\n",
              "94    94           14628.0  ...               0.0            0.0\n",
              "95    95           15836.0  ...            3616.0        33199.0\n",
              "69    69            9814.0  ...            5549.0        47333.0\n",
              "59    59           11530.0  ...            2999.0        54832.0\n",
              "..   ...               ...  ...               ...            ...\n",
              "43    43              28.0  ...               0.0            0.0\n",
              "11    12              30.0  ...               0.0            0.0\n",
              "102  977              78.0  ...               0.0            0.0\n",
              "97   972               0.0  ...             266.0        15826.0\n",
              "100  975               0.0  ...               0.0            0.0\n",
              "\n",
              "[104 rows x 6 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 10
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "Y1JAc_1qoCxl",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 282
        },
        "outputId": "ff8a9ab9-9db5-4c94-e157-92bc368864c0"
      },
      "source": [
        "ax = sns.barplot(x=\"dep\", y=\"Nbre_hospit_Corona\", data=df_mean)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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\n",
            "text/plain": [
              "<Figure size 432x288 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "VW4xY6a9q_ZO",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 945
        },
        "outputId": "c528f4de-5f39-4d69-a553-8df8f5ef36cc"
      },
      "source": [
        "sns.pairplot(df_mean)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "<seaborn.axisgrid.PairGrid at 0x7fce9316bbe0>"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 13
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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vhdXJcSuYkKGqoS4LXfaroqj4FdKzayaeIf0Dne/LyjebGb7uvumYAjulqB8IzAjZfHpQdlG4Jgh5U8G5dPTvD/bZ0wofdGB5EaUsKGzh77oQIlqJJXggEseGtNyb1/xyTzXREQyUfsuQykmRPJP21VxFDr7rgE/A1539x+mvPQgkMiguxh4IKV8UZCF90hgWzAE91HgBDNrDhIcnQA8Gry23cyODD5r0ZB1pfuMCSVSFWZ6c92gsunNdUSqwiWqkYiI5IPadxlKMSGSf9quiqPQw3ePBs4CjjOzl4LHycAVwCfM7A3gb4O/AR4G3gTWATcBywDc/T3gMuD54PFvQRnBe34aLPMn4JGgPNNnTCgt9RFuWjQvuTElxsG31EdKXDMREcmF2ncZSjEhkn/aroqjoMN33f2/gEx3AB+f5v0OXJhhXTcDN6cpXwUcnKa8I91nTDShlBZl8QAAIABJREFUkDF7WiP3LzuavugAkaowLfUR3ZgtIlLh1L7LUIoJkfzTdlUcRcu+K6UTChmtjTWlroaIiOSZ2ncZSjEhkn/argqvKNl3RURERERERNJRp1RERERERERKRp1SERERERERKRl1SkVERERERKRk1CkVERERERGRklH2XZFx7IBLHip1FUREREREstKVUhERERERESkZdUpFRERERESkZNQpFRERERERkZJRp1RERERERERKRp1SERERERERKRl1SkVERERERKRk1CkVERERERGRklGnVEREREREREpGnVIREREREREpGXVKRUREREREpGTUKRUREREREZGSUadURERERERESkadUhERERERESkZdUpFRERERESkZNQpFRERERERkZJRp1RERERERERKpqrUFRAZL2Ixp6O7j77oAJGqMC31EUIhK3W1RETGJbW5UokUt1KpCh276pSK5EEs5qzd3MX5K1exobOH6c113LRoHrOnNWpnIyKSZ2pzpRIpbqVSFSN2NXxXJA86uvuSGyrAhs4ezl+5io7uvhLXTERk/FGbK5VIcSuVqhixq06pSB70RQeSG2rChs4e+qIDJaqRiMj4pTZXKpHiVipVMWJXnVKRPIhUhZneXDeobHpzHZGqcIlqJCIyfqnNlUqkuJVKVYzYLWin1MxuNrMtZvZqStl3zGyjmb0UPE5Oee1bZrbOzNaa2Ykp5fODsnVmdklK+YFm9mxQfpeZRYLymuDvdcHrBxTye4q01Ee4adG85AabGGvfUh8pcc1ERMYftblSiRS3UqmKEbuFTnR0K/ATYOWQ8qvd/fupBWbWBnwe+AjwPuD/mdmHgpevBT4BbACeN7MH3X0NcGWwrjvN7AbgPOD64N9Od/+gmX0+eN/nCvEFRQBCIWP2tEbuX3a0MuqJiBSY2lypRIpbqVTFiN2Cdkrd/bejuEq5ALjT3XuBt8xsHXB48No6d38TwMzuBBaY2evAccAZwXtuA75DvFO6IHgOcA/wEzMzd/ecvpBIFqGQ0dpYU+pqiIhMCGpzpRIpbqVSFTp2S3VP6UVm9kowvLc5KNsPWJ/yng1BWabyFmCru0eHlA9aV/D6tuD9ZSsWc9q7etnYuZP2rl5iMfWfRUTGI7X3MlqKGZnotA2Mf6WYp/R64DLAg39/AJxbgnoAYGZLgCUA+++/f0nqoHmrZCzKIXZFRmuix63a+8pVqthVzEguxkObq21gYij6lVJ33+zuA+4eA25i9xDdjcCMlLdOD8oylXcATWZWNaR80LqC16cE709XnxvdfZ67z2ttbc31642J5q2SsSiH2BUZrYket2rvK1epYlcxI7kYD22utoGJoeidUjPbN+XPU4FEZt4Hgc8HmXMPBGYBzwHPA7OCTLsR4smQHgzuD30COD1YfjHwQMq6FgfPTwf+o5zvJ9W8VSIiE4PaexktxYxMdNoGJoZCTwnzS+B3wGwz22Bm5wHfM7Pfm9krwLHAVwHc/TXgbmAN8GvgwuCKahS4CHgUeB24O3gvwP/P3r3HOVXde+P/fJNMZjIXmGEYqDIoVJF2tFCYEVGe5/ystGgrai2op4p4K5ei1dNjFXtaju1Bz6NVj6e2RZBaFbxSkEePd48tp0+91RlRamkRRS2DAsMwA3PJJDPZ398f2QnJTJJJMtnJTubzfr3yYrKTnayQ717Za6+1vms5gH82kyJVA7jf3H4/gGpz+z8DCC8jY0dct4qIaHhgfU+pYszQcMdjYHiwtFGqqt9W1aNUtUhVa1X1flW9VFW/pKpTVPVcVf0s4vm3qupxqjpZVZ+P2P6cqp5gPnZrxPZdqjpDVY9X1QvMzL1Q1R7z/vHm47us/JxDxXWriIiGB9b3lCrGDA13PAaGh1wkOqJ+uG4VEdHwwPqeUsWYoeGOx8DwkHSjVEQmqupHg22j9HDdKiKi4YH1PaWKMUPDHY+BwpfK8N1NMbZtzFRBiIiIiIiIaPgZtKdURL4A4EQAI0XkWxEPjQBQYlXBiIiIiIiIqPAlM3x3MoC5ACoBnBOxvQPAIisKRURERERERMPDoI1SVX0KwFMicqqqvp6FMhEREREREdEwkcqc0t0isllE9pu3TSJSa1nJiIiIiIiIqOCl0ih9AMDTAI42b/9lbiMiIiIiIiJKSyqN0jGq+oCq9pm3BwHUWFQuIiIiIiIiGgZSaZQeEJEFIuI0bwsAtFpVMCIiIiIiIip8qTRKrwRwIYC9AD4DMB/A5RaUiYiIiIiIiIaJZJaECalV1XMjN4jILAC7M1skIiIiIiIiGi5S6Sn9RZLbiIiIiIiIiJIyaE+piJwK4DQANSLyzxEPjQDgtKpglBrDULR2+eHvC8DtcqK6zA2HQ3JdLCIiyjL+HlC2MeYoXzF27SOZ4btuAOXmcysith9GcF4p5ZhhKHbs68CidY1obvOitsqDtQsbMHlsBQ8sIqJhhL8HlG2MOcpXjF17GXT4rqr+j6r+FMBMVf1pxO0/VHVn6HkiwqG8OdLa5Q8fUADQ3ObFonWNaO3y57hkRESUTfw9oGxjzFG+YuzaS9JzSlX1k0GeMmuIZaE0+fsC4QMqpLnNC39fIEclIiKiXODvAWUbY47yFWPXXlJJdEQ25XY5UVvlidpWW+WB28Upv0REwwl/DyjbGHOUrxi79sJGaQGoLnNj7cKG8IEVGhNfXebOccmIiCib+HtA2caYo3zF2LWXVNYpHQxnBOeIwyGYPLYCm5fNYvYwIqJhjL8HlG2MOcpXjF17SatRKiIOAOWqejhi888zUyRKh8MhqKkoznUxiIgox/h7QNnGmKN8xdi1j6SH74rIoyIyQkTKALwHYLuI3BB6XFUftKB8REREREREVMBSmVNaZ/aMfhPA8wAmArjUklKRLRiGoqXDhz1t3Wjp8MEwNNdFIiKiHOLvQnz8v6F8xLglu0hl+G6RiBQh2Cj9par2iggjt0BxQWFKx4Sbnk1rv49vOzvDJSGiTOPvQnz8v6F8xLglO0mlp3QNgI8BlAH4g4gcC+Bwwj0ob3FBYSIiisTfhfj4f0P5iHFLdpJ0T6mq3gPgnohNn4jIVzJfJLIDLihMRESR+LsQH/9vKB8xbslOUkl0dJ2Z6EhE5H4ReRvAGRaWjXKICwoTEVEk/i7Ex/8bykeMW7KTVIbvXmkmOpoDoArBJEe3WVIqyjkuKExERJH4uxAf/28oHzFuyU5SSXQUmvH8DQDrVfUvIsJZ0DZiGIrWLn9GFgDmgsJEROnJZF1sJ/xdiM/hEEyqKceGJaeiN2CgyOnAmPJi/t+QrTFuyU5SaZQ2ichLCC4F80MRqQBgJNpBRH4DYC6A/ap6krltFIAnAExAMHHSharaZjZwf45go7cbwOWq+ra5z2UAfmy+7C2q+pC5vR7AgwA8AJ4DcJ2qarz3SOGz5h0rMqhxQWEiotQUejZL/i7EZhiKnS2dBfu9U2Fi3JKdpDJ89yoANwE4WVW7AbgBXDHIPg8COKvftpsAvKKqkwC8Yt4HgK8DmGTeFgO4Fwg3Ym8GcAqAGQBuFpEqc597ASyK2O+sQd6jYDGDGhFR7rEuHp74vVM+YtySnaSSfdcQkY8AnCAiJUnu8wcRmdBv83kATjf/fgjAFgDLze3rVFUBvCEilSJylPncl1X1IACIyMsAzhKRLQBGqOob5vZ1CK6h+nyC98iKXAzdYgY1IqLEslE3sy4enpL93gt1aDflp6HWV4xnyqSkG6Ui8h0A1wGoBfAOgJkAXkfqGXjHqupn5t97AYw1/x4HYHfE85rNbYm2N8fYnug9LJfO0K1MHNShDGqRlQszqBERBVk5rDayDhcRzKkbg5e27w8/zrq48CXzG1zoQ7tziY2j9Azl3JHxXPiyfVylMnz3OgAnA/hEVb8CYBqA9qG8udkrqkN5jaG+h4gsFpFGEWlsaWkZ8vulOhQidFCfv+pVzLr99zh/1avYsa8DhpHafwszqA0/mY5domzIVdxaNUytfx1+4ZrXce3sEzCnbgwA1sWFJFHsJvMbzKGS1sjUeVShGmrcxsN4Lmy5OK5SSXTUo6o9IgIRKVbVv4nI5DTec5+IHKWqn5nDc0OXk/cAGB/xvFpz2x4cGYob2r7F3F4b4/mJ3mMAVb0PwH0A0NDQMOT/6VSHQsQ7qDcvm5VSMglmRRx+Mh27RNmQq7i1alhtrDp86cNN2LDkVNx8jrIuLiCJYjeZ32AO7bZGps6jCtVQ4zYexnNhy8VxlUpPabOIVAL4vwBeFpGnAHySxns+DeAy8+/LADwVsX2hBM0EcMgcgvsigDkiUmUmOJoD4EXzscMiMtPM3Luw32vFeg/LpboQcSYP6lBWxHFVpaipYEpvIqIQqxaJj1eHqyrr4mFmsN9gq2JwuGPjaGjSPXdkPBe2XBxXSTdKVfV8VW1X1Z8AWAHgfgQTC8UlIo8hOO90sog0i8hVAG4D8DUR2Qngq+Z9ILikyy4AHwBYC2CZ+b4HAawE8JZ5+7dQ0iPzOb829/kQwSRHSPAelkt1KES8g1pEbDn0xDAULR0+7GnrRkuHz5ZlJCLqz6opDpk+MctFHct6PTsyGYPpfmeF+F2zcZQbmYrndGKyEOPYbnJxXElwymWSTxaZDuB/IThH89XQOqKFoqGhQRsbG4f8OqlMDI41Ufz2eVPw0Gsf4ftfm2yrCeOc1D5klv0nxYvdCTc9a9VbZtTHt52d6yJQYpbEbqbq3GRZkbQhk/ViLurYYVCv2yp2MxGD6X5nhfpdF+jnslXcxjPUeE43OWgBft+2M4T/57S/hKQbpSLyrwAuAPCkuembAH6rqrek++Z2k+0TpBDDUOw93INP271o7fJj9ZYPsXV3O2qrPHj6mlkIGLDFPNGWDh/OX/XqgCxtnLeRNDZK42Cj1Pby4gQpW/qfiFV5itDm7R1yPZ2LOnYY1OtZi91sZapM9zsr5O+6ALPvFlzcxpJOTBZyHNtNmrGRdvCkkujoEgBTVbUHAETkNgSXhimYRmkmpPMFOhwCVcX81a9Hba8pL8Zn7T1Y8nCTLa4Gcd4GEeWbTJ9wWXmVPhd1LOv1zMjmcnDpfmeF/F2H5kVSajJdn6Ua0+nEZCHHsd1k+7hKJdHRpwBKIu4X40i2W8LQ0ifHGrt97exJ4QYpkPt025y3QUT5xIqU9lYug5CLOpb1emZkczm4dL8zftfUXybrs3RiOp2YZBwXrlQapYcA/EVEHhSRBwC8B6BdRO4RkXusKV5+iXdw7z3ck/CgNAyFQvHwVafggctPxrTxlait8mDi6DJbXQ3iWqhElE/i1ckHunwpvU5kUg1/XwA15dFXjjNVL+eijmW9nhmZWg5usMZA//OFC+tr8cDlJ+Phq06BQhOea/C7pv4y2euYbExH1qcKxWOLgrH8xOKZeODyk7HuyhkJY5JxXLhSGb672byFbMlsUfJfvIP703YvDnl7Yw6HiDV0Ys2CehxVWYI+Q1Fb5Rkwbj5XV4O4FioR5ZN4dXK3LwCjTJOqu2LV0XfMn4KfvbADW3e3A8hcvZyLOpb1emaEem+S/b1OpzEQKxbvXVCPX7zyPl7avn/QoZf8rqm/VOM2kWRiun8Mz6kbg2tnn4AVT70XNXw4EcZx4UplSZiHEt1EZJOVBc0H8YYUhK4exboCGuvK0pKHmxAwgNFlxba7GsS1UIkoX8Srkz860JX08LRYdfQNG7fh2tmTwq+XyXo5F3Us6/Why9RycIkaA7Fi8bsPN2Fe/fjw/cF6W/ldU6RM9jomE9P9Y3he/XgsTWOaGuO4MKXSUzqYz2fwtfJS6ODuv7zLnS/uiHm1qLXLj25/X9wrS7waRESUvuoyN9YsqI9KFheqk3958bSkXiPe1f/jxpTj1eVfSWrZrwLLCkoxpPp7Het8IV5jYLDzhUpPUdR9JnyhZGXyPDOZmO5fn1Z6imw1TY1yK5ON0mG/cm3o4N6w5NTw8i53vrgjvLxL6GpR5PCFFXPrEg6dYEY5IqL0OByCoypLsPK8k1DqdqLd24s7X9yBlk5f0sPT4g1v8xQ5B62buZ7e8JLK73WyjYFkzhfavb1R95nwhVKRqfPMwWLaMBSBftPS2r29tpqmRrmVSqIjSoLDIfjciBKUFbuw8pnt4QZp5NWiyOELq7d8iNvnTbHVEF0iokJR6XHjcyNLcP1v38WS9U1o6fSlVMcOZXiblZl6Kf8lMwRxsPOF1Qvqsalpd/g+zx8olxLFdGuXH7c8uz0qhjc17ca9C+p5DkwAMttTysu+psGuFkUOX9i6ux13vrgDK+bW4Yufq4DH7eLwLiKiDBnq8LSh7M/19GioBjtfqPIU4dbzp+Dmczg8nOzN3xfAS9v3o6XDjxVz61DpKUK7txdHjSjmNDUCkGKjVEQ8AI5R1R0xHl6emSIVhkTDIfoPB9u6ux0rn9mOzctmJTWEgnOUiIiSN9Thaenun8nMliGs/+3Liu8mmfMFTvGhochWnRKK5a2727FkfROAYH2Y7LkvFb6kh++KyDkA3gHwgnn/yyLydOhxVX0p88UrTEMZDmbFYvBERJR5mV5Pj/W/fVn13XBNRrJSNusUxjINRlSTCzwRaQJwBoAtqjrN3PZnVf2SheXLqoaGBm1sbMz46xqGot3rh9cfQEAVJUVOjPK40ebtTfnKVEuHD+evenXAlXdeacoLlnVnxIvdCTc9a9VbZtTHt52d6yJQYpbErlV1bjKG0juQyr6Z7IVg/Z+WrMRupr+byLgpcjngcgi8/vzrHWfPftryMm776//9V3mK0jr3tSPGdlxp/yekMny3V1UPiUS9Fy/PDsIwFB+3dmHf4R7csHHbkDMwco4SEdHQDCUrbqr7ZjKDOut/+8rkd1MoWZsL5XMUMivrlEL+/gv5s+VSKtl3/yIiFwNwisgkEfkFgNcsKlfBaO3y45PW7nCDFBhaBsZ0FtwmIqIjhpIVN5cZdVn/21cmv5tCydpcKJ+jkFlZpxTy91/Iny2XUmmUfg/AiQB8AB4FcAjAP1lRKLsyDEVLhw972rrR0uFLasy9vy+AUrczY1eiOCafiIaTdOrdwQyldyCXvZWs/+0r0XeTagwXSo94oXyOQmZlnRL5/U8bX4k1l9bjrgumwt8XyPt58IxtayQ1fFdEnACeVdWvAPiRtUWyp1S66iPHmYsIFMhYBsahLm9ARJQvrBoiNVhW3ERzhazIqJss1v/2Fe+7ARAzhseOKI47RzSXMZZJhfI5CpkVdUqo/gSC33dNeTF+cOZkLN809ClsdsHYtkZSPaWqGgBgiMhIi8tjW8l21ffPZHbhmtcxutyNuy+cmrErUcksuE1ElO+sGiI1WK9WomyUue6tZP1vX7G+m3gx/O7uQ3GzneY6xjKlUD5HoctknRJZf17z6FbcMX8Krp09KdwgBQpjqCtj2xqpJDrqBPBnEXkZQFdoo6pem/FS2VCyXfWxfoAuf+AtPPnd0/DE4pkIKFBS5MDosuQOfGb3IqLhyqohUol6B1o6fDEbEaFslA6HYFJNOTYsORW9AQNFTgfGlLNxSLHFi+FStzP8d2R8AQPjU0TglOD5RT6dA7Bnf/iJPAdubvPiZy/swB0XTC24oa6MbWuk0ih90rwNS8l21Yd+gKaNr8TS049DpacI7d5eqCrGVZWm9J7M7kVEw5mVQ6TiZcU1DAMr5taF6+7VWz7E1t3t4RMow1DsbOlkvUxJiRfD7d7e8P3mNi8Mw0BLhy/qBLe6zJ335wCZzD5N9tf/IszW3e34sKUz5jFQ5HQMiPl8iWuAsW2FpBMdqepDAB4DsBXA2wAeM7cNC8l21btdTsypG4MfnDkZK5/ZjovuewMrn9mOA13+lCd2M7sXEQ1n2R4iZRiKA13+qLr7B2dOxpy6MeGGMOtlSkWsGL5j/hSs3vJh+Dlz6sbgQJd/wJDxdi9jjfJLrGy+m5p2Y9Ul06OOgbsvnIrDPb1xp0nQ8JR0T6mIfAPAGgAfIrgw6kQRWaKqz1tVODtJtqu+usyNH59dh4t//WbUD8mS9U0pL0bM7F5ENJxle4hUa5cfS9Y3RdXdyzdtw6PfOSXcEGa9TKnoH8NFLgc6e/rQ0ukDEDxBj3XOsGhdI55YPJOxRnkldBEmsnf/utkn4KHXPo4agdJnKC5/4K240yRoeEpl+O5/APiKqn4AACJyHIBnAQyLRimQXFe9wyFwOiSlH5J480aZ3YuIhrtsDpGK1+B0OmRI2XeZG2B46x/Do8s06kJLvLgLaGqZ+xlnlGuxLiQ6HcBru1qxoak5/LyNS09N6jyZMT28pLJOaUeoQWraBaAjw+UpCKksRpwo0yOzexERZU8ydXeq9fJg2Xxp+Omf7TRe3JUUOZKONcYZ2UX/+K70DKwzx1QUD1rXMqaHH1FN/OWKyLfMP78G4FgAGwAogAsA/F1Vl1lawixqaGjQxsbGIb9OvARFk2rK0ebtjbri02rOI+l/JTQ0hIFXiQqKZV9cvNidcNOzVr1lRn1829m5LgIlZknsZqrOzZRkk8v1X4vaKYDD4YhZP7d0+BLW8WQ528duorgDkNQ5QK7ijOcolrF93Kaif5xUeYoGTRhXSHXnMDtO0v5gyQzfPSfi730A/j/z7xYAJem+cSGLNXwh3gE4qrQo4RAGZvciIsqOZOewOhySdGZUzkGlwQwWd8mcA+QizrhCACUr1rnsYHVtodSdPE6SN+jwXVW9IsHtymwUMh/1H77Q5u2NmUUvNGckEueNEhHlRrILySebhTeV6Rw0fCUbd/HkIs6YiZqGYrCYL5S6k8dJ8gZtlIrIvya4rchGIe3AMBQtHT7saetGS4cv5THt8a74qCrnjRIRJWGo9XAmJXsVn7kBho9cxmcu4qxQerKGOzvVq5EKpe7kcZK8ZIbvdsXYVgbgKgDVAFZmtEQ2lImu90QZGyeP9WRtyQMionxktyFQyWbhzfayNpQbuY7PXMQZVwjIf7mO20QKpe7kcZK8ZIbv3hW6AbgPgAfAFQAeB/D5dN9YRD4WkT+LyDsi0mhuGyUiL4vITvPfKnO7iMg9IvKBiGwTkekRr3OZ+fydInJZxPZ68/U/MPdNO4rjdb1/dsib9FWlRFd8hjpsh4io0NltCFQqV/FZxxe+VOLTqp6pbMdZofRkDWdDqVez0cNaCHUnj5PkJbVOqYiMAvDPAC4B8BCA6araloH3/4qqHoi4fxOAV1T1NhG5yby/HMDXAUwyb6cAuBfAKWa5bgbQgGBG4CYRedos270AFgF4E8BzAM5Cmmuqxut6b27z4vrfvos1l9Zj8pgKuFzx2/ihKz5PLjsNPb0GnAJ43LxKQkSUjFSGQGUj02EqV/GHWebFYSnZ+LRzz1Qy+sfypJryvO/JGs4SxW2ieitf4zgXdXGh9Phmw6CNUhG5A8C3EOwl/ZKqdlpYnvMAnG7+/RCALQg2Ss8DsE6D69e8ISKVInKU+dyXVfWgWdaXAZwlIlsAjFDVN8zt6wB8E2k2SuN1vbd7e9Hc5sWS9U14fPFMiPncRMHW2unPu4OYiCjXRCRmPSwiUScaRS4HOnv6sPA3f7K8nk0mO3q+nrxRauKdJ6gC+zt6MLos2MsTr2cqH5a5YCwXnnhxW+RyRH3Xc+rG4Mdn18HpELhdTig07+I4l/HLlTSSk0xP6fUAfAB+DOBHEaNgBYCq6og031sBvCQiCmCNqt4HYKyqfmY+vhfAWPPvcQB2R+zbbG5LtL05xva0hLreIwP59nlT8NTWPVhzaT0qPUXoDRj45yfeRUunL26Q5/OPERFRLrmdgnVXzsDBLj9au/zY1LQbl502EU7BgBONO+ZPQU15cXhESy7rWdb7w0N1mRsPXnEydh/0otTtRLc/gFFlRfjeY1ujzgvyOekJY7nwVJe5se7KGfiktTsct8dWl8LlkPB3PW18JS47bSIu/vWb4Tr24atOybs4Zvza36CNUlUddN5pmv6Xqu4RkTEAXhaRv/V7XzUbrJYSkcUAFgPAMcccE/M5kV3v3t4APtzfiae27sF508Zh+aZtUQ3VO1/cgUXrGvHE4pnh9UnbvL3hAzV0ohQSOohbOnzs1qeUJBO7RHaTTtwahmJfhw9L1jeF69tfXTwdz23bg2OrJ6KkyIE75k/Bz17Yga2723HDxm1YMbcOS9Y3AcjtyVImGiEc/msPg8Wur8/AiqfeC8foqkum49/OOxGfHurB3S/vwK3nT8lK0pP+IwecDqDLF4BTBB63E5We9OInnxvUw1mqcbt2YQN6+4zwd7309OPC57pA8Dv/6EBX0nFsdf0Ven3DMBBQQFULet3TQmZVg3NQqrrH/Hc/gM0AZgDYZw7LhfnvfvPpewCMj9i91tyWaHttjO2xynGfqjaoakNNTU3c8oa63o8eUYLRFcX4+peOGnCQLt+0DUtPPy58df5Hm7fhb/s6cP6qVzHr9t/jovvewI1nTca08ZVHClblQcDQ8HPOX/UqduzrsE1KbrKvZGOXyE7SidvWLn+4QQoE69urH30bF804Ft97dCsuvf9PAICbz63DtPGVaG7zotJTFN4/NBwtF4a61l5oyBl/I3IvUezGitFlj7yNTw/1YOUz23HZaRNhGIblSU/6x8u3Vr2G9/d24rrH3sFF972BHXs78HFrV1rxUyjrRg43g8VtrN7DgCL8XVd6igY05p7/82e4d0F9VByvXlCPqoh6F7C+/gq9/o82b8MHLV24cM3rcd+H8Wt/OfmVFpEyEakI/Q1gDoD3ADwNIJRB9zIAT5l/Pw1goZmFdyaAQ+Yw3xcBzBGRKjNT7xwAL5qPHRaRmWbW3YURrzUkbd5e/OKV9zF+lCfmFZdKT1F4vum8+vFY+nD0j9QNG7fh2tmTAABz6sbgsUUz0Wco1l85A48tOgU15cVcVJeIKEK8K9yHvL3Yurs9XLe2dfVi6enHobbKg25/8Op4IWSqAAAgAElEQVR3aDgvFPj7wS7saevG/sM92Jcge3qqWSUTPX+ojRC7ZR2m2OLFaOiEfvmmbegz4yI08urV5V/B5mWzwtN94sVRKvEYK15u2HjkgvkNG7fhk9butOKHWUQLT7y4VdXwd93u7R3QmPv6l47CL155Hyvm1uGJxTOxYm4d7nnlfbR5e6OeFxmP08ZXYsXcOnT5+rD3cE/SDdNE8R96/Xn14wd0FPWvJxm/9pdU9l0LjAWw2Zyf6gLwqKq+ICJvAdggIlcB+ATAhebznwPwDQAfAOhGcEkaqOpBEVkJ4C3zef8WSnoEYBmABxFcwuZ5pJnkqD9/XwAvbd+PefXjYw5d6PYHwsN4b/r6F2Ie7MeNKcebPzwDB7r8+PbaN6LmQd18bh1++vR2DicgIjLFG/K4v8MXvt/cFpzLV+Fw4a4LpsJQxROLZ6Ld24ufvbADPzr7i5i/+vVwXTuqzI0nm3bjm9PHR+UASDUZxmDPH2rmRQ45yw9FTkfchIhA8Ds70OnH4Z4+TB5bMWAOW7w4mlRTjp0tnUnHY6LGcejvUrczrfhhFtHCEy9ui5yO8HdtGAZWL6gPd7LUVnkwYXQpXtq+Hy9t3x/1ejefEx1XoXicNr4SPzhzctSUt8Hq1dCQ34ChuOXZ7Xhp+/4B+4VeP1Zvbv96kvFrfznpKVXVXao61bydqKq3mttbVXW2qk5S1a+GGpgadLWqHqeqX1LVxojX+o2qHm/eHojY3qiqJ5n7XGNm7h2y0MnR6i0f4vZ5UwYMXSgvduHOF4PzmmJdXaqt8sBT5ITD4Rgw1Cd0pf/a2ZM4nICIyBTrCvcd86dg9ZYPw88JXRQ8amQJ7v/jLnx77Zu46L43sGR9E1o6feEr5qG69tP2Hlw041jc/fKOqKvpqa5LnUxP5lDW2uOQs/xxx/zoc4Lb5x2J0doqD/Ye7onbyx0vjvZ3+lJa/zRgaMx4CTWOQ8dJuvFTCOtGUrT+cXvH/CkAjnzXDocD9/TrFd132JdUvRSqv2LNS00Ux5FDfi/+9Zu47LSJ4akZkfuFXj/e+Xb/8jB+7S1XPaV5KzIT750v7sDK807ChNGlcIjgYJcPRS5BS2fw6v2mpt24d0E9vhtxdSk05n5fR0/MqzqlbifGjijhcAIiIlP/K9yhZV9CdW3oRGrsiBKUuB34l2/U4dszjsU9r+xES6cvPHolJFTXHuzyY179+Kir6YOtS93/6r7VPZmxsr9zyJn99PQGsPntPXjg8pPhcgoEgn9/bju27m6PSoQYLzbixVFvwEg6vlq7/Ljl2e24fd6UqB6pUBKwyOOE8UNAdNw6HYKAoVj7h1245ozjw88JjRCM7BWdNr4SaxbUY0nE+W2seilUf3X5+lKK4/4XYpZvOpK8LnK/0Ovf/fKOAXHPejL/sFGahrEjivHE4pkIqEIgWPnMX8LDCu66YCruvvDLqCorwu6DXhiGgRVz6zBpTDl27u/EPa+8nzADX7c/gNJiJ6/e0LAy4aZns/p+H992dlbfj4au/zpvo8sUTy47DT29BpwClBQ54O8z8FFLd3jJmFu+eRJqKorx4//7Z2zd3R7eN1TX+gPBxDORV9MHW5e6/xICVmdT5ZCz/FDscuD86eNwxYNvobktuK7jj86uw9VfmYS9h3vCI6jm1I2BiGBPW3fUdxl3vcg4wytjxVeo8dDS4ceKuXXh5eo+P7oMP//2NDgFQ8q+S4Wnf9yGLlwURySGixWbLZ0+HFVZMqBeAjBgNYnJYyuw93BPSnGcaAh65H6h+vHW86fAMAxsWHJq3Oy7ZH85y76bj/r6DDS3dWNXSxfe+/QwbnlmO5rbutHScWRY2PW/fRfV5W787IW/we1y4CdPb8fKZ7Zj5/5OLFnfhJe274e/LxB3ONqx1aUYXcb1koiIIvVPdgEAYypKcMyoUhw10oO9h324YM0bmL/69XC205+/8j4gwPe/NnlAXVtVVoRNTbsxpqI46mp6rLo5chhm/6v72UiewSFn9hcwFDdsPDI88aXt+3HJr99EZWkRVj6zPdwgvXb2CeEMoT/avA3Nbd3Y09YNhWLdlTMGxNGY8uKk4yvUeNi6ux1L1jfhovvewE1P/hkOhwPHjCrFuKpSjCpj/NAR/eM2NL0hkESytkqPO6peAhDOhPvep4fxSWsXmtu6YRiKz40oSTmOI0UO0e2/X6h+HDvSg6MrPawn85hkaKplQWhoaNDGxsaYjxmG4q97D2PJ+ibUlBfj2tmTcEx1KTq8vagqc2PvoR60e3uxesuH+NUl09DtN9DR04v27l5UlRXhp08fGcYTuspuGIoDXb7wlX5ewSx4ln2x8WI32z2Q+YI9pSmzJHYT1bmRDEPxcWvXgAXeJ1SXAQD2Hu7Bp+1etHb5sXrLh+G69rZvfQkTR5fhqJEeHOj0wdsbgKGKvYd68MCrH+G6r56AyWMq4Oq3XEwoyUZoXep7XtkZ7mmNrMP7P589mbaUldj9+8EuXPfYO1h6+nGo9BSFzwfu+fY0lBQFEwuJCC5c8zpqyotx41mTUV7swncfeTvcQ7Xm0nqMqyxBly86jpKNr1STdJGt5TRuf/7taThmVGn4ef1jsMpThDZvb1RMtnb58aPN23DZaROjhtGuubQek8dU4KDXj57ewdfLjRXHay6tx+gyNxwOB+tX+0v7y+Hw3SSF1iCrKS8ekEEsNF+jpdOHuy+cim5/AJc/cGQoxN0XTgUw8MqQwyEYU1GSy49FRGR77V4/9h3uiVrg/Y75UzCy1IX9h/1RJy+huXtbd7fj6EoPPO7gdIgxI0rCJ1bHjHLg1vOnxD25CV15NwxFly967mqsq/v9hxbT8FNW7MSNZ00O9zqFYrS02IFqc/TTnrbu8DlET6+BGza+HdVDtWR9Ex79zimorSqNistk44tDvSlV8eK2rDj6Ql1kDMa7+DGixBVzaZZQXF/86zejnl/piT2ahHE8fHH4bpJCY9xjZRCLXAPs+xvexe6D3qjHv7/hXfzy4mlR65EREVFyvP5AzCFmXr8RMyHG9XNOQG2VB5+0dqPHHwhnzU11GGzkyVH/NSWJIgUMxIxRX6+Gh5x73E5cO3sSlm/ahlK3M+a8uf0dviGtQcuh3pSKeHEbMIKPx1ojNF6maBFBdZk7blynstYy43h4YqM0SaEx7vHWQuq/Blj/xwFEHVipLs5ORDRcBVRj1ruGEXv70ZUe/PLiabjnlZ3Y3ebF+atexY59HUnVs7HmrvLkiAbT2xc7S+6n7V7Muv33OH/Vq9h32IeJNWVobvPGXcIiNESSKBvixW1vnzFgaZYj9WjsfZwCjKkojhvX/Z/POKf+2ChNUmiid7c/EPOA6zUvK4WyOvZ/PDLDWPwDnQ1TIqL+SopiJ75wOR1Y8r8nDNj+SWt3eMmY0JIag12ZB1g3U/pEJOHJeCgG3WY23dVbPsRdF0yNSvxy1wVTsalpN9egpayJF7ciErdHNKCIuY/D4cDRI4PzPyPjes2l9djUtDu4jMyl9Xhi8Uw8cPnJ8LgZ5xSNjdIUlBc7cfyYMtx7SfQBd8f8KSgvcWFO3RisumQ6Jo0twwOXn4xp4ytjzkFKZrF1IiIKGl1WjLWXRmduvPvCqWjp6MH8k48JN0xDc0rveWUnjhrpwa8unobyEld40fXBrsyzbqZ0edyCexdEnxvcu6Ae7392OPycUG/S2oUNqKlwo7jIgZXnnYQnFs/EyvNOQkmRAyvm1kGhHEVFWREvbj1uibs0i6qGM+lOG1+JBy4/GQ9fdQoUwSkSX/zciOgpD2MqcNPXv4gbz5qMlc9sx0X3vYEVT72HfYcZ3xSNiY6SYBiKvYd74OtT7D7YjVFlRVh53kkodTvR7u0NJzl6fPFM/Nt/HVmzdPWCehxdWTIgw5jVi60TEeWzWNlGx44sjqp3//25v6Gl04eV552EBadOxBlf/Bzavb2488Vgffz3g8FMvff/cReWnn4cVj6zHUWuxNdhWTdTurp9Bp55pxkPXH4ynA5BwFBsbPw75jccg7v+eyeAI71Jk8dW4CfnnoQL17w+YN3GR79zCr616jVmz6WsiBe3C0+bmHAN5sljPXj6mln4rL0HSx5uGhCv/RNzlZe4sPA32wZc8OufyZyGNzZKBxEry9jqBfV4/s+fYUNTc9RzD3t78dL2/QCCB9zSh5uwedmsAT8mVi+2TkSUr+ItB1BVWgR/wMA9zx9ZngUASt1OGKq4/rfvDsjA29Lpw4q5daguc+OO+VPgGuTEnnUzpUsEOOOLn8MVDx7JvH/XBVNRUhS8EBI5asrhEGicedKxEsLwxJ2sEi9uRY5MW+ufZTcUwwED4QYpkDhe481d5QU/isThu4OINZxr6cNNuGb28di49FQ8sXgm1lxajzl1Y1BS5MS08ZXhfeMdcNlYbJ2IKB/FqnOXrG/CrpYurHxmO35y7om4sL4WwJE5/EVOB55YPBNPLJ6JFXPrwkvCNLd5UV3mxkhPEX72wg50+gIJh4uxbqa0KcIXRoBg3F7/23fhFInK3AwgnECLCWEo5+LELXTw7OOJRpb0T+QZuuAXiRf8qD/2lA4i3kEXMBT/9MQ74atH914yHU/86RMsPf04LFnfBCB4wAUMDS9FEMI1mIiIYotX59ZWlaKmvBhXP/o21l05A+1eP645YxJGeFxwOwX+AHD/H3eFR6sAwTp4VJkb1294Fy2dPny4vxNdvr64wyFZN1O6+uL0fPap4phRZQCiRwHUlBfjjvlTotaHXHNpPX7+3+9HvQZP3MlKieIWSLxGbryRJQFDcf6qV6N6VyfVlMftdSUKYU/pIIpcjphXdwCgpjx4oDa3efHdR97G9AnV4QMsNITslme3x0ySwTWYiIgGindFXQT4ybl1aG7z4mCXHzec+QX88nc7caDDj8M9fbhwzeu4dvYJmFM3JrzPqkumY/WWD9HS6QsnQOL6eGQFlyP2uYLLceQ0K3IUwNbd7fjZCztw5wVT8YcbTscTi2ficyOLcdPXv8ieesqaZOI2nsiRJaGER+uvmoFPD/VEnR8vWteINm8v13ymQbGndBAuh2DVJdOx7JG3o+Yr/Z/n/orr55yABff/CQDCw8RGlbnxxOKZ4YQbW3e34+ZzOPSGiCgZ1WVurFlQH5U84/Z5U3Drs9uxYu6J4SGOAUPx0vb9WPwPx8HtcqCmvBhLH27Cb5ecih+dbaDI6YDbKZhXX4vZdWPD9TEADoekjHMKBvR83jF/CpwR59yhUQDTxldi6enH4eiRJTAUuPjXb0b1Hj19zSx4/eypJ+slE7fxhEaWxEp49KuLp8MhwKeHerB6y4fw9wUS9roSAWyUDsrrD0AArJhbh0pPUVRjc/nXv4hp4yuxdXc7aqs8qC53o9vXh9ue/1v45IdDb4iIkudwCKrKimLWuT86uw63z5uCh177CPPqx4eH5x7s8uMHZ07GnS/ugK/PwKrff4DXdrVizYJ6lJe40O7tDb8+62SyQk+fgZ+9sCMqbn/2wg785z9+Ofwct8uJOXVjcNlpE7F80zasmFuHlc9sj5koZlxVaa4+Cg0jycRtIvESHl396Nvh+L5j/hSuSUpJYaN0EG6XEwc6/VE/HEDwxObvrd3hpQbWXFqPYpcDHx/w41++8UVcsOZ1Dr0hIkqDKmLWuS6HwO104MazvgBfr4EHrzgZjR+14tjR5Vi+aRtWnncS+gzFon/4PDY0NWPJw03hE6NQY/b7X5vMOpkyzuUQtHT6wjklgCMxCwTnkyoUPzq7DrtaulBTXoxKTxEzklJODRa3yfD3BVBTXhzVsF295cNwfN+wcRueXHaaFcWnAsM5pYOoLnPj2OpS3DF/StQ8j7sumIp7XtmJSWPKgydCAQP/+XJwLbLRFW68tvwrePoajpknIkqVx+3AI985BRuXnhrObr7qkuno9vfh+xveQVuXH32GAV9vAF8+tgolRQ40t3lxTHUpvP4+OM06t7nNizEVxWhu82L5pm346bknsU4mSxS5glN9Is8TVl0yHUUugWEoPm7twl/2HMbeQz0AgJvPrYOhyoyklFOJ4jZZHrcTN541GSuf2Y6L7nsDK5/ZjhvPmgxDFdPGV2LF3Dp4/YFwJl6ieNhTOgiHQ1BZWgSXU7D+qhkIGIq9h3pw2/PBhdt37u/EkvVNmFM3BtfOPgFL+y0iXOnhFXkiomQZhuKzQ8Er95FrQzd+dABHVZWhuc2L7294FyvPOym8zzHVpait8qClwwevP4CSouBJfW2VB+XFwZ+55jYvfH1GTj4TFb7ePsWz7+7BA5efDKdDEDAUGxv/joWnTUS71499h3uw4qn3oubtlRQ5cPu8KVi+aRszklJOJIrbZPUZGp6TCiDcO/qLb38ZPzhz8oD45oVBioeN0iR4/QFc99g7Aw6uey+Zjn996i8AgHn148MNUuDI3JAnl50GgXB5ASKiJLR2+cMNUuDI2tDrrpyB6ze8G95W6nbC7XLA32dAEEzW4SlyYFRZEdb+YVc4QVJPb3AoZG2VBx8d6EJZsSuvkm0YhqK1y8/fEJsTAf5h8lhc8eBbUQm6RILnELFO2tdfOQP3bvkrHv3OKXA6hN8vZV2iuE1Wb58Rcxh6pceN7z32p5hzpvOpDqbsYaN0EIahEBH85NwTUVHiwuOLTkFPn4EDnX50+vrCCY2qy9wxD8puXwAL7n+TV4mIiJJgGMaAuUmhejaktsqDbn8A1eXF2H2wG8UuByaOLkNvwMDBLn84425kQqTb503BnS/uwC8vnpajT5a6yHUt+Rtib6rAzr2H8OiimTBU4RDB77Z/hgnVpQjEWQvS6RDcev4UNkQpZxLFbbLirVfqcAjnTFNK2ChNINYJwV0XTMX9f9yF780+Ac+80wzgyALtsQ7Kjw508SoREVESDENxoOtIYrlQY/Kh1z7CJ63duOnrX8D9f9yFK2ZNhMftREmRYPwoD8ZWlMDhEOzY14GrH90a3nfVJdPD2dPvfHEHWjp9kFS6AHIscl1LgL8hdlZa7EDDxNG4eO0bUcPOS4sd6A0g5vlBidvJ75FyKlHcJiu0Xmn/i2ced+zGKudMUzxMdJTAgS7fgBOC63/7LhaeOgHffbgJl5w6ERuXnooVc+uwesuHuH1edDKkNQvqcc8rO6Nek1eJiIhiizV0d/mmbfjx3Do8/+fPcP1v38XN55wIAFj1+w8gEEwYVQaXyxFeMy+0OPuGxcEr/9995G0sWd+Elk4fbp+X3Pp7dhFa1zISf0PsyeszBkzhWfpwE7w+A6PLirF2YUPU+cHahQ0YXcYGKeVWorhNVv+6d/OyYJLPeHHPOdMUD3tKE/D1xj4hOLoyeOWntdMHX58Rvqrf7vVj/VUz4HI4UFLkhNMBtHT6ovbnVSIiotjiNcL6Aorzp4/DhqZmeHuD8/NunzcFCqDT34uujiPzLUM9Ty0dPqz6/QdRQ4Efeu0j3Hr+lBx8svTEGxbH3xD76TNiD9HtMzTqpN3fF0CRywGXQ/DZIS/nkVJOJYrbSIPNbXc4JGavf2TcM9ZpMGyUJuAQiXNC4MADl5+Mnt4A7nxxB1aedxLGj/Jg90EvVIFxlcGx9IahMYc08CoREdFA8Rphn7R24/gx5ZhTNwYlLidWzK3DQ699hG/POBbjR5Xiq//xPwPmW1aXufH9r03O6/o33rC4fPoMw4XTEft8IbQ8UeiknfOEyU4Gi1tgaHPb4zVWiWLh8N0EHA4MGJJ7+7wpMFSx4qn34BBBTUXwynxFsQsnjRuJCdVl4YM03pAG/vAQEQ1UXebG6gX1A+rce17ZCX+fgWvOmAR3kQObmnbjstMm4p5XdiJUnYbmW7Z2+QEURv1bCJ9huHBI7POF/l9VvHnCobglyqZk4pYxS9nCntIEnA4HHnrtowHDvxaeOiE8v/SxRTPhdgrGjvTEfA1eJSKynwk3PZvWfh/fdnaGS0KRHA7BUZXFWHneSSh1O9Hu7Q0nKPrskBc3PflnPPKdU3DDmV/AjRu3oaXTh0DEMLP+8y0Lof4thM8wHKgi5vnCT8w50CGcJ0x2kkzcMmYpW9hTmsDosmLceNYX4HYG/5vcTge+d8Yk3PXS+wBC4+4NFLn430hElAkji904rqYsPHyspsKNuy6Yirteeh/Nbd7wsi8tnT6sumQ61v5hV3hfzreknBHge2dMGnC+gH49paEh6pEYt5QzScQtY5ayha2pQRS7HBg/qhQ1FcUYP6oUHveRg7C2ygOXw4FKD+f3EBENlWEoPjvshT+gGFXmxnE15fjx3Dr8aVcrtu5uR22VBwc6/RhX5cGGJaeiqrQIr+1qBcDMjpRbLocDpcXOqPOF0mInXI7o06zQPGFmJCU7SCZuGbOULQU9fFdEzgLwcwBOAL9W1dtS2f9Qjw9t3b1Y9sjbUeve/Z9vnYTvrGvCmkvrcdSIEs7vISLKgMM9/ph17vyTa/HnTw9h0f/+PKrLi3H0yCPJ5JjZkeygyAl0+QIDYndUaVHU8/pn4mXcUi4lE7eMWcqWgm2UiogTwK8AfA1AM4C3RORpVd2e7Gt0+ww8++4ePHD5yXA6BAFDsbHx71h42kRsXjaLByURUQZ1+QIx69wFp07EzeecCI/biUqPOyqZHOdbkh10+w388nc7w3PzegMGfL0GDvcE0Gf4os4XGLdkF/3jtt3bi1/+biduPudEVJUdeV46MTvYMjJE/RVsoxTADAAfqOouABCRxwGcByDpRmmRU3D21HG44sG3oq4gFTn5g0JElGnx6ly3S9AXUIwqY71L9iQCXHbaRCzftC0cu3fMn4J/evwdtHT6uOwL2VKsuL193hTIEMOUSx9ROgp5Tuk4ALsj7jeb25LWG9DwkAYgmNho2SNvozegg+xJRESpSlTnMqkG2Zkqwif2QDB2b9i4DUtPP45LaJBtxYrb5Zu2QYd4mstlZCgdhdwoTYqILBaRRhFpbGlpiXqsz9CYabD7DDZKKfcSxS6RXaVT5wYMZVINyrlEsatAzNit9BSF/+YSGpQL6cTtUM9yuYwMpaOQG6V7AIyPuF9rbouiqvepaoOqNtTU1EQ9VuR0xEyDXeQs5P82yheJYpfIrtKtcznki3ItUewWx1k2o93bG/6bvf2UC+nEbfEQY5XLyFA6Crl19RaASSIyUUTcAP4RwNOpvMCY8mKsXlAflQZ79YJ6jCnnvCYiokxjnUv5KtayGXfMn4LVWz7kEhpkW1Yt98JlZCgdBZvoSFX7ROQaAC8iuCTMb1T1L6m8hsvlwBfGVmDDklPRFzDgcjowprwYLlcht+WJKJ4JNz2b6yJY5uPbzs51EVjnUt7qv2xGkcsBl0Pwy4unMfMo2ZZVy71wGRlKR8E2SgFAVZ8D8NxQXsPlcuDoSs/gTyQioiFjnUv5KuayGWWxn0tkF1YtUcSljyhVvPxMREREREREOcNGKREREREREeWM6FAXIyogItIC4JM4D48GcCCLxRkKltUaQy3rAVU9K1OFiZQgdu32/2un8rAsscUqiyWxm2d1LsuTmN3KAwTL9DfGriX4Ga01nOtclsNeZQBSK0fasctGaZJEpFFVG3JdjmSwrNbIp7KG2K3MdioPyxKbXcpil3KEsDyJ2a08QO7KZMf/i0zjZyw8dvm8LIe9ypDNcnD4LhEREREREeUMG6VERERERESUM2yUJu++XBcgBSyrNfKprCF2K7OdysOyxGaXstilHCEsT2J2Kw+QuzLZ8f8i0/gZC49dPi/LcYQdygBkqRycU0pEREREREQ5w55SIiIiIiIiyhk2SomIiIiIiChnbNcoFZHvi8hfROQ9EXlMREpEZKKIvCkiH4jIEyLiNp9bbN7/wHx8QsTr/NDcvkNEzszV5yEiIiIiIqL4bNUoFZFxAK4F0KCqJwFwAvhHALcDuFtVjwfQBuAqc5erALSZ2+82nwcRqTP3OxHAWQBWiYgzm5+FiIiIiIiIBmerRqnJBcAjIi4ApQA+A3AGgI3m4w8B+Kb593nmfZiPzxYRMbc/rqo+Vf0IwAcAZgz2xmeddZYC4I03q26WYezyZvHNEoxb3rJwswRjlzeLb5Zg3PKWhVvabNUoVdU9AO4E8HcEG6OHADQBaFfVPvNpzQDGmX+PA7Db3LfPfH515PYY+8R14MCBoX8Iohxg7FI+YtxSvmLsUj5i3JKd2apRKiJVCPZyTgRwNIAyBIffWvmei0WkUUQaW1parHwrooxi7FI+YtxSvmLsUj5i3FK+sFWjFMBXAXykqi2q2gvgSQCzAFSaw3kBoBbAHvPvPQDGA4D5+EgArZHbY+wTRVXvU9UGVW2oqanJ9Ochsgxjl/IR45byFWOX8hHjlvKF3RqlfwcwU0RKzbmhswFsB/B7APPN51wG4Cnz76fN+zAf/52qqrn9H83svBMBTALwpyx9BiIiIiIiIkqSa/CnZI+qvikiGwG8DaAPwFYA9wF4FsDjInKLue1+c5f7AawXkQ8AHEQw4y5U9S8isgHBBm0fgKtVNZDVD0PDjmEoWrv88PcF4HY5UV3mhsMhuS4W5RnGERFR4WIdT/nK6ti1VaMUAFT1ZgA399u8CzGy56pqD4AL4rzOrQBuzXgBiWIwDMWOfR1YtK4RzW1e1FZ5sHZhAyaPreCPDSWNcUREVLhYx1O+ykbs2m34LlFeau3yhw9UAGhu82LRuka0dvlzXDLKJ4wjIqLCxTqe8lU2Ytd2PaVE+cjfFwgfqCHNbV74+zhqnJLHODpiwk3PprXfx7edneGSEBFlBut4ylfZiF32lBJlgNvlRG2VJ2pbbZUHbpczRyWifMQ4IiIqXKzjKV9lI3bZKCXKgOoyN9YubAgfsKGx9tVl7hyXjPIJ44iIqHCxjqd8lY3Y5fBdogxwOASTx1Zg87JZzKhHaWMcEREVLtbxlK+yEbtslBJliMMhqKkoznUxKM8xjoiIChVF1AgAACAASURBVBfreMpXVscuh+8SERERERFRzrBRSkRERERERDnDRikRERERERHlDBulRERERERElDNslBIREREREVHOsFFKREREREREOcNGKREREREREeUMG6VERERERESUM2yUEhERERERUc6wUUpEREREREQ5w0YpERERERER5QwbpURERERERJQzbJQSERERERFRzrBRSkRERERERDnDRikRERERERHlDBulRERERERElDNslBIREREREVHOsFFKREREREREOcNGKREREREREeUMG6VERERERESUM2yUEhERERERUc6wUUpEREREREQ5w0YpERERERER5YzLyhcXkRoAywHUASgJbVfVM6x8XyIiIiIiIsoPVveUPgLgrwAmAvgpgI8BvJVoBxGpFJGNIvI3EfmriJwqIqNE5GUR2Wn+W2U+V0TkHhH5QES2icj0iNe5zHz+ThG5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PpNCUWyJFJfyoMjYUNBKqXPuHzK8dU6afR3w1QznuQu4K832zcCpaba3pPuMUjXWx5CJlALlMykUxZZIcSkPipS/YnTfFREREREREQFUKRUREREREZEiUqVUREREREREikaVUhERERERESkaVUpFRERERESkaFQpFRERERERkaJRpVRERERERESKRpVSERERERERKRpVSkVERERERKRoVCkVERERERGRolGlVERERERERIpGlVIREREREREpGlVKRUREREREpGhUKRUREREREZGiUaVUREREREREikaVUhERERERESkaVUpFRERERESkaFQpFRERERERkaJRpVRERERERESKRpVSERERERERKZqiVUrN7Jtm9lsze9PMfmFm48zsJDN71czeNrOHzCzg7VvjvX7be//ElPN819u+w8w+nrL9PG/b22Z23ej/hSIiIiIiIjKUolRKzWwacBUwzzl3KuAHvgCsBn7knPtToBX4knfIl4BWb/uPvP0ws9necX8OnAesMTO/mfmBnwCfAGYD/+DtKyIiIiIiIiWkmN13q4CgmVUB44E9wMeA9d779wB/7/2+0HuN9/45Zmbe9gedcz3OufeAt4HTvZ+3nXPvOufCwIPeviIiIiIiIlJCilIpdc7tBm4B/ki8MnoI2AK0Oeci3m5NwDTv92nALu/YiLf/5NTt/Y7JtF1ERERERERKSLG679YTb7k8CTgeqCXe/bYYaVlqZpvNbHNzc3MxkiAyLIpdKUeKWylXil0pR4pbKRfF6r77N8B7zrlm51wv8CiwAJjkdecFmA7s9n7fDcwA8N4/CmhJ3d7vmEzbB3DO3emcm+ecm9fQ0JCPv01kVCh2pRwpbqVcKXalHClupVwUq1L6R2C+mY33xoaeA2wHfgks9va5FHjc+/0J7zXe+//lnHPe9i94s/OeBMwEfgW8Bsz0ZvMNEJ8M6YlR+LtEREREREQkB1VD75J/zrlXzWw98DoQAbYCdwJPAQ+a2fe9bT/zDvkZcK+ZvQ0cJF7JxDn3WzN7mHiFNgJ81TkXBTCzK4HniM/se5dz7rej9feJiIiIiIhIdopSKQVwzl0PXN9v87vEZ87tv2838NkM5/kB8IM0258Gnh55SkVERERERKRQirkkjIiIiIiIiFQ4VUpFRERERESkaFQpFRERERERkaJRpVRERERERESKJutK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\n",
            "text/plain": [
              "<Figure size 900x900 with 30 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "gXfBQCid313x"
      },
      "source": [
        "# **J'ai utilisé plusieurs types de graphiques pour visualiser par départements mais c'est le plot \"bar\" que je trouve le plus pertinent pourcette visualisation**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "HajIJvB4rPHf",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 274
        },
        "outputId": "89564ece-6efb-4da6-fb98-ed98d00cd030"
      },
      "source": [
        "ax = df_mean.plot(kind = \"bar\")"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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v/9+IPnPnT/44IOcccYZpKWl0a1bN5566qlqC9+hwpWG4zjVQm07T2PAgAGMHRs+jZeM0nj88ceZNm0aM2fOJCsri+nTp5PMy9QRBQUFlQpvdeFKw3GcauFQn6cBsGbNGvr370+7du2KfY792WefJSUlhTPPPLPoHY+yztPo3bs3t99+O2lpaZx55pnMnDmzKGwjR45M+oyM3/zmNzz22GNFX89t3LgxQ4YMAWD69Omkp6eTkpLCDTfcwJ49e4DwyfUxY8bQpUsXXnjhhVLDDXDcccdx5513Fn25d/369QD885//5KyzziI9PZ3zzjuvSF6VuNJwHKfaGDFiBM888wzbtu3/wcToPI3XX3+d4cOHk5eXB4TzNF588UX+/e9/c99999G3b19mzpzJe++9xx133LHf13LjZGVlMXnyZObPn8/kyZNZtWoVa9asYcyYMbz77rtkZWUxa9YsXn31VbKysorO05g/fz7Dhg0rcmfXrl1kZWXxl7/8pdhHFiF8mHDAgAE88MADZGVlcdppp+0Xju3bt7Njxw5OPfXU/Z7l5eUxdOjQonDu27ePxx5LfMS7efPmzJ49m3PPPbfUcAPs3LmTHj16MHfuXM4991z+9re/AXDOOecwY8YM5syZw6BBg/j9739fXvZUCFcajuNUG4f6PI1+/frRpEkTGjVqRMeOHVmxYgWzZs2id+/etGjRggYNGnDNNdfwwQcflHmeBsDgweH1tHPPPZft27eXeRhTRfjiiy9o27Yt7du3B2DIkCF88MEHRc+vvvpqgDLDDXD00Udz8cUXA9C1a1dycnIAyM3N5cILLyQlJYUHHniAzz//vMrCHeFKw3GcauVQnqfRsGHDovv69euXuy5S1nka5YUtWRo3bsxxxx3HsmXLDsoeUOaphHGOOuqoojDF43nrrbcycuRI5s+fz1//+tei0VtV4ltuHacOUJNbZA/leRql0b17d2677TY2btxI06ZNefbZZ7n11ltLPU8jYvLkyfTp04ePPvqIJk2a0KRJk2JuJnNGxs9+9jNGjBjB5MmTady4MV9//TUvv/wyV111FTk5OWRnZ3P66afz9NNP06tXr6TDXR7btm3j5JPDCRKTJk1KNokOClcajuNUO6NHj97vk+XReRrbt28v9zyNUaNGkZqaSmFhIW3bti1aNE+WVq1acf/999OnTx9UlR/8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\n",
            "text/plain": [
              "<Figure size 432x288 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "KCa3gtElseHC",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 584
        },
        "outputId": "46e8038c-6158-4353-abf1-368f5b9ba9f9"
      },
      "source": [
        "ax = df_mean.plot(kind = \"bar\", figsize=(25,10))\n",
        "ax.set_xlabel(\"départements\", fontsize=16)\n",
        "ax.set_title(\"distribution par départements\", fontsize=16)\n",
        "\n"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "Text(0.5, 1.0, 'distribution par départements')"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 15
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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nj2b888/n8LCQtq3b8+NN95YeeyCCy7gtNNOo3Pnztx+++0AVFRUUFxcTJcuXcjOzq6sc9q0aZx66qnk5OQwePDgWue76aabuOGGGzjllFMAaNy4MVdccQUAZWVl9OnTh5ycHPr27cu6deuA1ErzUaNGcfrpp3PttddSWlpKjx49yMnJ4cILL+Svf/0rAIWFhUyYMIGCggI6dOjAH//4x8pxe/bsSbdu3ejWrRvPPvvs3t+IeuAe15IkSZIkSZIajNGjR5OTk8O1116727GysjKWLFnC6tWr6d27N6tWrQJg6dKlvPTSS2RlZXH99dfTp08fZs2axaZNmygoKODss8/m8MMPTzvfkiVLWLFiBc2bN6d79+6ce+655OfnM2vWLLKysvjkk0/o3r07AwcOpKysjA0bNrBixQoANm3aBMDkyZNZu3YtTZs2rWxLZ8WKFbVuDTJ27FiGDRvGsGHDmDVrFldddRXz588HYP369Tz77LM0btyYnJwcpk+fTq9evfiP//gPbrzxRn7+858DqRXZS5Ys4ZFHHuHGG29k0aJFHHvssSxcuJBmzZrx5ptvMmTIEEpKSur4buw/V1xLkiRJkiRJajBatGjB5ZdfzrRp03Y7NmjQIBo1akT79u1p164dK1euBKBfv35kZWUB8PjjjzN58mRyc3MpLCykvLy8cvVyOv369ePoo4/msMMO46KLLuKZZ54BUquou3btSo8ePXj77bd58803adeuHWvWrGHs2LH87ne/o0WLFgDk5OQwdOhQfv3rX9Okyf6tNV68eDHf+ta3ALjssssq6wC45JJLaNy4MZs3b2bTpk306tULgGHDhvH0009X9rvooosAOO200ygrKwNg+/btfPe73yU7O5tLLrmEV199db/q21d7Da5DCCeGEJ4MIbwaQnglhHB10p4VQlgYQngz+d0qaQ8hhGkhhFUhhJdCCN2qjDUs6f9mCGFYlfbTQggvJ+dMCyGEPc0hSZIkSZIkSbUZN24cM2fOZNu2bdXak9hxt9dVV1PHGLnvvvsoLS2ltLSUdevW0alTp1rnSjfmU089xaJFi1i8eDHLly8nLy+P8vJyWrVqxfLlyyksLGTGjBl85zvfAeDhhx9m9OjRLF26lO7du9e6F3Xnzp158cUX634jErWtFq+padOmQGoLkl01TJ06leOOO47ly5dTUlLC3/72t32ef3/UJb7fAYyPMS4NIRwJvBhCWAgUA0/EGCeHEK4DrgMmAOcA7ZOf04FfAqeHELKA7wP5QEzGeTDG+Nekz3eB54FHgP7Ao8mY6eaQJEmSJEmSlMHKJp970ObOyspi0KBBzJw5kxEjRlS233vvvQwbNoy1a9eyZs0aOnbsyLJly6qdW1RUxPTp05k+fTohBJYtW0ZeXl6tcy1cuJAPP/yQww47jPnz5zNr1iw2bNhAq1ataN68OStXruS5554DYOPGjRx66KEMHDiQjh07cumll7Jz507efvttevfuzVe/+lXuuecePvroI4466qjd5rrmmmu46KKL+OpXv0qHDh3YuXMnt99+O6NGjeKMM87gnnvu4bLLLuPuu++mZ8+eu53fsmVLWrVqxR//+Ed69uzJXXfdVbn6ujabN2+mdevWNGrUiDlz5lBRUbHH/vVlr8F1jPFd4N3k760hhNeAE4DzgcKk2xzgKVKh8vnAnTHGCDwXQjgqhHB80ndhjPFDgCT87h9CeApoEWN8Lmm/E7iAVHBd2xySJEmSJEmSVKvx48dz6623Vms76aSTKCgoYMuWLcyYMYNmzZrtdt7EiRMZN24cOTk57Ny5k7Zt21Y+yDGdgoICBg4cyPr167n00kvJz88nOzubGTNm0KlTJzp27EiPHj0A2LBhA8OHD2fnzp0A/OQnP6GiooJLL72UzZs3E2PkqquuShtaQ2pLkZ///OcMGTKEjz/+mBAC5513HgDTp09n+PDh3HzzzRxzzDHccccdaceYM2cOo0aN4uOPP6Zdu3a19tvlyiuvZODAgdx5553079+/zqu3D1RI5ct17BxCG+BpoAuwLsZ4VNIegL/GGI8KITwETI4xPpMce4JU2FwINIsx/jBpnwh8QiqMnhxjPDtp7wlMiDGeF0LYlG6ONHWNBEYCnHTSSae99dZb+3gbJEmSJEmSJB2I1157bY9bajREs2fPpqSkZLeAXLtL9/kIIbwYY8xP17/OD2cMIRwB3AeMizFuqXosWV1d9wR8P+xpjhjj7THG/Bhj/jHHHPNZliFJkiRJkiRJ+ozV6RGVIYRDSIXWd8cY70+a3wshHB9jfDfZCuQvSfsG4MQqp7dO2jbw920/drU/lbS3TtN/T3NIkiRJkiRJ0ufiscceY8KE6jsYt23blgceeIDi4uJ6n++OO+7glltuqdZ25plnctttt9X7XJlqr8F1skXHTOC1GON/VTn0IDAMmJz8XlClfUwI4R5SD2fcnATPjwE/DiG0Svp9DfhejPHDEMKWEEIPUg9nvByYvpc5JEmSJEmSJOlzUVRURFFR0ec23/Dhwxk+fPjnNl8mqsuK6zOBy4CXQwilSdv1pMLk34YQvg28BQxKjj0CfB1YBXwMDAdIAur/BF5I+v1g14MagSuB2cBhpB7K+GjSXtsckiRJkiRJkqQGaq/BdfKQxVDL4b5p+kdgdC1jzQJmpWkvIfXAx5rtH6SbQ5IkSZIkSZLUcNX54YySJEmSJEmSJH0e6vRwRmWgSS2T35sPbh2SJEmSJElSOrvyq3obzxzsy8QV15IkSZIkSZIahBAC48ePr3w9ZcoUJk2aBEBxcTHz5s07SJXVj6eeeopnn312r/3mz5/Pq6+++jlU9NkxuJYkSZIkSZLUIDRt2pT777+fjRs37tf5O3bsqOeK6pfBtSRJkiRJkiR9wTRp0oSRI0cyderUtMcXLVpEfn4+HTp04KGHHgJg9uzZDBgwgD59+tC3b1+2bdvGiBEjKCgoIC8vjwULFtQ63+zZszn//PMpLCykffv23HjjjZXHLrjgAk477TQ6d+7M7bffDkBFRQXFxcV06dKF7OzsyjqnTZvGqaeeSk5ODoMHD047V1lZGTNmzGDq1Knk5ubyxz/+kbKyMvr06UNOTg59+/Zl3bp1PPvsszz44INcc8015Obmsnr16v26lwebe1xLkiRJkiRJajBGjx5NTk4O11577W7HysrKWLJkCatXr6Z3796sWrUKgKVLl/LSSy+RlZXF9ddfT58+fZg1axabNm2ioKCAs88+m8MPPzztfEuWLGHFihU0b96c7t27c+6555Kfn8+sWbPIysrik08+oXv37gwcOJCysjI2bNjAihUrANi0aRMAkydPZu3atTRt2rSyraY2bdowatQojjjiCP793/8dgG984xsMGzaMYcOGMWvWLK666irmz5/PgAEDOO+887j44osP+H4eLK64liRJkiRJktRgtGjRgssvv5xp06btdmzQoEE0atSI9u3b065dO1auXAlAv379yMrKAuDxxx9n8uTJ5ObmUlhYSHl5OevWrat1vn79+nH00Udz2GGHcdFFF/HMM88AqVXUXbt2pUePHrz99tu8+eabtGvXjjVr1jB27Fh+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zaOkpIShQ4eSm5vLJ598wosvvkivXr047bTTKCoq4t133611rlWrVnH22WfTtWtXunXrxurVq4kxcs0119ClSxeys7OZO3cuAE899RQ9e/ZkwIABnHrqqZSXlzN8+HCys7PJy8vjySefrLz2iy66iP79+9O+fXuuvfbayvmuuOIK8vPz6dy5M9///vfr/ibUE/e4liRJkiRJktRgjB49mpycnGoh7C5lZWUsWbKE1atX07t3b1atWgXA0qVLeemll8jKyuL666+nT58+zJo1i02bNlFQUMDZZ5/N4Ycfvtt4xx57LAsXLqRZs2a8+eabDBkyhJKSEh599FEWLFjA888/T/Pmzfnwww/Jysri1ltvZcqUKeTn57N9+3bGjh3LggULOOaYY5g7dy433HADs2bNSntdQ4cO5brrruPCCy+kvLycnTt3cv/991NaWsry5cvZuHEj3bt356yzzqq8phUrVtC2bVt+9rOfEULg5ZdfZuXKlXzta1/jjTfeAKC0tJRly5bRtGlTOnbsyNixYznxxBP50Y9+RFZWFhUVFfTt25eXXnqJnJyc+nqb9srgWpIkSZIkSVKD0aJFCy6//HKmTZvGYYcdVu3YoEGDaNSoEe3bt6ddu3asXLkSgH79+pGVlQXA448/zoMPPsiUKVMAKC8vZ926dXTqtPvDJrdv386YMWMoLS2lcePGlWHwokWLGD58OM2bNweoHLuq119/nRUrVtCvXz8AKioqOP7449Ne09atW9mwYQMXXnghAM2aNQPgmWeeYciQITRu3JjjjjuOXr168cILL9CiRQsKCgpo27ZtZb+xY8cCcMopp/CP//iPlbX27duXli1bAnDqqafy1ltvceKJJ/Lb3/6W22+/nR07dvDuu+/y6quvGlxLkiRJkiRJ0v4aN24c3bp1Y/jw4dXaQwhpX1ddTR1j5L777qNjx457nWfq1Kkcd9xxLF++nJ07d1YGynURY6Rz584sXry4zufsi3QrxNNp2rRp5d+NGzdmx44drF27lilTpvDCCy/QqlUriouLKS8v/0zqrI17XEuSJEmSJEmqd51WvlavP/siKyuLQYMGMXPmzGrt9957Lzt37mT16tWsWbMmbThdVFTE9OnTiTECsGzZslrn2bx5M8cffzyNGjXirrvuoqKiAkit4L7jjjv4+OOPAfjwww8BOPLII9m6dSsA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\n",
            "text/plain": [
              "<Figure size 1800x720 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "KtNs7IfX2GjE"
      },
      "source": [
        "Visualisation avec les  données hospitaliaires  pour voir si les resultats concordent par rapport au classement"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "o3gHHyYevFIl",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 194
        },
        "outputId": "173b01f9-63fd-4905-e18c-6c1db6379314"
      },
      "source": [
        "#Load des données hospitaliaires  pour voir si les resultats concordent par rapport au classement\n",
        "data_hosp_dep = pd.read_csv('/content/data2/donnees-hospitalieres-covid19-2020-05-19-19h00.csv',sep=';')\n",
        "data_hosp_dep.head()"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>sexe</th>\n",
              "      <th>jour</th>\n",
              "      <th>hosp</th>\n",
              "      <th>rea</th>\n",
              "      <th>rad</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>01</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>2</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>01</td>\n",
              "      <td>1</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>01</td>\n",
              "      <td>2</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>02</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>41</td>\n",
              "      <td>10</td>\n",
              "      <td>18</td>\n",
              "      <td>11</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>02</td>\n",
              "      <td>1</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>19</td>\n",
              "      <td>4</td>\n",
              "      <td>11</td>\n",
              "      <td>6</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "  dep  sexe        jour  hosp  rea  rad  dc\n",
              "0  01     0  2020-03-18     2    0    1   0\n",
              "1  01     1  2020-03-18     1    0    1   0\n",
              "2  01     2  2020-03-18     1    0    0   0\n",
              "3  02     0  2020-03-18    41   10   18  11\n",
              "4  02     1  2020-03-18    19    4   11   6"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 16
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "mUWB5VKPegn5",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 399
        },
        "outputId": "cc624ae6-91ba-4cd6-e97c-3d02d06596c4"
      },
      "source": [
        "df_distrub = data_hosp_dep.groupby('dep', as_index=False).sum().sort_values(['hosp'], ascending=False)\n",
        "df_distrub"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>sexe</th>\n",
              "      <th>hosp</th>\n",
              "      <th>rea</th>\n",
              "      <th>rad</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>75</th>\n",
              "      <td>75</td>\n",
              "      <td>186</td>\n",
              "      <td>274764</td>\n",
              "      <td>62989</td>\n",
              "      <td>327531</td>\n",
              "      <td>120586</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>94</th>\n",
              "      <td>94</td>\n",
              "      <td>186</td>\n",
              "      <td>191848</td>\n",
              "      <td>28023</td>\n",
              "      <td>190231</td>\n",
              "      <td>74091</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>92</th>\n",
              "      <td>92</td>\n",
              "      <td>186</td>\n",
              "      <td>189891</td>\n",
              "      <td>34564</td>\n",
              "      <td>224319</td>\n",
              "      <td>69281</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>93</th>\n",
              "      <td>93</td>\n",
              "      <td>186</td>\n",
              "      <td>149189</td>\n",
              "      <td>21234</td>\n",
              "      <td>174099</td>\n",
              "      <td>67380</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>69</th>\n",
              "      <td>69</td>\n",
              "      <td>186</td>\n",
              "      <td>119614</td>\n",
              "      <td>21052</td>\n",
              "      <td>147907</td>\n",
              "      <td>42416</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>15</th>\n",
              "      <td>16</td>\n",
              "      <td>186</td>\n",
              "      <td>1231</td>\n",
              "      <td>374</td>\n",
              "      <td>3555</td>\n",
              "      <td>994</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>8</th>\n",
              "      <td>09</td>\n",
              "      <td>186</td>\n",
              "      <td>1135</td>\n",
              "      <td>284</td>\n",
              "      <td>2141</td>\n",
              "      <td>134</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>29</th>\n",
              "      <td>2B</td>\n",
              "      <td>186</td>\n",
              "      <td>1056</td>\n",
              "      <td>202</td>\n",
              "      <td>8918</td>\n",
              "      <td>626</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>98</th>\n",
              "      <td>973</td>\n",
              "      <td>186</td>\n",
              "      <td>647</td>\n",
              "      <td>46</td>\n",
              "      <td>2638</td>\n",
              "      <td>56</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>48</th>\n",
              "      <td>48</td>\n",
              "      <td>186</td>\n",
              "      <td>492</td>\n",
              "      <td>80</td>\n",
              "      <td>1470</td>\n",
              "      <td>40</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>101 rows × 6 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "    dep  sexe    hosp    rea     rad      dc\n",
              "75   75   186  274764  62989  327531  120586\n",
              "94   94   186  191848  28023  190231   74091\n",
              "92   92   186  189891  34564  224319   69281\n",
              "93   93   186  149189  21234  174099   67380\n",
              "69   69   186  119614  21052  147907   42416\n",
              "..  ...   ...     ...    ...     ...     ...\n",
              "15   16   186    1231    374    3555     994\n",
              "8    09   186    1135    284    2141     134\n",
              "29   2B   186    1056    202    8918     626\n",
              "98  973   186     647     46    2638      56\n",
              "48   48   186     492     80    1470      40\n",
              "\n",
              "[101 rows x 6 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 17
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "YdK4FDJr2Faw",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 584
        },
        "outputId": "79a9551e-952b-4b81-ee0a-387970ed3c35"
      },
      "source": [
        "ax = df_distrub.plot(kind = \"bar\", figsize=(25,10))\n",
        "ax.set_xlabel(\"départements\", fontsize=16)\n",
        "ax.set_title(\"distribution par départements ( Données hospitaliaires)\", fontsize=16)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "Text(0.5, 1.0, 'distribution par départements ( Données hospitaliaires)')"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 18
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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alwDAAAAAAzdvffemwULFmTRokVTPZVVboMNNsjWW2+d9dZbb9L7CK4BAAAAAFazBQsW5FGPelSmT5+eqprq6awyrbXccsstWbBgQbbddttJ76dUCAAAAADAarZo0aJsscUWa3RonSRVlS222GKZV5YLrgEAAAAApsCaHlqPWZ7zFFwDAAAAADAoalwDAAAAAEyx6W/54kodb/67X7RSx1vdrLgGAAAAAGBQBNcAAAAAAGuhX/ziF3nRi16UXXbZJTvttFPOOOOMXHLJJdlnn33y1Kc+Nfvuu29++tOfZuHChdl+++1z7bXXJkle8YpX5OSTT06SvOc978mee+6ZnXfeOccdd9xKm5tSIQAAAAAAa6Evf/nLedzjHpcvfrErU7Jw4cK88IUvzJlnnpktt9wyZ5xxRo499tjMmTMn73//+3PYYYfl6KOPzm233ZYjjjgiZ599dq677rpceOGFaa1l//33z3nnnZe99957hecmuAYAAAAAWAs95SlPyRvf+Ma8+c1vzotf/OJsttlmufLKK/P85z8/SXL//fdnq622SpI8//nPz6c+9akcddRRueyyy5IkZ599ds4+++zstttuSZK77ror1113neAaAAAAAIDl8+QnPznf+973ctZZZ+Vv//Zv85znPCc77rhjvvvd7z6s7wMPPJC5c+dm2rRpue2227L11luntZZjjjkmRx555EqfmxrXAAAAAABroZ/85CeZNm1aXvWqV+VNb3pTLrjggtx8880PBtf33ntvrrrqqiTJiSeemJkzZ+Y//uM/8prXvCb33ntv9t1338yZMyd33XVXkuTGG2/MTTfdtFLmZsU1AAAAAMAUm//uF632Y15xxRV505velEc84hFZb7318sEPfjDrrrtuXv/612fhwoW577778oY3vCHrrrtuPvzhD+fCCy/Mox71qOy9995517velbe//e2ZO3du9tprryTJxhtvnNNOOy2PecxjVnhu1Vpb4UGGZI899mgXX3zxVE8DAAAAAGCx5s6dm5kzZ071NFabic63qi5pre0xUX+lQgAAAAAAGBTBNQAAAAAAgyK4BgAAAABgUATXAAAAAAAMiuAaAAAAAIBBEVwDAAAAADAo6071BAAAAAAA1nqzN1nJ4y1capf58+fnxS9+ca688sqVe+yVYK1bcT13xsypngIAAAAAAEuw1gXXAAAAAAB07r///hxxxBHZcccd84IXvCB33313Lr300syaNSs777xzDjrooNx2221Jkve9733ZYYcdsvPOO+fggw9OksyePTuvfvWrs9dee2W77bbLySefvFLmJbgGAAAAAFhLXXfddTnqqKNy1VVXZdNNN81nPvOZHHLIITnhhBNy+eWX5ylPeUre/va3J0ne/e535/vf/34uv/zyfOhDH3pwjMsvvzznnHNOvvvd7+Yd73hHfvKTn6zwvATXAAAAAABrqW233Ta77rprkuSpT31qrr/++tx+++3ZZ599kiSHHnpozjvvvCTJzjvvnFe+8pU57bTTsu66v/75xAMOOCAbbrhhHv3oR+fZz352LrzwwhWel+AaAAAAAGAttf766z94fZ111sntt9++2L5f/OIXc9RRR+V73/te9txzz9x3331Jkqp6SL/xt5eH4BoAAAAAgCTJJptsks022yzf+ta3kiQf+9jHss8+++SBBx7IDTfckGc/+9k54YQTsnDhwtx1111JkjPPPDOLFi3KLbfcknPPPTd77rnnCs9j3aV3AQAAAABglZq9cKpn8KBTTz01r3vd6/LLX/4yT3ziE/Pv//7vuf/++/OqV70qCxcuTGstr3/967Ppppsm6UqIPPvZz87Pf/7z/N3f/V0e97jHrfAcBNcAAAAAAGuh6dOn58orr3zw9l//9V8/eP38889/WP9vf/vbE46z884756Mf/ehKnZtSIQAAAAAADIoV1wAAAAAALJfZs2evknGtuAYAAAAAYFAE1wAAAAAADIrgGgAAAACAQRFcAwAAAAAwKH6cEQAAAABgij3l1Kes1PGuOPSKlTre6mbFNQAAAADAWq61lgceeGCqp/EgwTUAAAAAwFpo/vz52X777XPIIYdkp512yjvf+c7sueee2XnnnXPcccc92O/AAw/MU5/61Oy444456aSTVsvclAoBAAAAAFhLXXfddTn11FNzxx135NOf/nQuvPDCtNay//7757zzzsvee++dOXPmZPPNN8/dd9+dPffcMy95yUuyxRZbrNJ5WXENAAAAALCWesITnpBZs2bl7LPPztlnn53ddtstu+++e6655ppcd911SZL3ve992WWXXTJr1qzccMMND7avSlZcAwAAAACspTbaaKMkXY3rY445JkceeeRDtp977rn52te+lu9+97uZNm1anvWsZ2XRokWrfF5WXAMAAAAArOX23XffzJkzJ3fddVeS5MYbb8xNN92UhQsXZrPNNsu0adNyzTXX5Pzzz18t87HiGgAAAABgil1x6BVTevwXvOAFmTt3bvbaa68kycYbb5zTTjst++23Xz70oQ9l5syZ2X777TNr1qzVMh/BNQAAAADAWmj69Om58sorH7x99NFH5+ijj35Yvy996Uurc1pJlAoBAAAAAGBgBNcAAAAAAAyK4BoAAAAAgEERXAMAAAAAMCiCawAAAAAABkVwDQAAAADAoKw71RMAAAAAAFjbzZ0xc6WON/OauSt1vDHnnntu3vve9+YLX/jCKhl/jBXXAAAAAABrudZaHnjggamexoME1wAAAAAAa6H58+dn++23zyGHHJKddtophx9+ePbYY4/suOOOOe644x7s9+UvfzkzZszI7rvvns9+9rOrZW5KhQAAAAAArKWuu+66nHrqqZk1a1ZuvfXWbL755rn//vvz3Oc+N5dffnme/OQn54gjjsg555yTJz3pSXn5y1++WuZlxTUAAAAAwFrqCU94QmbNmpUk+eQnP5ndd989u+22W6666qpcffXVueaaa7Lttttmu+22S1XlVa961WqZlxXXAAAAAABrqY022ihJ8sMf/jDvfe97c9FFF2WzzTbLYYcdlkWLFk3ZvKy4BgAAAABYy91xxx3ZaKONsskmm+RnP/tZvvSlLyVJZsyYkfnz5+f6669PknziE59YLfOx4hoAAAAAYIrNvGbulB5/l112yW677ZYZM2Zkm222yTOe8YwkyQYbbJCTTjopL3rRizJt2rQ885nPzJ133rnK5yO4BgAAAABYC02fPj1XXnnlg7dPOeWUCfvtt99+ueaaa1bTrDpKhQAAAAAAMCiCawAAAAAABkVwDQAAAADAoCw1uK6qDarqwqq6rKquqqq39+3bVtUFVTWvqs6oqkf27ev3t+f126ePjHVM335tVe070r5f3zavqt4y0j7hMQAAAAAAWHNNZsX1PUme01rbJcmuSfarqllJTkhyYmvtSUluS3J43//wJLf17Sf2/VJVOyQ5OMmOSfZL8q9VtU5VrZPkA0lemGSHJK/o+2YJxwAAAAAAYA211OC6de7qb67XX1qS5yT5dN9+apID++sH9LfTb39uVVXffnpr7Z7W2g+TzEvytP4yr7X2g9bar5KcnuSAfp/FHQMA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\n",
            "text/plain": [
              "<Figure size 1800x720 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "Edowshvo3qaE"
      },
      "source": [
        "# **2) Visualiser par région le nombre de personnes atteints du Covid **"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "zZdr3jzp34Gx",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 419
        },
        "outputId": "012d986d-2641-4612-d378-7d069cbc0c86"
      },
      "source": [
        "data_region = pd.read_csv('/content/data/sursaud-covid19-quotidien-2020-05-26-19h00-region.csv',sep=',')\n",
        "data_region.head(100)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>reg</th>\n",
              "      <th>date_de_passage</th>\n",
              "      <th>sursaud_cl_age_corona</th>\n",
              "      <th>nbre_pass_corona</th>\n",
              "      <th>nbre_pass_tot</th>\n",
              "      <th>nbre_hospit_corona</th>\n",
              "      <th>nbre_pass_corona_h</th>\n",
              "      <th>nbre_pass_corona_f</th>\n",
              "      <th>nbre_pass_tot_h</th>\n",
              "      <th>nbre_pass_tot_f</th>\n",
              "      <th>nbre_hospit_corona_h</th>\n",
              "      <th>nbre_hospit_corona_f</th>\n",
              "      <th>nbre_acte_corona</th>\n",
              "      <th>nbre_acte_tot</th>\n",
              "      <th>nbre_acte_corona_h</th>\n",
              "      <th>nbre_acte_corona_f</th>\n",
              "      <th>nbre_acte_tot_h</th>\n",
              "      <th>nbre_acte_tot_f</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>1</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>300.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>148.0</td>\n",
              "      <td>152.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>1</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>A</td>\n",
              "      <td>NaN</td>\n",
              "      <td>75.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>1</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>B</td>\n",
              "      <td>NaN</td>\n",
              "      <td>102.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>1</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>C</td>\n",
              "      <td>NaN</td>\n",
              "      <td>68.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>1</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>D</td>\n",
              "      <td>NaN</td>\n",
              "      <td>20.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>95</th>\n",
              "      <td>75</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>E</td>\n",
              "      <td>NaN</td>\n",
              "      <td>817.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>143.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>96</th>\n",
              "      <td>76</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>0</td>\n",
              "      <td>1.0</td>\n",
              "      <td>4666.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>1.0</td>\n",
              "      <td>2408.0</td>\n",
              "      <td>2258.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>475.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>194.0</td>\n",
              "      <td>278.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>97</th>\n",
              "      <td>76</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>A</td>\n",
              "      <td>NaN</td>\n",
              "      <td>936.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>134.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>98</th>\n",
              "      <td>76</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>B</td>\n",
              "      <td>1.0</td>\n",
              "      <td>1668.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>208.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>99</th>\n",
              "      <td>76</td>\n",
              "      <td>2020-02-24</td>\n",
              "      <td>C</td>\n",
              "      <td>NaN</td>\n",
              "      <td>916.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>77.0</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>100 rows × 18 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "    reg date_de_passage  ... nbre_acte_tot_h  nbre_acte_tot_f\n",
              "0     1      2020-02-24  ...             NaN              NaN\n",
              "1     1      2020-02-24  ...             NaN              NaN\n",
              "2     1      2020-02-24  ...             NaN              NaN\n",
              "3     1      2020-02-24  ...             NaN              NaN\n",
              "4     1      2020-02-24  ...             NaN              NaN\n",
              "..  ...             ...  ...             ...              ...\n",
              "95   75      2020-02-24  ...             NaN              NaN\n",
              "96   76      2020-02-24  ...           194.0            278.0\n",
              "97   76      2020-02-24  ...             NaN              NaN\n",
              "98   76      2020-02-24  ...             NaN              NaN\n",
              "99   76      2020-02-24  ...             NaN              NaN\n",
              "\n",
              "[100 rows x 18 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 19
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "kuYtlh7m49tK",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 355
        },
        "outputId": "bcfa1063-6b62-4906-d227-1f3d12fbb160"
      },
      "source": [
        "# count missing values\n",
        "data_region.isnull().sum()"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "reg                          0\n",
              "date_de_passage              0\n",
              "sursaud_cl_age_corona        0\n",
              "nbre_pass_corona          3831\n",
              "nbre_pass_tot              815\n",
              "nbre_hospit_corona        4852\n",
              "nbre_pass_corona_h        9691\n",
              "nbre_pass_corona_f        9708\n",
              "nbre_pass_tot_h           9304\n",
              "nbre_pass_tot_f           9304\n",
              "nbre_hospit_corona_h      9819\n",
              "nbre_hospit_corona_f      9826\n",
              "nbre_acte_corona          5592\n",
              "nbre_acte_tot             3330\n",
              "nbre_acte_corona_h       10006\n",
              "nbre_acte_corona_f        9992\n",
              "nbre_acte_tot_h           9753\n",
              "nbre_acte_tot_f           9753\n",
              "dtype: int64"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 20
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "JAt9SszK5Hti",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 355
        },
        "outputId": "0089a2da-c655-4773-b348-a8b4697b5a52"
      },
      "source": [
        "# remove rows with missing values\n",
        "data_region.drop(data_region.loc[data_region.reg.isnull()].index, inplace=True)\n",
        "data_region.isnull().sum()"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "reg                          0\n",
              "date_de_passage              0\n",
              "sursaud_cl_age_corona        0\n",
              "nbre_pass_corona          3831\n",
              "nbre_pass_tot              815\n",
              "nbre_hospit_corona        4852\n",
              "nbre_pass_corona_h        9691\n",
              "nbre_pass_corona_f        9708\n",
              "nbre_pass_tot_h           9304\n",
              "nbre_pass_tot_f           9304\n",
              "nbre_hospit_corona_h      9819\n",
              "nbre_hospit_corona_f      9826\n",
              "nbre_acte_corona          5592\n",
              "nbre_acte_tot             3330\n",
              "nbre_acte_corona_h       10006\n",
              "nbre_acte_corona_f        9992\n",
              "nbre_acte_tot_h           9753\n",
              "nbre_acte_tot_f           9753\n",
              "dtype: int64"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 21
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "WVbSGPzI-nqv",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 683
        },
        "outputId": "d38dc36a-2f58-45c9-bb3b-b299421040cb"
      },
      "source": [
        "df_distrub_region = data_region.groupby('reg', as_index=True).sum().sort_values(['nbre_hospit_corona'], ascending=False)\n",
        "df_distrub_region"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>nbre_pass_corona</th>\n",
              "      <th>nbre_pass_tot</th>\n",
              "      <th>nbre_hospit_corona</th>\n",
              "      <th>nbre_pass_corona_h</th>\n",
              "      <th>nbre_pass_corona_f</th>\n",
              "      <th>nbre_pass_tot_h</th>\n",
              "      <th>nbre_pass_tot_f</th>\n",
              "      <th>nbre_hospit_corona_h</th>\n",
              "      <th>nbre_hospit_corona_f</th>\n",
              "      <th>nbre_acte_corona</th>\n",
              "      <th>nbre_acte_tot</th>\n",
              "      <th>nbre_acte_corona_h</th>\n",
              "      <th>nbre_acte_corona_f</th>\n",
              "      <th>nbre_acte_tot_h</th>\n",
              "      <th>nbre_acte_tot_f</th>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>reg</th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>11</th>\n",
              "      <td>102991.0</td>\n",
              "      <td>956984.0</td>\n",
              "      <td>31387.0</td>\n",
              "      <td>25158.0</td>\n",
              "      <td>26317.0</td>\n",
              "      <td>250676.0</td>\n",
              "      <td>227707.0</td>\n",
              "      <td>9130.0</td>\n",
              "      <td>6562.0</td>\n",
              "      <td>23765.0</td>\n",
              "      <td>250898.0</td>\n",
              "      <td>5215.0</td>\n",
              "      <td>6693.0</td>\n",
              "      <td>53655.0</td>\n",
              "      <td>72038.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>44</th>\n",
              "      <td>33177.0</td>\n",
              "      <td>437339.0</td>\n",
              "      <td>16295.0</td>\n",
              "      <td>7583.0</td>\n",
              "      <td>9005.0</td>\n",
              "      <td>112319.0</td>\n",
              "      <td>106303.0</td>\n",
              "      <td>4573.0</td>\n",
              "      <td>3575.0</td>\n",
              "      <td>11990.0</td>\n",
              "      <td>120361.0</td>\n",
              "      <td>2516.0</td>\n",
              "      <td>3464.0</td>\n",
              "      <td>26086.0</td>\n",
              "      <td>34132.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>84</th>\n",
              "      <td>31844.0</td>\n",
              "      <td>642768.0</td>\n",
              "      <td>13608.0</td>\n",
              "      <td>7174.0</td>\n",
              "      <td>8748.0</td>\n",
              "      <td>165929.0</td>\n",
              "      <td>155453.0</td>\n",
              "      <td>3567.0</td>\n",
              "      <td>3237.0</td>\n",
              "      <td>12779.0</td>\n",
              "      <td>156863.0</td>\n",
              "      <td>2660.0</td>\n",
              "      <td>3711.0</td>\n",
              "      <td>33390.0</td>\n",
              "      <td>44760.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>93</th>\n",
              "      <td>20910.0</td>\n",
              "      <td>506586.0</td>\n",
              "      <td>10778.0</td>\n",
              "      <td>4796.0</td>\n",
              "      <td>5658.0</td>\n",
              "      <td>130488.0</td>\n",
              "      <td>122776.0</td>\n",
              "      <td>2824.0</td>\n",
              "      <td>2565.0</td>\n",
              "      <td>11169.0</td>\n",
              "      <td>140591.0</td>\n",
              "      <td>2204.0</td>\n",
              "      <td>3384.0</td>\n",
              "      <td>28518.0</td>\n",
              "      <td>41860.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>27</th>\n",
              "      <td>21364.0</td>\n",
              "      <td>262149.0</td>\n",
              "      <td>8894.0</td>\n",
              "      <td>4366.0</td>\n",
              "      <td>6316.0</td>\n",
              "      <td>67459.0</td>\n",
              "      <td>63598.0</td>\n",
              "      <td>2253.0</td>\n",
              "      <td>2194.0</td>\n",
              "      <td>3695.0</td>\n",
              "      <td>44047.0</td>\n",
              "      <td>787.0</td>\n",
              "      <td>1061.0</td>\n",
              "      <td>9639.0</td>\n",
              "      <td>12398.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>32</th>\n",
              "      <td>23562.0</td>\n",
              "      <td>441378.0</td>\n",
              "      <td>8470.0</td>\n",
              "      <td>5320.0</td>\n",
              "      <td>6461.0</td>\n",
              "      <td>113112.0</td>\n",
              "      <td>107562.0</td>\n",
              "      <td>2176.0</td>\n",
              "      <td>2059.0</td>\n",
              "      <td>7699.0</td>\n",
              "      <td>139942.0</td>\n",
              "      <td>1661.0</td>\n",
              "      <td>2190.0</td>\n",
              "      <td>31294.0</td>\n",
              "      <td>38837.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>75</th>\n",
              "      <td>19596.0</td>\n",
              "      <td>495744.0</td>\n",
              "      <td>8422.0</td>\n",
              "      <td>4375.0</td>\n",
              "      <td>5422.0</td>\n",
              "      <td>128775.0</td>\n",
              "      <td>119085.0</td>\n",
              "      <td>2171.0</td>\n",
              "      <td>2039.0</td>\n",
              "      <td>13283.0</td>\n",
              "      <td>201506.0</td>\n",
              "      <td>2784.0</td>\n",
              "      <td>3858.0</td>\n",
              "      <td>42530.0</td>\n",
              "      <td>58243.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>52</th>\n",
              "      <td>14937.0</td>\n",
              "      <td>240116.0</td>\n",
              "      <td>7302.0</td>\n",
              "      <td>3344.0</td>\n",
              "      <td>4122.0</td>\n",
              "      <td>63241.0</td>\n",
              "      <td>56798.0</td>\n",
              "      <td>1873.0</td>\n",
              "      <td>1775.0</td>\n",
              "      <td>5688.0</td>\n",
              "      <td>81521.0</td>\n",
              "      <td>1222.0</td>\n",
              "      <td>1620.0</td>\n",
              "      <td>17667.0</td>\n",
              "      <td>23012.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>76</th>\n",
              "      <td>16216.0</td>\n",
              "      <td>509001.0</td>\n",
              "      <td>7296.0</td>\n",
              "      <td>3605.0</td>\n",
              "      <td>4502.0</td>\n",
              "      <td>130231.0</td>\n",
              "      <td>124266.0</td>\n",
              "      <td>1830.0</td>\n",
              "      <td>1817.0</td>\n",
              "      <td>5198.0</td>\n",
              "      <td>71896.0</td>\n",
              "      <td>1082.0</td>\n",
              "      <td>1511.0</td>\n",
              "      <td>14664.0</td>\n",
              "      <td>21217.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>94</th>\n",
              "      <td>4180.0</td>\n",
              "      <td>29994.0</td>\n",
              "      <td>3996.0</td>\n",
              "      <td>901.0</td>\n",
              "      <td>1189.0</td>\n",
              "      <td>7766.0</td>\n",
              "      <td>7230.0</td>\n",
              "      <td>859.0</td>\n",
              "      <td>1139.0</td>\n",
              "      <td>953.0</td>\n",
              "      <td>7673.0</td>\n",
              "      <td>179.0</td>\n",
              "      <td>289.0</td>\n",
              "      <td>1366.0</td>\n",
              "      <td>2229.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>53</th>\n",
              "      <td>9596.0</td>\n",
              "      <td>260211.0</td>\n",
              "      <td>3842.0</td>\n",
              "      <td>2083.0</td>\n",
              "      <td>2715.0</td>\n",
              "      <td>66888.0</td>\n",
              "      <td>63217.0</td>\n",
              "      <td>959.0</td>\n",
              "      <td>962.0</td>\n",
              "      <td>2386.0</td>\n",
              "      <td>62321.0</td>\n",
              "      <td>528.0</td>\n",
              "      <td>665.0</td>\n",
              "      <td>13273.0</td>\n",
              "      <td>17891.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>28</th>\n",
              "      <td>8655.0</td>\n",
              "      <td>282953.0</td>\n",
              "      <td>3454.0</td>\n",
              "      <td>1872.0</td>\n",
              "      <td>2456.0</td>\n",
              "      <td>72734.0</td>\n",
              "      <td>68695.0</td>\n",
              "      <td>875.0</td>\n",
              "      <td>852.0</td>\n",
              "      <td>5312.0</td>\n",
              "      <td>74848.0</td>\n",
              "      <td>1114.0</td>\n",
              "      <td>1542.0</td>\n",
              "      <td>15873.0</td>\n",
              "      <td>21551.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>24</th>\n",
              "      <td>9704.0</td>\n",
              "      <td>209129.0</td>\n",
              "      <td>2502.0</td>\n",
              "      <td>2076.0</td>\n",
              "      <td>2776.0</td>\n",
              "      <td>53189.0</td>\n",
              "      <td>51356.0</td>\n",
              "      <td>676.0</td>\n",
              "      <td>575.0</td>\n",
              "      <td>2219.0</td>\n",
              "      <td>52688.0</td>\n",
              "      <td>456.0</td>\n",
              "      <td>657.0</td>\n",
              "      <td>11517.0</td>\n",
              "      <td>14866.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>6</th>\n",
              "      <td>2398.0</td>\n",
              "      <td>19280.0</td>\n",
              "      <td>376.0</td>\n",
              "      <td>561.0</td>\n",
              "      <td>638.0</td>\n",
              "      <td>5255.0</td>\n",
              "      <td>4385.0</td>\n",
              "      <td>87.0</td>\n",
              "      <td>101.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>536.0</td>\n",
              "      <td>66562.0</td>\n",
              "      <td>370.0</td>\n",
              "      <td>145.0</td>\n",
              "      <td>123.0</td>\n",
              "      <td>18003.0</td>\n",
              "      <td>15277.0</td>\n",
              "      <td>100.0</td>\n",
              "      <td>85.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>578.0</td>\n",
              "      <td>31442.0</td>\n",
              "      <td>202.0</td>\n",
              "      <td>132.0</td>\n",
              "      <td>157.0</td>\n",
              "      <td>7286.0</td>\n",
              "      <td>8432.0</td>\n",
              "      <td>44.0</td>\n",
              "      <td>57.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>254.0</td>\n",
              "      <td>33467.0</td>\n",
              "      <td>90.0</td>\n",
              "      <td>62.0</td>\n",
              "      <td>65.0</td>\n",
              "      <td>8544.0</td>\n",
              "      <td>8190.0</td>\n",
              "      <td>23.0</td>\n",
              "      <td>22.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>8</th>\n",
              "      <td>54.0</td>\n",
              "      <td>3186.0</td>\n",
              "      <td>30.0</td>\n",
              "      <td>15.0</td>\n",
              "      <td>12.0</td>\n",
              "      <td>812.0</td>\n",
              "      <td>781.0</td>\n",
              "      <td>8.0</td>\n",
              "      <td>7.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>7</th>\n",
              "      <td>78.0</td>\n",
              "      <td>2920.0</td>\n",
              "      <td>8.0</td>\n",
              "      <td>22.0</td>\n",
              "      <td>17.0</td>\n",
              "      <td>907.0</td>\n",
              "      <td>553.0</td>\n",
              "      <td>1.0</td>\n",
              "      <td>3.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>284.0</td>\n",
              "      <td>18736.0</td>\n",
              "      <td>63.0</td>\n",
              "      <td>79.0</td>\n",
              "      <td>3635.0</td>\n",
              "      <td>5733.0</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "     nbre_pass_corona  nbre_pass_tot  ...  nbre_acte_tot_h  nbre_acte_tot_f\n",
              "reg                                   ...                                  \n",
              "11           102991.0       956984.0  ...          53655.0          72038.0\n",
              "44            33177.0       437339.0  ...          26086.0          34132.0\n",
              "84            31844.0       642768.0  ...          33390.0          44760.0\n",
              "93            20910.0       506586.0  ...          28518.0          41860.0\n",
              "27            21364.0       262149.0  ...           9639.0          12398.0\n",
              "32            23562.0       441378.0  ...          31294.0          38837.0\n",
              "75            19596.0       495744.0  ...          42530.0          58243.0\n",
              "52            14937.0       240116.0  ...          17667.0          23012.0\n",
              "76            16216.0       509001.0  ...          14664.0          21217.0\n",
              "94             4180.0        29994.0  ...           1366.0           2229.0\n",
              "53             9596.0       260211.0  ...          13273.0          17891.0\n",
              "28             8655.0       282953.0  ...          15873.0          21551.0\n",
              "24             9704.0       209129.0  ...          11517.0          14866.0\n",
              "6              2398.0        19280.0  ...              0.0              0.0\n",
              "4               536.0        66562.0  ...              0.0              0.0\n",
              "1               578.0        31442.0  ...              0.0              0.0\n",
              "3               254.0        33467.0  ...              0.0              0.0\n",
              "8                54.0         3186.0  ...              0.0              0.0\n",
              "7                78.0         2920.0  ...              0.0              0.0\n",
              "2                 0.0            0.0  ...           3635.0           5733.0\n",
              "\n",
              "[20 rows x 15 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 22
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "vb2YYj7_K_Ob",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 399
        },
        "outputId": "037f2c85-9190-41ba-d2f0-a4f7d63aba79"
      },
      "source": [
        "#Filtrer uniquement par region et nombre d'hospitalisation suite au covid19\n",
        "region1=data_region[['reg', 'nbre_hospit_corona']]\n",
        "region1\n",
        "\n"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>reg</th>\n",
              "      <th>nbre_hospit_corona</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>1</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>1</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>1</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>1</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>1</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>11035</th>\n",
              "      <td>94</td>\n",
              "      <td>NaN</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>11036</th>\n",
              "      <td>94</td>\n",
              "      <td>1.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>11037</th>\n",
              "      <td>94</td>\n",
              "      <td>1.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>11038</th>\n",
              "      <td>94</td>\n",
              "      <td>1.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>11039</th>\n",
              "      <td>94</td>\n",
              "      <td>2.0</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>11040 rows × 2 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "       reg  nbre_hospit_corona\n",
              "0        1                 NaN\n",
              "1        1                 NaN\n",
              "2        1                 NaN\n",
              "3        1                 NaN\n",
              "4        1                 NaN\n",
              "...    ...                 ...\n",
              "11035   94                 NaN\n",
              "11036   94                 1.0\n",
              "11037   94                 1.0\n",
              "11038   94                 1.0\n",
              "11039   94                 2.0\n",
              "\n",
              "[11040 rows x 2 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 23
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "y3RbAatyLX8u",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 663
        },
        "outputId": "0ec894c3-07fd-4934-e3c8-74b3225353fe"
      },
      "source": [
        "df_distrub_region1 = region1.groupby('reg', as_index=True).sum().sort_values(['nbre_hospit_corona'], ascending=False)\n",
        "df_distrub_region1"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>nbre_hospit_corona</th>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>reg</th>\n",
              "      <th></th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>11</th>\n",
              "      <td>31387.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>44</th>\n",
              "      <td>16295.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>84</th>\n",
              "      <td>13608.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>93</th>\n",
              "      <td>10778.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>27</th>\n",
              "      <td>8894.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>32</th>\n",
              "      <td>8470.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>75</th>\n",
              "      <td>8422.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>52</th>\n",
              "      <td>7302.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>76</th>\n",
              "      <td>7296.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>94</th>\n",
              "      <td>3996.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>53</th>\n",
              "      <td>3842.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>28</th>\n",
              "      <td>3454.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>24</th>\n",
              "      <td>2502.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>6</th>\n",
              "      <td>376.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>370.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>202.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>90.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>8</th>\n",
              "      <td>30.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>7</th>\n",
              "      <td>8.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "     nbre_hospit_corona\n",
              "reg                    \n",
              "11              31387.0\n",
              "44              16295.0\n",
              "84              13608.0\n",
              "93              10778.0\n",
              "27               8894.0\n",
              "32               8470.0\n",
              "75               8422.0\n",
              "52               7302.0\n",
              "76               7296.0\n",
              "94               3996.0\n",
              "53               3842.0\n",
              "28               3454.0\n",
              "24               2502.0\n",
              "6                 376.0\n",
              "4                 370.0\n",
              "1                 202.0\n",
              "3                  90.0\n",
              "8                  30.0\n",
              "7                   8.0\n",
              "2                   0.0"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 24
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "-J-VCvn0GMUf",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 433
        },
        "outputId": "ce10209d-ce8a-4681-e488-eb14908852a9"
      },
      "source": [
        "ax = df_distrub_region1.plot(kind = \"bar\", figsize=(15,6))\n",
        "ax.set_xlabel(\"Regions\", fontsize=16)\n",
        "ax.set_title(\"distribution par Région ( Données Urgences et SOS médecins)\", fontsize=16)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "Text(0.5, 1.0, 'distribution par Région ( Données Urgences et SOS médecins)')"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 25
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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OP7443nb297GL37xCwAee+wxrr76av70pz/xrne9i+uuuw4oidr06dMZN24c73jHO/joRz/K6173Ou644w522mknbrzxxl7nddNNN3HRRRfx8MMPs8EGG/CBD3yAa665hhNPPJHLL7+czGTrrbfmDW94A7fddhsvfvGLOe+80oT1wQcfnD+dlVZaiWuvvZZTTjmFj3zkI/z617+eP2zPPffke9/7Xp/NTZ966ine/va3c8YZZ7Dlllvy0EMPMW7cOI466igigmuvvZabbrqJHXfckVtuuQWAq666imuuuYZVV12VQw45hM0335yzzz6bP/zhD+y7775cffXVvS7j0ksvzQknnMCqq67K448/zpZbbslb3/pWVltttcXYcl7JkyRJktTBeuutx8SJEwF4zWtew6xZswDYe++9AXj961/PQw89xD//+U8Adt11V8aNGwfAhRdeyMEHH8zEiRPZddddeeihh3jkkUd6ndcuu+zCsssuy+qrr84aa6zBvffey/Tp09ljjz1YfvnlWWGFFXjLW97CJZdcwiabbMIFF1zApz71KS655BJWWmml+dPpiW3vvffm0ksvHfQy33zzzay11lpsueWWAKy44oqMGTOG6dOn8853vhOAV73qVbz0pS+dn+S96U1vYtVVVwVg+vTp7LPPPgBsv/32zJ07l4ceeqjXZQQ4+uij2WyzzZg8eTJ33nknt95666Djbtf4K3lDfZMqLPqNqpIkSdJoseyyy85/vdRSS81v3tjenX/P++WXX35+2bPPPstll13G2LFjF2le8+bN67XuK1/5Sq666iqmTZvG5z73OXbYYQe+8IUvLBTbkvoLitbl7kunZbz44ou58MILufTSS1luueWYMmXKoP4PrzdeyZMkSZI0YD33wE2fPp2VVlppgStpPXbccUe++93vzn/f02RxMLbbbjvOPvtsHnvsMR599FHOOusstttuO/7+97+z3HLL8c53vpNPfvKTXHXVVQvFdsYZZ7DNNtssNM0XvvCFPPzww73Oc4MNNuDuu+/myiuvBODhhx9m3rx5bLfddpx66qkA3HLLLdxxxx1ssMEGHWPuqXfxxRez+uqrs+KKK/Y6vwcffJBVVlmF5ZZbjptuuonLLrtsAGumf42/kidJkiSNdiOpJdnYsWPZfPPNefrppznhhBM61jn66KM56KCD2HTTTZk3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\n",
            "text/plain": [
              "<Figure size 1080x432 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "NCqm_oMCPG5d"
      },
      "source": [
        "# ** 3)Top 10 des départements ayant le plus de décès en France**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "LdIKsFVlPLUC",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 399
        },
        "outputId": "770a8b38-43ef-4919-dfbe-eb92f2ada17b"
      },
      "source": [
        "#Afin d'avoir le nombre de décès on utilise le fichier des données hospitaliaires contenant les info covid19 par departements :\n",
        "data_dep_dc = pd.read_csv('/content/data2/donnees-hospitalieres-covid19-2020-05-19-19h00.csv',sep=';')\n",
        "data_dep_dc.head(100)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>sexe</th>\n",
              "      <th>jour</th>\n",
              "      <th>hosp</th>\n",
              "      <th>rea</th>\n",
              "      <th>rad</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>01</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>2</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>01</td>\n",
              "      <td>1</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>01</td>\n",
              "      <td>2</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>02</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>41</td>\n",
              "      <td>10</td>\n",
              "      <td>18</td>\n",
              "      <td>11</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>02</td>\n",
              "      <td>1</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>19</td>\n",
              "      <td>4</td>\n",
              "      <td>11</td>\n",
              "      <td>6</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>95</th>\n",
              "      <td>31</td>\n",
              "      <td>2</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>8</td>\n",
              "      <td>1</td>\n",
              "      <td>7</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>96</th>\n",
              "      <td>32</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>97</th>\n",
              "      <td>32</td>\n",
              "      <td>1</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>98</th>\n",
              "      <td>32</td>\n",
              "      <td>2</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>99</th>\n",
              "      <td>33</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>7</td>\n",
              "      <td>4</td>\n",
              "      <td>3</td>\n",
              "      <td>1</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>100 rows × 7 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "   dep  sexe        jour  hosp  rea  rad  dc\n",
              "0   01     0  2020-03-18     2    0    1   0\n",
              "1   01     1  2020-03-18     1    0    1   0\n",
              "2   01     2  2020-03-18     1    0    0   0\n",
              "3   02     0  2020-03-18    41   10   18  11\n",
              "4   02     1  2020-03-18    19    4   11   6\n",
              "..  ..   ...         ...   ...  ...  ...  ..\n",
              "95  31     2  2020-03-18     8    1    7   0\n",
              "96  32     0  2020-03-18     1    1    0   0\n",
              "97  32     1  2020-03-18     1    1    0   0\n",
              "98  32     2  2020-03-18     0    0    0   0\n",
              "99  33     0  2020-03-18     7    4    3   1\n",
              "\n",
              "[100 rows x 7 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 26
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "Ue5V34FdUq87",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 428
        },
        "outputId": "558c2bd0-6f7b-4425-f820-7c391fcafd50"
      },
      "source": [
        "df_distrub_dc_dep = data_dep_dc.groupby('dep', as_index=True).sum().sort_values(['dc'], ascending=False)\n",
        "df_distrub_dc_dep"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>sexe</th>\n",
              "      <th>hosp</th>\n",
              "      <th>rea</th>\n",
              "      <th>rad</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>dep</th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>75</th>\n",
              "      <td>186</td>\n",
              "      <td>274764</td>\n",
              "      <td>62989</td>\n",
              "      <td>327531</td>\n",
              "      <td>120586</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>94</th>\n",
              "      <td>186</td>\n",
              "      <td>191848</td>\n",
              "      <td>28023</td>\n",
              "      <td>190231</td>\n",
              "      <td>74091</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>92</th>\n",
              "      <td>186</td>\n",
              "      <td>189891</td>\n",
              "      <td>34564</td>\n",
              "      <td>224319</td>\n",
              "      <td>69281</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>68</th>\n",
              "      <td>186</td>\n",
              "      <td>107602</td>\n",
              "      <td>13569</td>\n",
              "      <td>163294</td>\n",
              "      <td>67506</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>93</th>\n",
              "      <td>186</td>\n",
              "      <td>149189</td>\n",
              "      <td>21234</td>\n",
              "      <td>174099</td>\n",
              "      <td>67380</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>82</th>\n",
              "      <td>186</td>\n",
              "      <td>1328</td>\n",
              "      <td>720</td>\n",
              "      <td>2399</td>\n",
              "      <td>358</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>09</th>\n",
              "      <td>186</td>\n",
              "      <td>1135</td>\n",
              "      <td>284</td>\n",
              "      <td>2141</td>\n",
              "      <td>134</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>973</th>\n",
              "      <td>186</td>\n",
              "      <td>647</td>\n",
              "      <td>46</td>\n",
              "      <td>2638</td>\n",
              "      <td>56</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>48</th>\n",
              "      <td>186</td>\n",
              "      <td>492</td>\n",
              "      <td>80</td>\n",
              "      <td>1470</td>\n",
              "      <td>40</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>974</th>\n",
              "      <td>186</td>\n",
              "      <td>2244</td>\n",
              "      <td>356</td>\n",
              "      <td>8560</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>101 rows × 5 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "     sexe    hosp    rea     rad      dc\n",
              "dep                                     \n",
              "75    186  274764  62989  327531  120586\n",
              "94    186  191848  28023  190231   74091\n",
              "92    186  189891  34564  224319   69281\n",
              "68    186  107602  13569  163294   67506\n",
              "93    186  149189  21234  174099   67380\n",
              "..    ...     ...    ...     ...     ...\n",
              "82    186    1328    720    2399     358\n",
              "09    186    1135    284    2141     134\n",
              "973   186     647     46    2638      56\n",
              "48    186     492     80    1470      40\n",
              "974   186    2244    356    8560       0\n",
              "\n",
              "[101 rows x 5 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 27
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "uu2pM9C0Ws3T",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 399
        },
        "outputId": "1d92f3a7-5a20-4129-9fc5-54189e7c91ee"
      },
      "source": [
        "#Filtrer uniquement par departement et nombre de décès : \n",
        "dep_dc=data_dep_dc[['dep', 'dc']]\n",
        "dep_dc"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>01</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>01</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>01</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>02</td>\n",
              "      <td>11</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>02</td>\n",
              "      <td>6</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>18784</th>\n",
              "      <td>974</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>18785</th>\n",
              "      <td>974</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>18786</th>\n",
              "      <td>976</td>\n",
              "      <td>18</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>18787</th>\n",
              "      <td>976</td>\n",
              "      <td>12</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>18788</th>\n",
              "      <td>976</td>\n",
              "      <td>6</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>18789 rows × 2 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "       dep  dc\n",
              "0       01   0\n",
              "1       01   0\n",
              "2       01   0\n",
              "3       02  11\n",
              "4       02   6\n",
              "...    ...  ..\n",
              "18784  974   0\n",
              "18785  974   0\n",
              "18786  976  18\n",
              "18787  976  12\n",
              "18788  976   6\n",
              "\n",
              "[18789 rows x 2 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 80
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "vqDJaAnkXbbL",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 370
        },
        "outputId": "8f09c373-e9a9-415b-f550-06f484bce7db"
      },
      "source": [
        "df_distrub_dc_dep = dep_dc.groupby('dep', as_index=True).sum().sort_values(['dc'], ascending=False)\n",
        "df_distrub_dc_dep.head(10)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>dep</th>\n",
              "      <th></th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>75</th>\n",
              "      <td>120586</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>94</th>\n",
              "      <td>74091</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>92</th>\n",
              "      <td>69281</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>68</th>\n",
              "      <td>67506</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>93</th>\n",
              "      <td>67380</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>57</th>\n",
              "      <td>57916</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>95</th>\n",
              "      <td>47612</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>67</th>\n",
              "      <td>45853</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>69</th>\n",
              "      <td>42416</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>77</th>\n",
              "      <td>38025</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "         dc\n",
              "dep        \n",
              "75   120586\n",
              "94    74091\n",
              "92    69281\n",
              "68    67506\n",
              "93    67380\n",
              "57    57916\n",
              "95    47612\n",
              "67    45853\n",
              "69    42416\n",
              "77    38025"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 81
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "zrCVFj00kqnx"
      },
      "source": [
        "df_distrub_dc_dep=df_distrub_dc_dep.head(10)"
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "DQ7fsX4Skv8B",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 487
        },
        "outputId": "95554bd3-b5d4-4478-c513-35ad7bf849f3"
      },
      "source": [
        "ax = df_distrub_dc_dep.plot(kind = \"bar\", figsize=(20,7))\n",
        "ax.set_xlabel(\"Departements\", fontsize=16)\n",
        "ax.set_title(\"distribution du TOP 10 des Departements ayant le plus de décès  ( Données Hospitaliaires relatives à l'epidémie covid)\", fontsize=16)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "Text(0.5, 1.0, \"distribution du TOP 10 des Departements ayant le plus de décès  ( Données Hospitaliaires relatives à l'epidémie covid)\")"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 85
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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\n",
            "text/plain": [
              "<Figure size 1440x504 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "mzak8YlZX30N",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 494
        },
        "outputId": "459be5fc-09b8-4a8b-cde0-52c74293edab"
      },
      "source": [
        "ax = df_distrub_dc_dep.plot(kind = \"bar\", figsize=(20,7))\n",
        "ax.set_xlabel(\"Departements\", fontsize=16)\n",
        "ax.set_title(\"distribution par Départements du nombre de Décès total  ( Données Hospitaliaires relatives à l'epidémie covid)\", fontsize=16)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "Text(0.5, 1.0, \"distribution par Départements du nombre de Décès total  ( Données Hospitaliaires relatives à l'epidémie covid)\")"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 30
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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YFupqt3Tu8vP9fANbp50iwMAAABgNN3iAAAAABhNcAkAAACA0Xa6MZfudKc7tQ0bNmzvYgAAAADsNM4777yvt9b2nvXZThdc2rBhQzZu3Li9iwEAAACw06iqryz2mW5xAAAAAIwmuAQAAADAaIJLAAAAAIy20425BAAAALA9XXfdddm8eXOuueaa7V2UFdttt92yfv363PrWt557GsElAAAAgDW0efPm3P72t8+GDRtSVdu7OHNrreWyyy7L5s2bs99++809nW5xAAAAAGvommuuyV577XWzCiwlSVVlr732WnGLK8ElAAAAgDV2cw4uO/IAACAASURBVAssLRhTbsElAAAAgJ3ccccdlz/5kz/ZJvM25hIAAADANrThmNPXdH4XHn/Yms5vtbRcAgAAANgJvexlL8vd7373PPShD80FF1yQJNm0aVMe8YhH5H73u18OOOCAfPGLX1z1crRcAgAAANjJnHfeeTnttNPyyU9+Mtdff30OOOCA3P/+989TnvKUHHPMMTniiCNyzTXX5Pvf//6qlyW4BAAAALCT+fCHP5wjjjgit73tbZMkj3vc43L11Vfn4osvzhFHHJEk2W233dZkWbrFAQAAADCa4BIAAADATubggw/O29/+9lx99dW58sor84//+I/Zfffds379+rz97W9Pklx77bX5zne+s+plLRtcqqqTqurSqvq3ibQ/rqrPV9Wnq+ofqmqPic9eUFWbquqCqnrURPqhQ9qmqjpmIn2/qvrYkP7mqtp1SL/N8H7T8PmGVa8tAAAAwC3AAQcckCc/+cm53/3ul0c/+tH52Z/92STJ61//+pxwwgm5733vmwc/+MH56le/uuplVWtt6QxVBye5KsmprbX7DGmPTPKB1tr1VfXyJGmtPb+q7pXkTUkekOTHkrw/yd2HWf17kv+aZHOSc5P8Umvtc1X1liRva62dVlWvSfKp1tqrq+pZSe7bWvuNqjoyyRGttScvt0IHHnhg27hx40q3AwAAAMCaOP/883PPe95zexdjtFnlr6rzWmsHzsq/7IDerbV/mm411Fp738Tbc5I8cfj/8CSntdauTfLlqtqUHmhKkk2ttS8NBTotyeFVdX6ShyX55SHPKUmOS/LqYV7HDelvTfIXVVVtuWjYhA3HnL5V2oXHHzbv5AAAAAAsYy3GXPrvSd4z/L9PkosmPts8pC2W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\n",
            "text/plain": [
              "<Figure size 1440x504 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "rYBdJQFtbTD9"
      },
      "source": [
        "# **4) Qui sont les plus impactés par ce virus (Hommes/Femmes) ?\n",
        "  Représenter par genre la répartition des personnes hospitalisées,en réanimation, retournées à domicile ou décédées. "
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "vTCpfgGIbm1r",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 399
        },
        "outputId": "ac48d9b0-5750-45ee-b5f7-ecdf6dccaa4b"
      },
      "source": [
        "#Afin d'avoir la repartition par genre on utilise d'abord le fichier des données hospitaliaires contenant les info covid19 par Region et par sexe afin d'avoir les info globale :\n",
        "data_dep_sexe = pd.read_csv('/content/data2/donnees-hospitalieres-covid19-2020-05-19-19h00.csv',sep=';')\n",
        "data_dep_sexe.head(100)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>sexe</th>\n",
              "      <th>jour</th>\n",
              "      <th>hosp</th>\n",
              "      <th>rea</th>\n",
              "      <th>rad</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>01</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>2</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>01</td>\n",
              "      <td>1</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>01</td>\n",
              "      <td>2</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>3</th>\n",
              "      <td>02</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>41</td>\n",
              "      <td>10</td>\n",
              "      <td>18</td>\n",
              "      <td>11</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>4</th>\n",
              "      <td>02</td>\n",
              "      <td>1</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>19</td>\n",
              "      <td>4</td>\n",
              "      <td>11</td>\n",
              "      <td>6</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>95</th>\n",
              "      <td>31</td>\n",
              "      <td>2</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>8</td>\n",
              "      <td>1</td>\n",
              "      <td>7</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>96</th>\n",
              "      <td>32</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>97</th>\n",
              "      <td>32</td>\n",
              "      <td>1</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>1</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>98</th>\n",
              "      <td>32</td>\n",
              "      <td>2</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>99</th>\n",
              "      <td>33</td>\n",
              "      <td>0</td>\n",
              "      <td>2020-03-18</td>\n",
              "      <td>7</td>\n",
              "      <td>4</td>\n",
              "      <td>3</td>\n",
              "      <td>1</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>100 rows × 7 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "   dep  sexe        jour  hosp  rea  rad  dc\n",
              "0   01     0  2020-03-18     2    0    1   0\n",
              "1   01     1  2020-03-18     1    0    1   0\n",
              "2   01     2  2020-03-18     1    0    0   0\n",
              "3   02     0  2020-03-18    41   10   18  11\n",
              "4   02     1  2020-03-18    19    4   11   6\n",
              "..  ..   ...         ...   ...  ...  ...  ..\n",
              "95  31     2  2020-03-18     8    1    7   0\n",
              "96  32     0  2020-03-18     1    1    0   0\n",
              "97  32     1  2020-03-18     1    1    0   0\n",
              "98  32     2  2020-03-18     0    0    0   0\n",
              "99  33     0  2020-03-18     7    4    3   1\n",
              "\n",
              "[100 rows x 7 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 31
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "kDSnQPKyl9cP",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 135
        },
        "outputId": "c57566b1-878f-4952-b1cd-b13cdb5bd676"
      },
      "source": [
        "df_distrub_sex= data_dep_sexe.groupby('sexe', as_index=False).sum().sort_values(['hosp'], ascending=False)\n",
        "df_distrub_sex"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>sexe</th>\n",
              "      <th>hosp</th>\n",
              "      <th>rea</th>\n",
              "      <th>rad</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>0</th>\n",
              "      <td>0</td>\n",
              "      <td>1449287</td>\n",
              "      <td>266278</td>\n",
              "      <td>2009530</td>\n",
              "      <td>630966</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>1</th>\n",
              "      <td>1</td>\n",
              "      <td>780164</td>\n",
              "      <td>195191</td>\n",
              "      <td>1063311</td>\n",
              "      <td>374944</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2</th>\n",
              "      <td>2</td>\n",
              "      <td>656667</td>\n",
              "      <td>68924</td>\n",
              "      <td>932703</td>\n",
              "      <td>252624</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "</div>"
            ],
            "text/plain": [
              "   sexe     hosp     rea      rad      dc\n",
              "0     0  1449287  266278  2009530  630966\n",
              "1     1   780164  195191  1063311  374944\n",
              "2     2   656667   68924   932703  252624"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 32
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "ol0gUhdymifd",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 519
        },
        "outputId": "c0035ea3-3fd1-4622-b458-b7e40d5f276c"
      },
      "source": [
        "ax = df_distrub_sex.plot(kind = \"bar\", figsize=(20,7))\n",
        "ax.set_xlabel(\"Sexe\", fontsize=16)\n",
        "ax.xaxis.set_ticklabels(['Total', 'Hommes', 'Femmes'])\n",
        "        \n",
        "ax.set_title(\"distribution par sexe  ( Données Hospitaliaires relatives à l'epidémie covid)\", fontsize=16)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "Text(0.5, 1.0, \"distribution par sexe  ( Données Hospitaliaires relatives à l'epidémie covid)\")"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 33
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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MVtuueVE5SWHAAAAgAe81atX52EPe1h23nnnVNVChzNvWmu58cYbs3r16uyyyy4TTaNZGQAAAPCAd8cdd+SRj3zkAzoxlCRVlUc+8pHrVUNKcggAAAAYhAd6YmjK+q6n5BAAAADAgOlzCAAAABicnd/8uTmd36p3vGBO57cpqTkEAAAAMM9++MMf5gUveEH22Wef7LXXXvnYxz6Wiy++OIccckj233//PPe5z813v/vdrFmzJrvvvnuuuuqqJMlLXvKSvP/970+S/Nmf/VkOOOCA7L333jnhhBPmLDY1hwAAAADm2VlnnZXHPOYx+dznuhpLa9asyfOe97x85jOfyeLFi/Oxj30sb3nLW7J8+fK8973vzTHHHJPf/u3fzs0335zXvOY1Oeecc3L11Vfnq1/9alprOfLII3P++efn4IMP3ujYJIcAAAAA5tmTnvSk/O7v/m5+//d/P0cccUS22267XHbZZXnOc56TJLn77rvz6Ec/OknynOc8J5/4xCdy3HHH5etf/3qS5Jxzzsk555yTfffdN0ly66235uqrr5YcAgAAALg/2G233fK1r30tZ555Zv7wD/8wz3rWs7LnnnvmggsuWKvsT37yk6xcuTJbb711br755uy4445preX444/Pa1/72jmPTZ9DAAAAAPPsO9/5Trbeeuu87GUvy5ve9KZ85StfyQ033HBPcujOO+/M5ZdfniR517velSVLluTDH/5wXvWqV+XOO+/Mc5/73Cxfvjy33nprkuS6667L9ddfPyexzVpzqKoel+SDSX46SUtySmvt3WNlKsm7kzw/yW1Jjmmtfa0f98okf9gXfXtr7bQ5iRwAAADgfuIb3/hG3vSmN+VBD3pQttxyy7zvfe/LokWL8oY3vCFr1qzJXXfdlTe+8Y1ZtGhRPvCBD+SrX/1qHvawh+Xggw/O29/+9rz1rW/NypUrc9BBByVJtt1225x++ul51KMetdGxVWtt3QWqHp3k0a21r1XVw5JcnORFrbUrRso8P8l/T5ccemqSd7fWnlpV2ydZkWRpusTSxUn2b63dvK5lLl26tK1YsWIjVgsAAADgXitXrsySJUsWOoxNZrr1raqLW2tLx8vOWnOotfbdJN/t/7+lqlYmeWySK0aKvTDJB1uXabqwqh7RJ5UOTfL51tpNfRCfT3J4ko9syIoBa1u5x+Z3cVty5cqFDgEAAIAJrVefQ1W1c5J9k3xlbNRjk1w78n51P2ym4QAAAABsBiZODlXVtkn+NskbW2s/mOtAqurYqlpRVStuuOGGuZ49AAAAANOYKDlUVVumSwz9TWvtU9MUuS7J40be79gPm2n4Wlprp7TWlrbWli5evHiSsAAAAADYSLMmh/onkf1VkpWttT+fodgZSV5RnQOTrOn7Kjo7yWFVtV1VbZfksH4YAAAAAJuBWTukTvL0JC9P8o2quqQf9gdJdkqS1trJSc5M96Sya9I9yv5V/bibquptSS7qpztxqnNqAAAAABbeJE8r+1KSmqVMS3LcDOOWJ1m+QdEBAAAAPECsWrUqRxxxRC677LKFDuU+Jqk5BAAAAPDAsuzhczy/NXM7v01ovR5lDwAAAMCGu/vuu/Oa17wme+65Zw477LDcfvvtueSSS3LggQdm7733zlFHHZWbb745SfKe97wnP/dzP5e99947Rx99dJJk2bJlefnLX56DDjoou+66a97//vdvdEySQwAAAACbyNVXX53jjjsul19+eR7xiEfkb//2b/OKV7wi73znO3PppZfmSU96Ut761rcmSd7xjnfkX//1X3PppZfm5JNPvmcel156ac4999xccMEFOfHEE/Od73xno2KSHAIAAADYRHbZZZc8+clPTpLsv//++eY3v5nvf//7OeSQQ5Ikr3zlK3P++ecnSfbee++89KUvzemnn55Fi+7tGeiFL3xhHvrQh2aHHXbIM5/5zHz1q1/dqJgkhwAAAAA2kYc85CH3/L/FFlvk+9///oxlP/e5z+W4447L1772tRxwwAG56667kiRV931u2Pj79SU5BAAAALBAHv7wh2e77bbLF7/4xSTJhz70oRxyyCH5yU9+kmuvvTbPfOYz8853vjNr1qzJrbfemiT5zGc+kzvuuCM33nhjzjvvvBxwwAEbFYOnlQEAAAAsoNNOOy2ve93rctttt+UJT3hC/vqv/zp33313Xvayl2XNmjVpreUNb3hDHvGIRyTpmps985nPzPe+97380R/9UR7zmMds1PIlhwAAAIDhWYBHz++888657LLL7nn/e7/3e/f8f+GFF65V/ktf+tK089l7773zwQ9+cM7i0qwMAAAAYMDUHAIAAAC4n1i2bNmcz1PNIQAAAIABkxwCAAAAGDDJIQAAAIABkxwCAAAAGDDJIQAAAIAB87QyAAAAYHCedNqT5nR+33jlN9arfGstrbU86EELX29n4SMAAAAAGIBVq1Zl9913zyte8Yrstddeedvb3pYDDjgge++9d0444YR7yr3oRS/K/vvvnz333DOnnHLKvMel5hAAAADAJnL11VfntNNOyw9+8IN88pOfzFe/+tW01nLkkUfm/PPPz8EHH5zly5dn++23z+23354DDjggv/zLv5xHPvKR8xaTmkMAAAAAm8jjH//4HHjggTnnnHNyzjnnZN99981+++2XK6+8MldffXWS5D3veU/22WefHHjggbn22mvvGT5f1BwCAAAA2MJG7SYAACAASURBVES22WabJF2fQ8cff3xe+9rX3mf8eeedl3/8x3/MBRdckK233jqHHnpo7rjjjnmNSc0hAAAAgE3suc99bpYvX55bb701SXLdddfl+uuvz5o1a7Lddttl6623zpVXXpkLL7xw3mNRcwgAAABgEzvssMOycuXKHHTQQUmSbbfdNqeffnoOP/zwnHzyyVmyZEl23333HHjggfMeS7XW5n0h62vp0qVtxYoVCx0G3C+s3GPJQoewliVXrlzoEAAAAO5j5cqVWbJk87t/mi/TrW9VXdxaWzpeVrMyAAAAgAGTHAIAAAAYMMkhAAAAgAGTHAIAAAAYMMkhAAAAgAGTHAIAAAAYMMkhAAAAgM3UeeedlyOOOGJel7FoXucOAAAAsBlauceSOZ3fkitXrlf51lpaa3nQgxa+3s7CRwAAAAAwAKtWrcruu++eV7ziFdlrr73y6le/OkuXLs2ee+6ZE0444Z5yZ511VvbYY4/st99++dSnPjXvcak5BAAAALCJXH311TnttNNy4IEH5qabbsr222+fu+++O7/wC7+QSy+9NLvttlte85rX5Nxzz80Tn/jEvPjFL573mNQcAgAAANhEHv/4x+fAAw9Mknz84x/Pfvvtl3333TeXX355rrjiilx55ZXZZZddsuuuu6aq8rKXvWzeY1JzCAAAAGAT2WabbZIk3/72t/O///f/zkUXXZTtttsuxxxzTO64444FiUnNIQAAAIBN7Ac/+EG22WabPPzhD89//dd/5R/+4R+SJHvssUdWrVqVb37zm0mSj3zkI/Mey6w1h6pqeZIjklzfWttrmvFvSvLSkfktSbK4tXZTVa1KckuSu5Pc1VpbOleBAwAAANxf7bPPPtl3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\n",
            "text/plain": [
              "<Figure size 1440x504 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "ciMKhUm2zuG6"
      },
      "source": [
        "**Distrubutions des hospitalisations par genre ( hommes / femmes et total)** "
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "rYRvVVp3vepb",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 308
        },
        "outputId": "bb4ab0ce-04cf-4cff-d5b4-3f95941d6930"
      },
      "source": [
        "ax = sns.barplot(x = 'sexe', y= 'hosp', hue='hosp', data = df_distrub_sex)\n",
        "ax.xaxis.set_ticklabels(['Total', 'Hommes', 'Femmes'])"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "[Text(0, 0, 'Total'), Text(0, 0, 'Hommes'), Text(0, 0, 'Femmes')]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 34
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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o0aNYv78+QA0atSIli1bAjBy5Eguv/xymjdvDsBBBx20zXKffPJJ+vTpQ7Nmzepku2riawRmZlUsW7aMwsJCLrzwQo4++mguueQS/vnPfwLw29/+lk6dOnHRRRdVPJtg4cKFSKJXr1506dKFu+++G6Ci07qbbrqJLl26cNZZZ/H+++9XzLNw4UJOOOEEjjvuOF544YVt6hg7diznnFPr+252mYPAzKyK8vJyZs2axeDBg3nzzTfZe++9+cUvfsHgwYNZsmQJpaWlHHLIIVx//fUV7V955RX+8Ic/8Morr/DUU08xefJkysvLKSsr4/jjj2fWrFl079694rRSeXk5ixYtYtq0aYwZM4ZBgwZt1dvpe++9x5w5c+jVq1fq2+sgMDOroqioiKKiIr797W8DcOaZZzJr1iwOPvhgGjduTKNGjRg0aFDFswaKioro0aMHLVu2pFmzZvTt25dZs2bRokULmjVrxumnnw7AWWedxaxZsyrm6devH02bNqVdu3YcccQRLFq0qKKGcePGMWDAgIprDWlyEJiZVfG1r32NNm3asGDBAgAmT55Mhw4deO+99yraPPXUUxUPu+/Vqxdz5sxh/fr1lJeX89JLL9GhQwck8YMf/IBp06ZttRyA/v37V4z/8MMPWbhwIYcddljF8seMGVMvp4XAF4vNrAGoze2ede3+++9n4MCBbNy4saL76auuuorS0lIkUVxczEMPPQRA8+bNue666zj22GORRN++ffne974HwLBhwzjvvPO45pprKCws5JFHHgFy4TFp0iQ6dOhA48aNueeeeyouMi9fvpwVK1ZUPBktbYqIellRXenatWuUlJTku4zd0gn3n5CX9b565at5Wa/tud5++22++c1v5ruMBqu6z0/SGxHRtbr2PjVkZpZxDgIzs4xzEJiZZZyDwMws4xwEZmYZ5yAwM8s4f4/AzHZ779zesU6X1/bmOTtss2DBAn70ox9VDC9dupTbb7+dU045hcsuu4wNGzbQpEkTHnjgAbp160ZEcPXVVzNhwgSaNWvG6NGj6dKlCwC9e/dmxowZnHjiiTz77LMVy4wIfv7zn/PnP/+Zxo0bM3jwYK666qqK6TNnzqR79+6MHTuWM888sw4/ga05CMzMqvGNb3yjojvozZs307p1awYMGMCgQYO45ZZb6NOnDxMmTOBf//VfmTZtGs8//zyLFi1i0aJFvP766wwePJjXX38dgKFDh7J+/fqKL6BtMXr0aFasWMH8+fNp1KhRRVfUW9Z5ww03pN4FNfjUkJnZDk2ePJmvf/3rHHrooUjik08+AXLdVbdq1QqAZ555hvPPPx9JHHfccaxZs6aiS4rvfOc77Lvvvtss93e/+x0333wzjRrlfhVX7or6/vvv54wzzqi2e+q6lloQSBol6QNJb9UwfaCk2ZLmSPqrpM5p1WJm9mVU7g76N7/5DUOHDqVNmzYMGTKEu+66C4CVK1fSpk2binmKiopYuXLldpe7ZMkS/vSnP9G1a1f69OlT0encypUreeqppxg8eHBKW7S1NI8IRgO9tzN9GXByRHQE/g0YkWItZma7ZOPGjYwfP56zzjoLyP0Vf++997JixQruvfdeLr744l1e9ueff05BQQElJSUMGjSIiy66CIBrrrmGYcOGVRwppC21tUTEdOCj7Uz/a0R8nAzOAIrSqsXMbFc9//zzdOnShYMPPhiARx99dKtupbd0Rd26dWtWrFhRMV9ZWRmtW7fe7rKLiooqljVgwABmz54NQElJCWeffTbFxcU8+eST/PSnP+Xpp5+u823bYne5RnAx8HxNEyVdKqlEUsmqVavqsSwzy7qq3UG3atWKl156CYApU6bQvn17APr168djjz1GRDBjxgz2339/DjnkkO0uu3///kydOhWAl156iSOOOALIPSFt+fLlLF++nDPPPJMHHnhgz354vaSe5ILgxJraRMQIklNHXbt2bVjdpZrZl1ab2z3T8M9//pMXX3xxq7t9Ro4cydVXX015eTkFBQWMGJE7q923b18mTJjA4YcfTrNmzSq6mwY46aSTmD9/PuvWraOoqIjf//739OrVixtvvJGBAwdy7733ss8++/Dwww/X+zZCnoNAUifgYaBPRKzOZy1mZlXtvfferF699a+mE088kTfeeGObtpIYPnx4tct5+eWXqx1/wAEH8Nxzz223htGjR9eu2C8hb6eGJLUF/hM4LyIW5qsOM7OsS+2IQNIY4BSgpaQy4BagKUBEPAjcDLQAHpAEUF7TQxPMzCw9qQVBRGz3YZsRcQlwSVrrNzOz2tld7hoyM7M8cRCYmWWcg8DMLOPy/j0CM7MdOeH+E+p0ea9e+eoO21x00UU8++yzHHTQQbz11tZdpv3qV79iyJAhrFq1ipYtW1aM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\n",
            "text/plain": [
              "<Figure size 432x288 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "3cXKullM7Zhv"
      },
      "source": [
        "le nombre d'hommes hospitalisés est supérieurs au nombre de femmes hospitalisées.\n",
        "Ce sont donc les hommes qui sont les plus touchés par le virus , il se peut que d'autres facteurs entrent en jeux , mais pour cette analyse nous nous sommes uniquement basé sur le nombres , par genre , d'hospitalisations , de personnes en réanimations , de retours à domicile et de décès .\n"
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "YFh_-IR-0C0-"
      },
      "source": [
        "**Distribution des décès par genre ( hommes/femmes et total) :**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "jbxBmeOJzrVA",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 297
        },
        "outputId": "ce699394-df81-4aca-fc3a-a51e147823f9"
      },
      "source": [
        "ax = sns.barplot(x = 'sexe', y= 'dc', hue='dc', data = df_distrub_sex)\n",
        "ax.xaxis.set_ticklabels(['Total', 'Hommes', 'Femmes'])"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "[Text(0, 0, 'Total'), Text(0, 0, 'Hommes'), Text(0, 0, 'Femmes')]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 35
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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KGDEiBEAPProo/To0YOsrCyipMtiIiLHgb1799K3b1/69+/PlVdeCUCTJv/5/PdNN93EFVdcUTpfXFxMnz59mDx5Mt/85jcBaNiwIXXq1Cld/6qrruLJJ58sXeevf/0rY8aM4Y033qB27doA/P3vf+ett97i0UcfZfv27ezZs4d69epx3333HdPxKFxERNLM3Rk0aBBt2rThjjvuKK2vW7eu9F7Myy+/zFlnxZ5fKikp4fLLL+e+++7j/PPPL21vZnzve99j/vz5XHzxxcydO5e2bdsCsHTpUn7wgx8wa9YsGjduXLrOs88+Wzo9ceJECgoKjjlYQOEiIvIlh3t0OGpvv/02Tz/9NGeffTbnnHMOEHvs+LnnnqOwsBAzIzs7u/Ty17hx4ygqKmL06NGMHj0agL/85S80btyY+++/n+uvv57hw4eTmZnJU089BcCIESPYvn07V111FQAtWrRgxowZSTsmiz0BLLm5uR7VUxKVzfmPnH/4RhF7+7a3U96nVF0rVqygTZs26d6N416i35OZLXb3L33kRDf0RUQkcgoXERGJnMJFREQip3AREZHIKVxERCRyChcREYmcPuciIlLGv0afHen2Wvzs3QqX79q1i65du7J792727dtHv379+PnPf86FF17Itm3bANi4cSOdOnVi2rRppestWrSILl26MGXKFPr16wfAyJEjefXVV4HYGGPXXHPNIX3dfvvtTJgwge3btx9Sf+mll+jXrx+LFi0iNzfRYPZHR+EiIpJmtWvXZt68edSrV4+9e/dywQUX0L17d956663SNn379qVXr16l8/v372fkyJHk5eWV1l599VWWLFlCYWEhu3fvplu3bnTv3p369esDUFBQkHDwy23btvHwww+XDpYZBV0WExFJMzOjXr16QGyMsb179xL7gt2Yzz//nHnz5tG7d+/S2iOPPELfvn0PGcrl/fffp2vXrtSoUYO6devSrl07Zs2aBcTCaMSIEfzqV7/6Uv8//elPGTlyJBkZGZEdk8JFROQ4sH//fs455xwaN27MpZdeeshZxLRp07jkkktKz0DWrl3Lyy+/zNChQw/ZRvv27Zk1axY7duzg008/5fXXX2fNmjVAbMiYnj17lo5VdtCSJUtYs2YNl19+eaTHo8tiIiLHgerVq1NYWEhJSQl9+vRh+fLlpQNVPvfccwwePLi07fDh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\n",
            "text/plain": [
              "<Figure size 432x288 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "7J3tMvRS0bCR"
      },
      "source": [
        "**Distribution des personnes en réanimation par genre ( hommes/femmes et total) :**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "XY2oBRAG0kVQ",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 297
        },
        "outputId": "802acceb-0fcb-4ebe-8f80-b5e0b6c2e0f0"
      },
      "source": [
        "ax = sns.barplot(x = 'sexe', y= 'rea', hue='rea', data = df_distrub_sex)\n",
        "ax.xaxis.set_ticklabels(['Total', 'Hommes', 'Femmes'])"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "[Text(0, 0, 'Total'), Text(0, 0, 'Hommes'), Text(0, 0, 'Femmes')]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 36
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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\n",
            "text/plain": [
              "<Figure size 432x288 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "KBwtPVg60rvU"
      },
      "source": [
        "**Distribution des personnes retournés au domicile après hospitalisation covid 19 par genre ( hommes/femmes et total) :**"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "TgUM9gEo01Oz",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 308
        },
        "outputId": "68f8b46e-a9a3-468a-ab02-0d86bfa4771f"
      },
      "source": [
        "ax = sns.barplot(x = 'sexe', y= 'rad', hue='rad', data = df_distrub_sex)\n",
        "ax.xaxis.set_ticklabels(['Total', 'Hommes', 'Femmes'])"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "[Text(0, 0, 'Total'), Text(0, 0, 'Hommes'), Text(0, 0, 'Femmes')]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 37
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "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p048/fTTvP/++wwdOpRt27axY8cOzjvvPK699logd5V2WVkZEcExxxxDaWkpbdu2ZdGiRUyaNImKigruvfdezjvvvKqaRo0axeLFiznllFN45JFH6u3zyGwLQtI9wB+BYyVVSpog6WuSvpbX7Wzg8Yh4J6/tSOD3kpYBzwGPRsS8rOo0M6uLr3zlK8ybt/uvpJqG537jjTf4xje+wZw5c1ixYgW//e1vATjssMN48sknq4bunjdvHosXLwbgZz/7GcuWLaOiooIePXpUjenUo0cPSktL+eIXv7hHTVdeeSV33XVXvb/XzLYgImJsLfqUkjsdNr9tHdA/m6rMzA7M0KFDWb9+/W5ts2fPZuHChUBueO5hw4Yxbdo0fvOb33DOOefQo0cPgKoxlSTRtm1bALZv38727durrojeNWx4RPDee+9VtRcXFwPQrNmef9cPHz68av31qSEcgzAza9RqGp77pZdeYuvWrQwbNoxBgwYxc+b/3QFv586dDBgwgC5dujBixAiGDBlSNe/iiy/mqKOOYtWqVVx++eUH983kcUCYmdWj/OG5d+zYwdKlS3n00UeZP38+1113HS+99BIAzZs3p7y8nMrKSp577rmq4xkAd9xxB3/729/o27cv9913X0HeBzggzMwOWE3DcxcVFXHaaafRpk0bOnXqxNChQ1m2bNluyx5xxBF8/vOf3+O4RvPmzbnwwgt3Gzb8YHNAmJkdoJqG5x4zZgy///3v2bFjB++++y7PPvssffv2ZdOmTbzxxhsAvPfeeyxYsIA+ffoQEaxduxbIHYOYM2dO1bDhheDhvs2s0arNaan1bezYsSxcuJDXX3+doqIirr322hqH5+7bty+jRo3ihBNOoFmzZlxyySX069ePiooKxo8fz86dO/nwww85//zzOeuss/jwww8ZP348b775JhFB//79ufnmmwFYsmQJZ599Nlu3buXhhx9mypQprFixAoBTTz2VVatW8fbbb1NUVMTtt9/OaaeddsDv1cN9HwI83Lc1FR7u+8DUdbhv72IyM7NUDggzM0vlgDAzs1QOCDMzS+WAMDOzVA4IMzNL5esgzKzRqu9TuGtzavaGDRu46KKLePXVV5HExIkTueKKK2oc8jsiuOKKK5g7dy6tW7emtLSUgQMHAvDd736XRx99FIDJkydzwQUXALkRY59++mnatWsHQGlp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\n",
            "text/plain": [
              "<Figure size 432x288 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "IgnpG-Gc1JlD"
      },
      "source": [
        "**Représentation de cette évolution sur un axe de temps : **"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "hCxvocPSG6OI",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 428
        },
        "outputId": "188f27ac-4735-4743-da9c-91e55e15a042"
      },
      "source": [
        "\n",
        "df = pd.read_csv('/content/data2/donnees-hospitalieres-covid19-2020-05-19-19h00.csv', sep=\";\", parse_dates=True, index_col=2)\n",
        "df = df.query(\"sexe == 0\")  # sum male/female\n",
        "df.drop(columns=[\"sexe\"], inplace=True)\n",
        "df.sort_index(inplace=True)\n",
        "df.head(100)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>hosp</th>\n",
              "      <th>rea</th>\n",
              "      <th>rad</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>jour</th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>01</td>\n",
              "      <td>2</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>02</td>\n",
              "      <td>41</td>\n",
              "      <td>10</td>\n",
              "      <td>18</td>\n",
              "      <td>11</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>03</td>\n",
              "      <td>4</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>04</td>\n",
              "      <td>3</td>\n",
              "      <td>1</td>\n",
              "      <td>2</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>05</td>\n",
              "      <td>8</td>\n",
              "      <td>1</td>\n",
              "      <td>9</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>95</td>\n",
              "      <td>90</td>\n",
              "      <td>29</td>\n",
              "      <td>21</td>\n",
              "      <td>2</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>971</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>972</td>\n",
              "      <td>16</td>\n",
              "      <td>5</td>\n",
              "      <td>0</td>\n",
              "      <td>1</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>973</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>974</td>\n",
              "      <td>2</td>\n",
              "      <td>2</td>\n",
              "      <td>0</td>\n",
              "      <td>0</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>100 rows × 5 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "            dep  hosp  rea  rad  dc\n",
              "jour                               \n",
              "2020-03-18   01     2    0    1   0\n",
              "2020-03-18   02    41   10   18  11\n",
              "2020-03-18   03     4    0    1   0\n",
              "2020-03-18   04     3    1    2   0\n",
              "2020-03-18   05     8    1    9   0\n",
              "...         ...   ...  ...  ...  ..\n",
              "2020-03-18   95    90   29   21   2\n",
              "2020-03-18  971     0    0    0   0\n",
              "2020-03-18  972    16    5    0   1\n",
              "2020-03-18  973     0    0    0   0\n",
              "2020-03-18  974     2    2    0   0\n",
              "\n",
              "[100 rows x 5 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 44
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "FsNZjysAHXhz",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 428
        },
        "outputId": "08bdf15c-4b48-452f-cc51-8ea03e5d141c"
      },
      "source": [
        "df_distrub_tot= df.groupby([\"jour\"], as_index=True).sum().sort_values(['hosp'], ascending=False)\n",
        "df_distrub_tot\n"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>hosp</th>\n",
              "      <th>rea</th>\n",
              "      <th>rad</th>\n",
              "      <th>dc</th>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>jour</th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "      <th></th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>2020-04-14</th>\n",
              "      <td>32131</td>\n",
              "      <td>6599</td>\n",
              "      <td>28804</td>\n",
              "      <td>10129</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-04-13</th>\n",
              "      <td>31952</td>\n",
              "      <td>6690</td>\n",
              "      <td>27717</td>\n",
              "      <td>9588</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-04-12</th>\n",
              "      <td>31665</td>\n",
              "      <td>6714</td>\n",
              "      <td>27185</td>\n",
              "      <td>9253</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-04-15</th>\n",
              "      <td>31623</td>\n",
              "      <td>6331</td>\n",
              "      <td>30952</td>\n",
              "      <td>10643</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-04-16</th>\n",
              "      <td>31172</td>\n",
              "      <td>6139</td>\n",
              "      <td>32806</td>\n",
              "      <td>11053</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-22</th>\n",
              "      <td>6954</td>\n",
              "      <td>1674</td>\n",
              "      <td>2117</td>\n",
              "      <td>632</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-21</th>\n",
              "      <td>5900</td>\n",
              "      <td>1453</td>\n",
              "      <td>1811</td>\n",
              "      <td>525</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-20</th>\n",
              "      <td>5226</td>\n",
              "      <td>1297</td>\n",
              "      <td>1587</td>\n",
              "      <td>450</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-19</th>\n",
              "      <td>4073</td>\n",
              "      <td>1002</td>\n",
              "      <td>1180</td>\n",
              "      <td>327</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>2020-03-18</th>\n",
              "      <td>2972</td>\n",
              "      <td>771</td>\n",
              "      <td>816</td>\n",
              "      <td>218</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>62 rows × 4 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "             hosp   rea    rad     dc\n",
              "jour                                 \n",
              "2020-04-14  32131  6599  28804  10129\n",
              "2020-04-13  31952  6690  27717   9588\n",
              "2020-04-12  31665  6714  27185   9253\n",
              "2020-04-15  31623  6331  30952  10643\n",
              "2020-04-16  31172  6139  32806  11053\n",
              "...           ...   ...    ...    ...\n",
              "2020-03-22   6954  1674   2117    632\n",
              "2020-03-21   5900  1453   1811    525\n",
              "2020-03-20   5226  1297   1587    450\n",
              "2020-03-19   4073  1002   1180    327\n",
              "2020-03-18   2972   771    816    218\n",
              "\n",
              "[62 rows x 4 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 46
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "4ZFo2LOKIZRc",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 297
        },
        "outputId": "9d57aab5-702a-4148-b528-49b6ed370008"
      },
      "source": [
        "ax=sns.lineplot(data=df_distrub_tot, palette=\"tab10\", linewidth=2.5)\n",
        "\n"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "<matplotlib.axes._subplots.AxesSubplot at 0x7fce89f5a2e8>"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 75
        },
        {
          "output_type": "display_data",
          "data": {
            "image/png": "iVBORw0KGgoAAAANSUhEUgAAAaAAAAEGCAYAAAAjc0GqAAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEgAACxIB0t1+/AAAADh0RVh0U29mdHdhcmUAbWF0cGxvdGxpYiB2ZXJzaW9uMy4yLjEsIGh0dHA6Ly9tYXRwbG90bGliLm9yZy+j8jraAAAgAElEQVR4nOzdd3hUVfrA8e+Zkkx6bySkQULoLUBAqggGUBFkERURC3bRdd1V1wIWXN1dXctvRcFVQSzryiqiYEFFcKWF3gmEQHrvySRTzu+PGWKQIAES7iScz/PMk5kz9968F5K8c8597zlCSomiKIqiXGg6rQNQFEVRLk4qASmKoiiaUAlIURRF0YRKQIqiKIomVAJSFEVRNGHQOoBzFRwcLGNjY7UOQ1EUpd3YunVrsZQyROs4Tmi3CSg2Npa0tDStw1AURWk3hBDHtI6hKTUEpyiKomhCJSBFURRFEyoBKYqiKJpot9eAmmOxWMjOzsZsNmsdSpsymUxERUVhNBq1DkVRFOWcdagElJ2djY+PD7GxsQghtA6nTUgpKSkpITs7m7i4OK3DURRFOWcdagjObDYTFBTUYZMPgBCCoKCgDt/LUxSl4+tQCQjo0MnnhIvhHBVF6fg6XAJSFEXpaKSUrM9ez1MbnqIjLaGjElAryszMpFevXlqHoShKB7M5fzN3f3c3nxz6hPU567UOp9WoBKQoiuJipJQcKD3A5rzNAAwOH0zv4N54G70pqSvROLrWoxJQK7PZbMyZM4eePXsyfvx46urq2LFjBykpKfTp04cpU6ZQVlYGwKuvvkqPHj3o06cPM2bMAGD+/PnceOONDB06lISEBBYvXqzl6SiKooGnNjzF71b+jj//9GfMVjNCCBYMX8CqqauYkjBF6/BaTYcqw27qqZV72Zdb2arH7NHJl3lX9vzNbdLT0/nwww9ZvHgx06dPZ/ny5fz1r3/ltddeY9SoUTz55JM89dRTvPzyyzz//PMcPXoUd3d3ysvLG4+xa9cuNm7cSE1NDf3792fSpEl06tSpVc9FURRt1Fpq2VG0g55BPfFz9+NQ2SEW71pMZmUmS1KX4Gn0pH9of5anL6ewtpBNeZsY1XkUcX4d77YL1QNqZXFxcfTr1w+AgQMHcuTIEcrLyxk1ahQAN910E+vWrQOgT58+3HDDDSxbtgyD4ZfPApMnT8bDw4Pg4GDGjBnD5s2bL/yJKIrS6n44/gOX/udS7vj2DvaV7AMcCemrzK84UHqAn3J+AmBM9BgeHPggq69ZzajOo7QMuU21qAckhPAH3gJ6ARK4BTgI/BuIBTKB6VLKMuGoEX4FmAjUArOllNucx7kJeNx52GellEuc7QOBdwEPYBVwvzzPUo8z9VTairu7e+NzvV5/Us/m17788kvWrVvHypUrWbBgAbt37wZOLbNWZdeK0j6ZrWZWHV1Fn+A+dA3oSmJgIrWWWgCK64oBCPUMJdonmjCvMNz0bgD4uvlyc6+bNYv7QmlpD+gV4CspZRLQF9gPPAJ8J6VMAL5zvgaYACQ4H7cDCwGEEIHAPGAIMBiYJ4QIcO6zEJjTZL/U8zst1+Hn50dAQADr1zsqV9577z1GjRqF3W4nKyuLMWPG8MILL1BRUUF1dTUAK1aswGw2U1JSwtq1axk0aJCWp6AoyjkoM5cx+bPJzPt5Hh8c+ACASO9I7uh7By+OepERkSMA6OTdiS+nfsnbl7/N6M6jNYz4wjtjD0gI4QeMBGYDSCkbgAYhxGRgtHOzJcBa4GFgMrDU2YPZKITwF0JEOLf9VkpZ6jzut0CqEGIt4Cul3OhsXwpcDaxulTN0AUuWLOHOO++ktraW+Ph43nnnHWw2GzNnzqSiogIpJXPnzsXf3x9wDM2NGTOG4uJinnjiCXX9R1HakcqGSnzdfAkwBdDFvwu5NbmkFaRhl3Z0Qsc9/e7ROkSX0ZIhuDigCHhHCNEX2ArcD4RJKfOc2+QDYc7nkUBWk/2znW2/1Z7dTPsphBC34+hVER0d3YLQL6zY2Fj27NnT+Pqhhx5qfL5x48ZTtv/pp5+aPU6fPn1YunRp6weoKEqbKaot4tXtr7Iuex2fX/05fu5+/HHQHxndeTRTE6aiE+qS+6+15F/EAAwAFkop+wM1/DLcBoCzt9Pmt+dKKRdJKZOllMkhIS6zqqyiKAo7inbw2eHPKDWX8sbONwCI84tjerfpGHQdtuD4vLTkXyUbyJZSbnK+/gRHAioQQkRIKfOcQ2yFzvdzgM5N9o9ytuXwy5Ddifa1zvaoZra/KM2fP1/rEBRFaQEpJd8d/w6BYGzMWC6LvoxB4YPwMngxI2mG1uG1C2dMQFLKfCFElhCim5TyIDAW2Od83AQ87/y6wrnL58C9QoiPcBQcVDiT1NfAc00KD8YDj0opS4UQlUKIFGATMAt4rRXPUVEUpdU9sv4RVh1dRYhHCEM7DcXT6Mn/Xfp/eBo9tQ6t3WjpoOR9wPtCiF1AP+A5HIlnnBAiHbjM+RocZdQZwGFgMXA3gLP44Blgi/Px9ImCBOc2bzn3OUIHKkBQFKXjKDeXN04GeknkJQBY7BbSy9MBVPI5Sy0amJRS7gCSm3lrbDPbSqDZMg8p5dvA2820p+G4x0hRFMXlNNgaeH//+7y5602eHvY042PHc0X8FZTWlTIlYQp+7n5ah9guqbIMRVGUM6iz1vH2nrepsdTw0taXsNgs6ISO2b1mq+RzHlQCUhRFaUa9rZ6vjn4FgJ+7H/f2u5c4vzgeT3kco96ocXQdg6oNbCNSSqSU6HQqxytKe3O47DB/+PEPZFRkYDKYGN15NNMSpzE1cSpGnUo+rUX9dWxFmZmZdOvWjVmzZtGrVy+eeeYZBg0aRJ8+fZg3b17jdldffTUDBw6kZ8+eLFq0SMOIFUVpqs5aB4C3mzdFtUUALE9fDoBep1fJp5V17B7QO5Oab7/5S8fX1Y9A/u5T30/9C0T0ge3vw44PTt3vN6Snp7NkyRIqKyv55JNP2Lx5M1JKrrrqKtatW8fIkSN5++23CQwMpK6ujkGDBnHNNdcQFBR0DieoKEprWH10Ncv2L6OqoYoVk1cQ7hXOn1P+TG51Lrf0ukXr8Dqsjp2ANBATE0NKSgoPPfQQ33zzDf379wegurqa9PR0Ro4cyauvvsqnn34KQFZWFunp6SoBKUobKjeX4+3mjUFnYH/Jfj46+BH5Nfk8Newpwr3CyavJY1fRLgCOlB+ha0BXroi/QuOoO76OnYDO1GOZ8Pxvv9//BsfjLHh5eQGOa0CPPvood9xxx0nvr127ljVr1rBhwwY8PT0ZPXo0ZrP5rL6HoiinJ6VsXMLk59yfeXT9o5SaS/nkyk/oFtiNMnMZ/03/LwDZVdmEe4UzLnocyw8tZ1zMOLzdvLUM/6KirgG1kcsvv5y33367cYmFnJwcCgsLqaioICAgAE9PTw4cONDsJKWKopw9q93KFxlfMG3lNLIqHfMeB5oCKTU77nc/Un4EgHDvcAJNgfQI6oF0TmHZ2bczX0z5ggcGPkC4V7g2J3AR6tg9IA2NHz+e/fv3M3ToUAC8vb1ZtmwZqampvPHGG3Tv3p1u3bqRkpKicaSK0jEcrTjKo+sfBeCtPW/x1LCniPWN5aouV9HFvwtJQUkAxPvF8+O1P56yv1r48cIT57nwqGaSk5NlWlraSW379++ne/fuGkV0YV1M56oop7O3eC/5tfmMjXZMyjL3+7nsLNrJbb1v48YeN2ocnesRQmyVUjY3q40mVA9IUZR26b197/Fi2ot4GDzoObkn4V7hPJ7yOD5uPngYPLQOT2kBdQ1IUZR2KcY3Bpu0YbaZ2V64HYBQz1CVfNoR1QNSFKVdkFKybP8yAkwBXBF/BSOjRjK3/1xGRI0gKTBJ6/CUc6ASkKIo7cLTG5/mk0Of4GP0ITksmXCvcOb0maN1WMp5UENwiqK0C8M7DQcc0+RU1FdoHI3SGlQPSFEUl/Vz7s9Y7VZGRo1kbMxYnr3kWUZGjSTAFHDmnRWXp3pAGlu7di1XXKGm/FCUX3t///vcteYuHl73MEcrjgIwuetklXw6EJWA2oiUErvdrnUYitJu+bv7Y5d2rHYrmRWZWoejtAE1BNeKMjMzufzyyxkyZAhbt25l8ODB7N69m7q6OqZNm8ZTTz0FwFdffcUDDzyAp6cnw4cP1zhqRXEdZquZY5XH6BbYjUnxk6huqKZPSB+6B6mbrjuiDt0Duvmrm/ns8Get+vxM0tPTufvuu9m7dy8vvvgiaWlp7Nq1ix9//JFdu3ZhNpuZM2cOK1euZOvWreTn57fqOStKe1VmLmPON3O4+eubySjPAODapGtV8unAOnQC0sKJ5RgAPv74YwYMGED//v3Zu3cv+/bt48CBA8TFxZGQkIAQgpkzZ2ocsaK4hi35W9hRtIOqhir+tedfWoejXAAdegjundR3Wv35mZxYjuHo0aP8/e9/Z8uWLQQEBDB79my17IKiNFFYW8jKIyvJrc7liaFPMD52PPdV3seR8iPMGzrvzAdQ2r0OnYC0VFlZiZeXF35+fhQUFLB69WpGjx5NUlISmZmZHDlyhC5duvDhhx9qHaqitLlaSy2Hyg5xrPIYY6LH4Ovmy1u73+LDAx8iENzW+zYivCOY03sOEolOqMGZi0GL/peFEJlCiN1CiB1CiDRnW6AQ4lshRLrza4CzXQghXhVCHBZC7BJCDGhynJuc26cLIW5q0j7QefzDzn3b/bzoffv2pX///iQlJXH99ddzySWXAGAymVi0aBGTJk1iwIABhIaGahyporSuWkstG3I38MbONyiuKwYgrSCNG1ffyOP/e5z0snQAru56NeBYHqGgtgBwLImgks/F42x6QGOklMVNXj8CfCelfF4I8Yjz9cPABCDB+RgCLASGCCECgXlAMiCBrUKIz6WUZc5t5gCbgFVAKrD6vM5MA7GxsezZs6fx9bvvvtvsdqmpqRw4cOACRaUobc9it6BDh16nZ3/pfm7/9nYAuvh3YVzMOKJ9ohu3PV55nIFhA+ke2J3/XPkfugV0U2vxXKTO56PGZGCJ8/kS4Oom7Uulw0bAXwgRAVwOfCulLHUmnW+BVOd7vlLKjdKxONHSJsdSFMWFNdga+PDAh1zx3yv49ti3APQM6olBOD7bnriBNNInktcufY0VV6/ginjHjddCCJICk1TyuYi1tAckgW+EEBJ4U0q5CAiTUuY5388HwpzPI4GsJvtmO9t+qz27mfZTCCFuB24HiI6Obm4TRVEuIJu0sXDHQsrqy3hr91tcHns5JoOJxeMX08W/S+OsBUadkdGdR2sbrOJyWtoDGi6lHIBjeO0eIcTIpm86ey5tvrSqlHKRlDJZSpkcEhLS1t9OUZRmlJnLWHF4BQAeBg9m9phJpHck07tNxy4ds38khyerKXOUM2pRD0hKmeP8WiiE+BQYDBQIISKklHnOYbRC5+Y5QOcmu0c523KA0b9qX+tsj2pme0VRXMzB0oPM/X4uuTW5eBo9GRczjlk9ZnFLr1sw6FRRrXJ2ztgDEkJ4CSF8TjwHxgN7gM+BE5VsNwErnM8/B2Y5q+FSgArnUN3XwHghRICzYm488LXzvUohRIqz+m1Wk2MpiuJC3PRuVDZUAvC/nP8BYDKYVPJRzklLfmrCgE+dFwoNwAdSyq+EEFuAj4UQtwLHgOnO7VcBE4HDQC1wM4CUslQI8Qywxbnd01LKUufzu4F3AQ8c1W/trgJOUToqKSUb8zYytNNQ4vzieGHkCxwpP8LsnrO1Dk1p586YgKSUGUDfZtpLgLHNtEvgntMc623g7Wba04BeLYi3XZk/fz7e3t489NBDWoeiKOds8e7FvLb9Nf4x+h9cFnMZI6NGMjJq5Jl3VJQzUHd8KYpyWvk1+byx8w0AFu5ciOPzpaK0DpWAWtmCBQtITExk+PDhHDx4EIDDhw9z2WWX0bdvXwYMGMCRI0c0jlJRWibcK5xF4xYR5R3FCyNeUPfsKK2qQ185PHbjrJNe+02Zgv/UKY3tYX9+FICC5/5y0na/bo95bynl//0U/6lTfvP7bd26lY8++ogdO3ZgtVoZMGAAAwcO5IYbbuCRRx5hypQpmM1mtVCd4vIq6ivIqsqiV3AvksOTWTllpSo0UFqd6gG1ovXr1zNlyhQ8PT3x9fXlqquuoq6ujpycHKZMcSQvk8mEp6enxpEqyulZ7VYe+vEhZq2e1Xi/j0o+Slvo0D9VMe8tbVF7S7Y7U+9HUTqK3cW7SctPwyqt/Jj9I1d1uUoNvSltQvWAWtHIkSP57LPPqKuro6qqipUrV+Lh4UFUVBSffeZYUbW+vp7a2lqNI1WUk9mlnTXH1mCxW+gf2p9F4xeREpHCs5c8q5KP0mZUAmpFAwYM4Nprr6Vv375MmDCBQYMGAfDee+/x6quv0qdPH4YNG6aW4VZcSlZVFtNXTuf3a3/P54c/B2BQ+CAWj1+Mp1ENFyttp0MPwWnhscce47HHHjul/fvvv9cgGkVpXq2llpzqHBICEgj1DKWioQKAjw99zNSEqarXo1wQKgEpykXmzZ1v8vaetwnzCmPF5BW46935/YDfk12dzczuM1XyUS4YlYAUpQPLrMhkdeZq9pXs49lLnsXP3Q93vTu11lqOVhxlR9EO+of2Z2L8RK1DVS5CHS4BSSk7/Cc4dTe68ltqLDV4Gb0AOF51nNd3vA7A/tL9pESkcFXXq9hWuI2pCVPpHdxby1CVi1yHKkIwmUyUlJR06D/QUkpKSkowmUxah6K4oB+O/8CE5RNYm7UWgB5BPQCI8o6i1uKovgw0BfLqpa8yuvNodX+PoinRXv9YJycny7S0tJPaLBYL2dnZmM1mjaK6MEwmE1FRURiNRq1DUVxIRX0FE5ZPoMpSRYB7AF9M/QJfN18qGyrxdfPVOjzFBQghtkopk7WO44QO9fHHaDQSFxendRiKckEV1RYR4hmCn7sfj6U8xoKNC3hk8CONSUclH8VVdaghOEW52GzK28SVn13Jj1k/AjApfhJfTP1CFRUo7YJKQIrSTlXUV/DADw9QY6lh3s/zMFsdQ8+BpkCNI1OUllEJSFHaKT93P5655Bnc9e48PPhhTAZVmKK0Lx3qGpCidHRSShbuXEhyWDKDIwZzWcxlrA5ZTYhniNahKcpZUwlIUdqR5zY9x0cHP8LL6MU7l79D96DuKvko7ZYaglOUdqRfaD8EAn93fzVRqNLuqR6Qori4WkstWVVZdAvsxqT4SQgEg8IHqZ6P0u6pHpCiuLByczm3fXMbt3x9C+ll6QBMjJ+oko/SIagEpCgubFP+JnYX76ayoZIle5doHY6itKoWJyAhhF4IsV0I8YXzdZwQYpMQ4rAQ4t9CCDdnu7vz9WHn+7FNjvGos/2gEOLyJu2pzrbDQohHWu/0FKV9OjFF1uWxl/OHgX9gQtwE5g2dp3FUitK6zqYHdD+wv8nrF4B/SCm7AmXArc72W4EyZ/s/nNshhOgBzAB6AqnA686kpgf+CUwAegDXObdVlItSRkUGM76cQWZFJgCze83mhREvYNSruf+UjqVFCUgIEQVMAt5yvhbApcAnzk2WAFc7n092vsb5/ljn9pOBj6SU9VLKo8BhYLDzcVhKmSGlbAA+cm6rKBedMnMZN391M/tK9nHbN7dRUe9YqbSjLzGiXJxa2gN6GfgTYHe+DgLKpZRW5+tsINL5PBLIAnC+X+HcvrH9V/ucrv0UQojbhRBpQoi0oqKiFoauKO1HgCmAGUkzAPhd4u/URKJKh3bGMmwhxBVAoZRyqxBidNuHdHpSykXAInAsx6BlLIrSmnYV7SLII4hI70ju7HMng8MHMzBsoNZhKUqbasl9QJcAVwkhJgImwBd4BfAXQhicvZwoIMe5fQ7QGcgWQhgAP6CkSfsJTfc5XbuidHjHKo9xz3f34G30ZsmEJYR6hqrko1wUzjgEJ6V8VEoZJaWMxVFE8L2U8gbgB2Cac7ObgBXO5587X+N8/3vpKOn5HJjhrJKLAxKAzcAWIMFZVefm/B6ft8rZKUo78NnhzyivLye7Opu0/LQz76AoHcT5zITwMPCREOJZYDvwL2f7v4D3hBCHgVIcCQUp5V4hxMfAPsAK3COltAEIIe4Fvgb0wNtSyr3nEZeitCtz+89FL/QAah0f5aLSoZbkVpT2wma38eauN7k+6Xr8Tf6A494fVe2mtCVXW5JbzYSgKBr4e9rfWbhzITNXzySn2nHJUyUf5WKjEpCiXGA2u40ScwkARp0RHzcfjSNSFG2o2bAV5QI4Xnmc17a/xqT4SYzuPJrnRzxPgn8CV8Rfoe71US5aKgEpShtrsDVw4+obKTWXcrj8MCMiR6DX6ZnTZ47WoSmKptQQnKK0ssqGSj4++DF//PGPSClx07sxq8csABICEqix1mgcoaK4BtUDUpRWtvzQcl7a+hIAN3S/gX6h/bih+w0M6zSM7kHdNY5OUVyH6gEpSiswW81Y7BYAruxyJXqhJ9wrnFJzKQAmg0klH0X5FdUDUpTzZLaamfv9XLzdvHlh5AsEewTzwaQP6BbQDb1Or3V4iuKyVAJSlPP02vbX2JC3AYDE3Ync2fdOegSpJa0U5UxUAlKU83RH3zvYVrAND6NHY7GBoihnphKQopwDi83CJ+mfcG23a/F182XR+EXohR5Po6fWoSlKu6ESkKKcJYvdwh/X/ZHvjn/H/pL9zB82X81moCjnQFXBKcpZqmqoIqMiA4CMigzMVrPGESlK+6QSkKK0kJQSKSWBpkDeufwdrupyFQsvW6iG3RTlHKkhOEVpASklCzYtwNPoye8H/J4gjyAWDF+gdViK0q6pBKQoLfD6ztf598F/A+Dr5sttvW/TOCJFaf/UEJyitMCEuAlE+0QT5R3FlfFXah2OonQIqgekXFTsdklRdT255XXklpvJq6jDbLExrGsw/aL80elOXhSu3FyOv8mfeL94Ppj0AbWWWsK8wjSKXlE6FpWAlA6rrKaBfXmV7MutZH9eJfvyKjlSVI3F1swy9N8cIsLPRGqvcCb2jmBgdADHqjKZuWomM3vM5M4+d+Ln7oefu9+FPxFF6aCElM38MrYDycnJMi0tTeswFBdzrKSG1XvyWb07j53ZFed8nGAfN0zRr1FhPwrAu6nvMjBsYGuFqSiaEEJslVImax3HCaoHpLQr9VYb24+XU17bQL3Vjtlio95qp7i6gTX7CtiXV9nsfkFebnSP8CUp3IfOgZ508vegk7+JTn4eWGx2vt6bz6rd+Ww6WoJdQnFVA7r0KXh0fhd7VT9e/NzCkLh0gn3c8PdwI8DTiJ+nkagAT/w8jBf4X0FROgbVA1JcXm2DlXWHili9J5/v9xdSVW894z7xIV5M6BVOcmwgPSJ8CfVxRwhxxv2Kq+tZuvVn9hz15ucjxZhtNWB353T1OnqdYERCMFf3i2RcjzC83NVnOsV1tbsekBDCBKwD3J3bfyKlnCeEiAM+AoKArcCNUsoGIYQ7sBQYCJQA10opM53HehS4FbABc6WUXzvbU4FXAD3wlpTy+VY9S6VdkVKSXljNxowSfkovZl16EWaL/Yz7dQvzYUJvxzWchFDvFiWcX9tavJZ3Mh/ivgH38c/rb2Hj0VLWHijk+4OFZJXWnbK9zS5Ze7CItQeLMBl1jOsRzpC4QNz0Ogx6gUGvw6ATjodeoNf98jo+xJsQH/ezjlFROooz9oCE47fYS0pZLYQwAj8B9wMPAv+VUn4khHgD2CmlXCiEuBvoI6W8UwgxA5gipbxWCNED+BAYDHQC1gCJzm9zCBgHZANbgOuklPt+Ky7VA+o4rDY7Bwuq2HasjI0ZpWzMKKGkpuGU7Tzd9IzpFsrlvcLpEuKFyajH3aDDZNTjYdSfd++j3lZP6vJUiuuK8XP34/OrPyfQFNj4vtlio7zWQnldA2U1FspqG/j5SDFf7sqjrNZy1t9PCOjf2Z9xPcIZ1yOMrqHe5xW/opyJq/WAzmoITgjhiSMB3QV8CYRLKa1CiKHAfCnl5UKIr53PNwghDEA+EAI8AiCl/IvzWF8D852Hni+lvNzZ/mjT7U5HJaD2SUpJQWU9e3Iq2J5VxrZj5ezMLqe2wdbs9sHeboxMCCG1VzgjE0MwGdt2gbdDZYd4eN3D3NvvXsbGjG3RPhabnfXpRazYkcs3ewuoszR/LmcSH+zF8IRgBsYEMCg2kE7+Hud0HEU5HVdLQC36yCiE0OMYZusK/BM4ApRLKU8MxmcDkc7nkUAWgDM5VeAYposENjY5bNN9sn7VPuQ0cdwO3A4QHR3dktAVjUkp2ZhRyk+Hi9iTU8ne3AqKq0/t3ZwQ6OVGSnwgQ+ODSIkPous5DqWdrcLaQkI9Q0kMSOTjKz/GqGt5YYFRr+PSpDAuTQqj3uroJVlsdmx2icUmsdrtWG0Sm11itTu+1jZY2XCkhG/3FZBRXANARnENGcU1LN1wDIBOfiYGxgYyOjGEy3qEqWIHpcNpUQKSUtqAfkIIf+BTIKlNozp9HIuAReDoAWkRg9Jy246X8devDrAxo7TZ94WAxFAfBsT40z86gIExAcQHe12QhNPUjsId3PL1LdzW+zZu73P7WSWfX3M36AnzbVkvbXS3UB6d2J3DhdV8u6+AHw4UsiO7nAar43pXboWZ3J25rNyZi1EvGJEQwsTeEYxTyUjpIM5q0FxKWS6E+AEYCvgLIQzOXlAUkOPcLAfoDGQ7h+D8cBQjnGg/oek+p2tX2qH0gir+9vVBvtlX0NimE9AlxJtekX707ORLz05+9Iz0xdek7R9Sm93Gkz8/icVu4a3db5Eam0q8f/wFjaFrqDddQ725a3QX6q029uRUsvVYKWmZZWzOLHX2qCTfHyjk+wOFGPWCUYmhTB0QyaVJoW0+LKkobaUlRQghgMWZfDyAb4AXgJuA5U2KEHZJKV8XQtwD9G5ShDBVSjldCNET+IBfihC+AxIAgaMIYSyOxLMFuF5Kufe34lLXgFzP4cJqXl97mM+252B3/li56XXcODSGu0d3IcjbNSu+Tlz3mZY4jRu636B1OCex2OxszChh1e48vtqTf0qxg4/JwKTeEVzdP5JBsYHodRe296i0L652DaglCSWFw2cAACAASURBVKgPsARHibQO+FhK+bQQIh5HGXYgsB2YKaWsd5Ztvwf0B0qBGVLKDOexHgNuAazAA1LK1c72icDLzu/xtpTyjPPcqwTkOvbmVvDPHw6zek8+J36cdAKuGRDFA+MSiXTBi+k/5/zM91nf89iQxxBCUG+rx03ndsGH/86G1WZnY0YpK3fmsmp33in3Q/l5GBmREMyoxBBGJYYQ6mvSKFLFVbW7BOSqVALSXlpmKa+vPcL3Bwob24SACb3C+f1liSSEueYy1SsOr+Dx/z0OwNPDnmZKwhSNIzp7ZouN7/YX8un2HNYeLMRqP/X3OD7YUaouhOP/BRw90lAfE+F+JkJ93QnzMdE50JPekX54uKmhvI7O1RKQum1bOSs2u+SbvfksWp/B9uPlje16nWByv07cPboLXUNdL/FYbBbya/Lp7NuZkVEjCfYIpsZSg0HXPn8FTEY9k/pEMKlPBKU1DazZX8C6Q0WsTy+mos4xTHeiuq4lDDpB9whfBsYE0D/an5T4IMJUD0ppY6oHpLRIXYON/2zN4q31RzleWtvY7qbXMS05irtGdaFzoGsuTb1412Le3fsuwR7BfDb5M4QQbC/cTrApmM6+nc98gHbEarOzM7uCHw8VcSCvEruUSAknfsvrGmwUVJkprKyn+jemNDLoBDNTYrh/bAIBXm4XJnilzakekNLu7Mut5J4PtnG0ySdqPw8jN6bEMGtYDKE+rvVJucZSww9ZP3BF/BUACCGobKiksqGS9PJ0EgMS6R/aX+Mo24ZBr2NgjKOk/Uyq660UVJpJL6hi2/Fyth4rY3dOBQ1WO1a75N2fM/l0ew5zxyZwY0oMbga1fqXSulQCUk5LSslHW7KY//le6p33pnQO9OC24fH8LjkKTzfX+/HZkLuBP637E+X15XTy6sSAsAGkxqayvXA7E+ImEOUdpXWILsPb3YB3iDddQrxJ7RUBOGYb33G8nJfXpLMho4SKOgvPfLGP9zZk8uD4bozvEabKvpVWo4bglGbV1Ft5/LM9fLrdcUuWTsAfxnfjzlFdXK7U12K3UN1QTYApgIKaAib+dyIN9gamJU5j3tB5WofXLkkpWbO/kL+s2n/StSQfk4EJvcKZ3C+SlPggl/tZUH6bqw3BqQSknOJwYRV3LtvG4cJqAEJ83Hntuv6kxAdpHNmpai21PPDDAwR5BPGXEY7pA5fuXUq4VziXxVyGTqhho/Nhsdl5f+MxXv4unfJf3YMU4uPO+B5hpMQHMSQ+0OWGYpVTqQTUSlQCahuHCqqYsWgjpc7ZqC/pGsTL1/Z32WUD/rTuT6w+uhqB4LPJn13wWQwuFifKvlfsyGHtwSIabKcujxEf7MWQ+ECiA73wMOrwcNNjMjoeBp1AJwRCgE44lqOICvAkKsADnepFXTCuloBcbxBf0cyRomquX7ypMfncd2lXHrgs0aWHWe7tdy9b8reQGJBIhHeE1uF0WE3LvitqLXy1N4+VO/PYnFnaOHfdiclUz4anm56EMB+6hXnTLdyXSb0jCPdTPamLheoBKQBkFtdw7aINFFTWA/DIhCTuHNVF46ial1+Tz085PzEtcRoAWZVZhHmF4aZX5cIXWr3Vxs6sCjZmlLDpaAlbj5W1aPHA03HT65gxuDN3je5ChJ/rzaDR3qkekOJyskpruX7xxsbk8+C4RJdNPtlV2dz69a3k1uRitVuZkTSjw93L0564G/QMjgtkcFwgkIDdLjFbbZgtduosNuoabJgtNuxSYpc470uS1FvsZBTXcKigigP5VRzMr6KizkKDzc7SDcf4aHMW1w5yJCK1LlLHpRLQRS63vI7rFm8kt8IMOIbd5o5N0Diq0ysxl1BtcRRHZFZmahuMcgqdTuDpZsCzBZ3RYV2DG59LKdl2vJxXvktn3SHHNab3Nh7j31uymDG4M3eP7qqG5jogNQR3Eauut3LN6z9zsKAKgDtGxfNIapJLTsgppWyM60j5EX7I+oFbe93qkrEq52fb8TJeWZPOj4eKGtvcDDpuGBLNXaO7qGq78+BqQ3AqAV2kbHbJHe+lsWa/YyLRm4bGMP+qni75B91it/Dg2gdJjU1lUvwkrcNRLpDtx8v4xxpHj+gEk1HHrKGx3D4ynmAXXd7DlakE1EpUAjo/L3x1gIVrjwAwplsIb900yGWr3eb/PJ/l6csBeGn0S4yLGadxRMqFlJZZykvfHuLnIyWNbR5GPbOGxjBHJaKz4moJSN2ldxH6dHt2Y/LpGurNK9f1d9nkAzApfhLeRm96BvXkkk6XaB2OcoElxwbywZwUPpyTwuDYQADqLDbeXJfBiBd+4C+r9lNcXa9xlMq5UD2gi8z242Vcu2gjDVY7/p5GPrv7EmKDvbQOq1k1lhq8jI7YDpUdIsgURJCH683GoFw4Uko2HCnhH2sOsSWzrLHd3aBjZGII43uEMbZ7GIFqBu9muVoPSCWgi0heRR1X/d//KKqqx6ATLL11MMO6BJ95Rw3sKtrFXWvu4omUJ0iNS9U6HMXFnC4RgWPewuSYQIYnBBPs7Y6/pxF/DyN+nkZ83I24G3W46XWNXw36i2cgSCWgVqIS0NmpqLNw7ZsbOJDvqHh79upezEyJ0Tiq5tXb6rny0yvJq8nDIAx8MfULIr0jtQ5LcUFSSjZklPDpthzW7C+g7Ffz1bVEgKeRpHBfkiJ86B7hS48IXxLDfDrk8hOuloDUfUAXAbPFxu1L0xqTz01DY1w2+QC46915cuiT/Gndn7in3z0q+SinJYRgWJdghnUJxmqzs/VYGd/uK+CbfQUnLZz4W8pqLWzIKGFDxi9FDkFebsxMieHGoTGqyKENqR5QB2ezS+77cBurducDkNoznH/eMMBliw6K64oJ9ghufB5kCnLJ0nDF9dU12Civa6C81kJ5rYWKugaqzFYabHYarHbqrXbqLXayymo5kF/JoYLqxnntTnAz6JjSL5JbR8SRGOZ6S82fLVfrAakE1IFJKZn/+V6WbDgGwODYQJbeOthlFxRbeWQlz2x8hqcveZrUWHXdR7mwrDbH9EA7jpezbNMxdmVXnPT+kLhArujbidSe4S47O/yZqATUSlQCOrPX1x7mr18dBCAxzJv/3DEMP0+jxlE1r8xcxuXLL6fOWkeAewBfTv0SH7f2/4lTaZ+klGzJLONfP2Xwzb4Cmv6Z1AlIiQ9iUp8IJvaKIKAdVdypBNRKVAL6bR+nZfGnT3YBEOFnYvldw1x+Usefcn7i0fWP8teRf2Vop6Fah6MogGOm+GUbj/Hl7jzynHMmnuCm1zG+ZxgzBkUzrEuQy69t1O4SkBCiM7AUCAMksEhK+YoQIhD4NxALZALTpZRlwjFg/wowEagFZksptzmPdRPwuPPQz0oplzjbBwLvAh7AKuB+eYbAVAI6vS935XHfh9uwS/A1GfjkrmEuO35tsVvIrsomzi8OOPneH0VxJXa7ZHtWGV/symPV7rzG2eNPiArw4NrkzkxLjnLZpSTaYwKKACKklNuEED7AVuBqYDZQKqV8XgjxCBAgpXxYCDERuA9HAhoCvCKlHOJMWGlAMo5EthUY6Exam4G5wCYcCehVKeXq34pLJaDm/XCgkDlL07DaJR5GPctuG8zAmECtwzqt5zY9x2eHP+PZS55lfOx4rcNRlBax2yWbjpbycVoWq3bnUd+keEEnYHS3UKYnd2Zs91CMLnSfUbtLQKfsIMQK4P+cj9FSyjxnklorpewmhHjT+fxD5/YHgdEnHlLKO5ztbwJrnY8fpJRJzvbrmm53OioBnWrDkRJmv7OZeqsdN72Ot2cPYniCa95oCo7ZDaZ9Pg2JpEdQDz6Y+AF6nWsWSCjK6VTUWlixM4cPN2exP6/ypPeCvd25ZmAkE3pF0DvST/PqU1dLQGd1H5AQIhboj6OnEialzHO+lY9jiA4gEshqslu2s+232rObaW/u+98O3A4QHR19NqF3eNuPl3Hbki3UW+3odYJ/3jDApZMPQGJAIv8c+0/+uuWvvDz6ZZV8lHbJz9PIrKGx3JgSw56cSj7acpzPd+RSVW+luLqeN3/M4M0fM/D3NHJJ12BGJYQwrGsQIT7uuOl1F/VtBi1OQEIIb2A58ICUsrLpP5qUUgoh2ryaQUq5CFgEjh5QW3+/9uJgfhWz39lCTYMNIeCl6X0Z1yPszDtqpLiumFJzKYkBiYyIGsHQTkMx6NQ90Ur7JoSgd5QfvaN68/ikHqzance/t2SxObMUgPJaC1/uyuPLXXmN++h1Ak83PV5uBvw8jPSK9GNAjD8DYwJICPXRvMfU1lr0Wy+EMOJIPu9LKf/rbC4QQkQ0GYIrdLbnAE3XSI5ytuXgGIZr2r7W2R7VzPZKC+SW13HT25upqHNMQbLg6t5M7ue6MwfYpZ1H1z/KzqKdLBi+gHEx41TyUTocDzc91wyM4pqBUeSW17E+vYh1h4r56XBx4+8qOG4UrzJbqTJbya80c7CgiuXbHANC3u4GBsQEMLFXOBN6RbjsLRTnoyVFCAJYgqPg4IEm7X8DSpoUIQRKKf8khJgE3MsvRQivSikHO4sQtgIDnIfYhqMIobSZIoTXpJSrfisudQ0Iymsb+N0bG0gvdCxR/XBqEneN7qJxVL9tc95mbv3mVgCujL+S50Y8p3FEinLh2OySndnl7Moqp6bBRm2DlZp6x9e8CjM7ssqpMltP2c9Nr2N0txCu7h/JpUmh53wzuatdA2pJAhoOrAd2AydKPf6MI1l8DEQDx3CUYZc6E9b/Aak4yrBvllKmOY91i3NfgAVSynec7cn8Uoa9GrhPlWH/NrPFxo3/2tQ4E/DsYbHMu7JHuxhP/innJxbvWszCyxbiafTUOhxFcRl2u+RIUTXbjpex7Vg53x8spKjq5HJvH3cDc8cmMGdk/Fkfv90lIFd1MScgm11y9/tb+XpvAQCTekfw2nX9XfomuDJzGRX1FcT6xQKOO83bQ7JUFC3Z7I5lJ1bsyOGrPflU1Tt6Ry9c05trB519IZarJSA1+N7OnJjf7UTyGRIXyIvT+7p08rFLO4//73HS8tN4cuiTTIqfpJKPojTD3tCANTcXa2kZtvIyjJ06MTwpiUu6BDJ3ywcUZhWwbOwtpPaK0DrUVqESUDvzr5+O8t5Gx+SiSeE+LJqV7LKTi56wvXA767LXAfDd8e+YGDdRJSClQ7IUFFJ/OB1bWTm2sjK8R4/CrXNnLDk5FPz1b9hra7HX1WKvrUWa65FmM/b6eiKeeQafS8dQv38/mdfOaDxe4OzZmB5JQuh01H73HZ41NTy/4EncPTpGQYJKQO3I2oOFPLdqP+CY3+3dmwfj58I/iBabBYPOwMCwgSy8bCGv73id+cPmq+SjuDxpsWAtLMQQEeH445+WRtWa77BVVWKvrMJWWYmtqhJbeTm2snISfvgevb8/Vd98Q8GCBY3HMQQH4da5M/b6eqq+/vq0389e4ygk0geePGuJrazJsuNJSci6OqT11CKF9koloHbiSFE19324HbsEk1HH4lnJhPuZtA7rtA6WHuTRnx5lds/ZXNXlKoZHDueSTpeo5KNowl5bi62iwtEDqa3FXluHva4WWVuLtNnxu/IKAApffImKlSuxFhaC3U7C+nUYQkJoyMyk9N13T3t8W3k5en9/9AEBJ7VbnQlE5+2NW5cu6Dw80Hl6ovPwQJhM6EzuCHcTbp0dd64YQkPp9MLz6AMC0AcEYgz/5X6+2PeXtfK/ivZUAmoHKmot3LYkrbE888Xf9aNXpJ/GUZ2exW7hvu/vI68mj79s+guDwwcT7hWuko9y3qTdjq2kBGtRkeNRXIw+MBCfMWMAyHviScwHD2KrKEcg6PL1VwAUvvQPypY1/wdc7+/fmIDs9Was+fmN71ny8jCEhDh6Qh4e6H180Pn6oPf1Q+fjjcE/AH1AAMLDMfmoV8oQYpa950wgAeh9fQEwhobS5csvznh+Ond3/CZPPvd/oHZGJSAXZ7XZuffDbRwtrgFg7tgEJvVxvQuQUkrW56wnJSIFN70bj6c8ztzv53JD9xsI8gjSOjylnZBSYisro+HoURACzwGO2wZzH36Y2rStWAoLwWI5aR+vkSMaE1D9oUOYdzmWIcFgaKy21HmdfoZ1W3k59ro6dB4eeA4YgL2iEkNEOMZOnTBGOH7XvIYNI2n7tjPGbwgOxhDs2lNguRKVgFzcglX7WZ9eDMCEXuE8MDZB44hOlVOdw/3f38/BsoM8kfIE07tNZ2TUSL6c+iWR3q47K4OiHWmx0JCVRUNGBoaICDx69sRuNpM+ajT2CsdKpJ6DBxOzdAkA1qIiLDnNT5BiLSpufG7q2wedlxd6f390vj5gt4Nej8/YSzFGdkLn6eUYAvP0ROfpGA7T+/khTI7hbN/UVHxTT12NV/Xe24ZKQC7s/U3HeOd/mQB0j/B1uXLrE58uQz1DqWqoAuCTQ5/wu8TfIYRQyeciIO12sNkQRiP22lpqNm50VICVl+EWG4vP2LEAZM+9n4asLOyVldiqqrBXVXFimdGAmTPx6NkTncmEzs2t8W73hqNHG7+P59Ch6AODMEaEYwgLxxAagiE4xPn1lx5H+J//THM8+vTBo0+ftvlHUM6ZSkAuan16EU+u2AtAkJcbi2cNxNPNdf67lu1bxq6iXfxlxF8w6ozc2/9e8mvymZE0Q31a7GDs9fXUbd9OfUYG1txcGnJysOTmYsnNxVZSSsTTT+E/bRq2ykqy776ncT/fiRMbE1D94cM0ZGQ0e/yGjCONzwNnzwadDrfYGNzj4hrbg+fMaZuTUzTlOn/RlEbpBVXc/f42bHaJm0HH4puSiQpwnSlrlh9azgtbXgAg1DOUhwY9xJVdrtQ4KqU1SKsVS34B5n17cY+Px71rVyy5uRyfffNp97GVlwOOi/kntVf+sjaO5+BBuMXEoPf1Qefji97XB2NkFO5d4nFrkmiCbr2llc9IcWUqAbmYkup6blmypUnFW18GRAecYa8L67KYy1i2fxll5jKu6HKF1uEo58BSWEj9/v2Y9x/AZ+yluCckULd7D5kzZoDNBkDQHXcQ+vsHcIuNRR8UhK2kBIxGjBERjgv0nTphCAnBo18/AHQmE7H/+dhR/eXvf9KF/4j587U4TcXFqQTkQswWG7e/t5Ws0joA/jAukSv7dtI4KgeLzcKnhz9lWuI0/Nz9eHPcm5itZqJ91cKArshWUQFCoPf1xV5TQ+nSpViLimg4noX5wAFsxb9cuDeEhOCekIAhNKQx+QDUbd8OOC7Ad174OobQUAwhIQj96Wfe8Ojdu+1OSulwVAJyEVJKHl6+i63HHDeuTe0fyb2XdtU4KocGWwMP/PAA63PWc7TiKH8a9CdCPUO1DuuiJy0W6jMycIuJQWcyUZuWRv6zC7Dk5GCvqiL0jw8RdOutoNdT9Mqrpz2OrcyxYJohJISgO+/A2KkTbrGxJyUTdQFfaQsqAbmIf6xJZ8WOXAAGxQbwl2t6u8zF/PL6cjIrMwHYVbyLels9JoPrzsLQEUmLhfrDh6nbswfz3r2Y9+6j/uBBZEMDMcvewzM5GWEwUH/gQOM+1sIiwDE0pvPxAcAYHo57UhKm7t0x9eiOKSmp8dqN0OkIfeCBU7+5orQRlYBcwH+3ZfPqd+kAxAR58uaNybgbtJ9g1C7t6ISOUM9Q3rn8HV7d/iqPDXlMJZ82Ju12GjIz0fv5YQgKwnzoEJnTfodsaGh2e/O+fXgmJ2OMjsZr5AjcoqIwRkbiOXBg4zYJ//sJnZvbhToFRWkRtR6QxjZllDDzX5uw2CR+HkY+vXsY8SHeWoeF1W7l4XUP09W/K3f2vdNlemMdWd3u3RT942Xqdu/GXlVF2J8fJXDWLOxmMweTB4FzEkrh4eHowfTsialHD7wGD8IYqe65Us5MrQekNMooquaOZVux2CRGveDNGwe6RPIB+NuWv/HNsW/45tg3BHkEMb3bdK1D6jDsDQ3Ubd1KzebN1G7eQtgfH8KjXz+EXk/Nzz83ble30zGljM5kIuT+uRhDQzH17IlbXNxvFgIoSnuhEpBGSmsauOXdLZTXOua1en5qH1LiXWfOtOuSrmPN8TUEmYJIjTt1ahLl7Fhycqhev57qH9dRs2kTsra28b2ajZvw6NcP98RETD164J6UhEefPngm/zKEpm7EVDoilYA00GC1c+d7W8kscfwRuu/SrlwzMErjqByzWK/PXs+l0ZcS6xfLu6nv4uvmi6+br9ahtRvWoiLHXf+ZmRhCQ/EZOxZ7TQ2HUyecMokmONZ40fs7ZjYXBgNx/11+oUNWFM2oBHSBSSmZ9/keNmc6Sl+v7NuJB8clahwV1NvqeWjtQ6zNXssjgx/hhu430Nmns9ZhuTQpJQ1HM9F5mDBGRNBw7BhHLv+lt+g9ahQ+Y8ei8/LCc8AAajdtQh8cjPeIEXiPHIFnSgqGANe6yVhRLiSVgC6w9zYe48PNWQD07ezP36b1cYkL/AU1Bews2gnAqqOrmN5tOkad6662qhVLQSE1P//seGzYgK24mKC77iT0/vsxRkej9/dvnJrGkpvbuF/IA/cj3Nwwde+O0Om0Cl9RXIpKQBfQz0eKeWrlPgBCfdxZdONATEZtLybb7Db0Oj3RvtEsGr+If+74J8+PeF4ln18pfPElqn74nobDR055r26rY50YIQTh8+eh8/HBPS4OQ3h44zae/ftfsFgVpb1QCegCySqt5Z4mE4wumpVMmK+299NUNlRyz5p7mJowlSkJU0gKTOK1S1/TNCatSSkx79pF9Y/rkFYroQ/+HgDz3j0nJR+dtzeeKUPwShmK5+BBje3NrSWjKErzzpiAhBBvA1cAhVLKXs62QODfQCyQCUyXUpYJx1jSK8BEoBaYLaXc5tznJuBx52GflVIucbYPBN4FPIBVwP2yvd6cdBrV9VZuW5JGWWPFW2/6dfY/w15tS0rJgz88yI6iHews2kkn704MiRiiaUxak3Y7GVdd1ZhodN7ehMy9D2Ew4DViJPb6BryGDcVr2DA8evdGGNTnN0U5Hy0ZjH4X+PXHukeA76SUCcB3ztcAE4AE5+N2YCE0Jqx5wBBgMDBPCHHi6utCYE6T/TrUR0iLzc4DH23nYIFjwbY5I+KYOkD7ijchBPf2vxcPgweXxVzGgNABWod0QUkpqduzl4IX/kreE08Cjqlo3BN+WXHWGBmJtcgxnU3QzbOJfX8ZIffcg2f//ir5KEorOONvkZRynRAi9lfNk4HRzudLgLXAw872pc4ezEYhhL8QIsK57bdSylIAIcS3QKoQYi3gK6Xc6GxfClwNrD6fk3IV9VYb97y/nTX7CwEYlRjCIxO6axpTfk0+B0sPMqrzKPqF9mPZxGXE+8Vj0F0cf1DrM45S+eWXVH75JQ2ZmY5Go5HQPz6E3teXgOuuw3NgMj7jxmEMUxOuKkpbOte/OmFSyjzn83wgzPk8Eshqsl22s+232rObaW+WEOJ2HD0roqNdexkAs8XGHe9t5cdDjk/Q/Tr789r1/dFruKR2TnUOt359KwU1Bbw0+iXGRI8hMUD7EvC2YjebEXo9wmik+n//I++JJ7Dm5p2ynUffPliLS9D7+uI1eDBegwdrEK2iXHzO+2OvlFIKIS7INRsp5SJgETjmgrsQ3/Nc1DY4rvn8fKQEcMxu/fbsQfiYtK0sy6nKoai2CKu0sqVgC2Oix2gaT1uo3baN8v/+1zFbdHo60W8txislBUNQ0EnJx71Hd/wmXYHvxAkYIyI0jFhRLl7nmoAKhBARUso85xBbobM9B2h692KUsy2HX4bsTrSvdbZHNbN9u1Vdb+WWd7Y03mg6rEsQb92UjKebdkNcFrsFo87I4IjBvHLpK6Tlp3H/gPs1i+d8SSmx5uZSu2MHdTt2UrdjB53ffANDYCCW7GwqPvllNoG6HTvxSknBvWtXfFJTMfXsgc/YsbjHx2t4BoqiwLknoM+Bm4DnnV9XNGm/VwjxEY6CgwpnkvoaeK5J4cF44FEpZakQolIIkQJsAmYB7bYO2GyxcfM7m9mS6VhUbmRiiOb3+hytOMrda+5m3rB5pESkMDxyOMMjh2sWz7mSUmLes5fKL1ZS+fU3WPPzT3q/bsdOfC4dg6lXL3Te3o6Zonv2bCyRFgYDUS//Q4vQFUU5jZaUYX+Io/cSLITIxlHN9jzwsRDiVuAYcGKq5FU4SrAP4yjDvhnAmWieAbY4t3v6REECcDe/lGGvpp0WIFhtdu79YHtj8hmbFMo/bxigafIxW83c/u3t5Nfkc9939/Hp5E+J8tG+Au9sSKsVYTBQt30Hx66//pT3hdGIqUcPcF5bc4uLI3HzJjXbgKK0A2o9oFYgpeTPn+5unGJnWJcg3rl5kGaLykkpsUorRp2RrzO/5v/bO+/wuIq7339mV7srrbosSy6yJBcwlgDhgrEdwMYE06spISQvkIbh0lIIAd6QGyBvCBAuIXDfkORi4BKaY0gIhthADLbBFOPYuFsuMpaL5KJed7Xz/vEbaVerVbXkXdvzeZ559uw5M+d8z8yc+Z0pZ+buJXczp2gOc4rmREVPbwg0NFC7dCl1y5dT//Fyki84n6w77kAHAmyZeTb+sjK8kyeTNGMGCacUEV9YaBdas1h6iF0P6Cjk/7xX3GZ8Coam8My3J0bF+GitWbZrGU+teopZebP47knf5dz8czku7ThGpcVun4evTLoQXdlZtFRXs+v2YP9U3ccfwx13oBwOhj3yG9y5ubhCprixWCxHLrad4hB58ZMdbctpj8hI4LnvHP7Rbq21WI3m8S8eZ/2B9cxdN5fa5lqAmDQ+LVVVVMybx44bbmTLjBkcfPZZAFzZ2bhHj0a53XinTiFl1qy2+0ucPNkaH4vlKMLWgA6BN/5dyv1/XwtARqKb52+cTFby4ZvfbWvlVl7b9BrLdi1j3sXz8Lq83HLKLdz/0f1884Rv4lCH4f0iuYpQ4AAAHMBJREFUEICGg1C3D2rL5behAlp8MPWWoL/SFej3H6B+SyWVq6uo2dqMbgkerp73PFnOZ1F5k8l56ve4hg7FER8PG96Cv98KrgRwe8Hlle2EdPAOAm+m/CZngyd54O/XYrH0G9YA9YGqeh/3v7mWv6+S6fYTXE7m3nDqYVlOu7KxklRPKkopSmtKeWnjSwAs3bWUc/PP5ezcs5k8ZDKpntT+uWCLH5QCh2lSbKqFv90M1bvF1ZbRzpK04nS3N0CNVex+aTXVO7ztvcW3kJLbQGpeA9T5oLkez8iRQQ+7voBVL3avc/rdcNa9wf9zL4S9a0S3I06cMw4cLvAkgScF4lPh7Pth8NhgOF+DGDiLxTLgWAPUSxZvKudn87+krLoJgDSvi6eunUDRAE8u6g/4eWXjKzy96mke+NoDnJN3DlOHTSXFnULBoAKS3fL271COvhsffzPsWQ1fLZeCf98mOLAFvrsQhpvloV0JsHFBZKMTgm5upmbBP6h6ZyHDH3kER2ImySflUL3jIMqpSC5MJ3XiUBJHZ6CcTnA4QDkg+8T2J4qLh5Th0FwnxqGlKfIFvWHLmTdVQ1NV9/d85k+C2y0+eDgPkofA4BMgPQ9SR0Barrj0fKl5xcD6TRbL0YA1QD2kqt7Hw//c0DbYAGSo9a9nn3RYmt3qfHU88+Uz1PpqeeTzRzgz50w8Tg/vXfUeCXF9fGNv8cHOz2DbYvjqEyhdAf6Gjv72bQoaIIcT8qaJsUgZLoV1UjYkZkLiYEjKouqDLyh74v/SMu+nAFQvXETa5ZeR9Kt/MWTi66RccAHO1B4ayRl3i2sl0CLGqLES6vZD/UGoPwDDwtbbOflq0RlogYDfuBYxYE010FgtRiohIxjmwFY5XrlDXCTiU2HIyXDDW8F99QdFT0oOxNkReRZLT7EGqBu2lNcw96MSXl+5iwafvPUneeK4/+ICrpqYM6CrmZZUlfBh6YdcX3g9qZ5Ubp9wO3PXzuWeyffgcXoA+m58QJrS1syLfCxluNRGBh/fvokK2grfQF0d9Sv/TcNnK6lfuYCsu35CwqhxxOVU0HJQvodyJCcTqJGZwB0eD+nXXtt3vSAGMD5FXFoX8wFOu6335/Ykw4x7oGyd1PwqvwIzkKONxipxoaydD2//BFCQPBSSskSfx7j4FHAnwsjpMGp6MNzB7dKnlZRla1WWYxJrgCKgtWZJ8X6eXba9bTLRVr42ZhCPXFnE8LSB7SdYWLKQuz68C41mZOpIzsw5kyvGXMEloy9pMz49osUPpZ9B8bvShHX+w8Fj+WcEDVBWAeRONW4KpI3ocCqtNU3FxdQtXUrt0mXUf/EF+HxtxxtWrCChsBDvlCmkXHABSTOmkzxrlgwmOBJIHQ4zfhb8r7UMqKjaCRWmVnRwGyQPax+u8qvWAFCzW1wknO72Buif98DmdyA+TYx85vEwaDSkj5TmvvR8SIjuulEWy0BiDVAYFXXN/GTeat7fWN5u/8wTsrjxa/mcPiZzwGo96w+sx+P0MDptNFOGTiEhLoF6fz2f7/2cM3POxOlw4qQH3xfV7oPiRVC8ELZ+EOwLiYuHr/8i2Mk+9nyIewZGnw1Jgzs9nW5uRrndtFRWsv3Sy6RgDsNz3BhUgpxXORwMf/y3vb392EMp8GaIG1rUub+ib4jxqNopxqj+QLCJr7W5r7m24+CGfRvlt7ESdn4qLpz4NLhhAQwxfWMtPlj5gvRNpeaIi0/pn/u1WA4z1gCFsKLkILe//G92VzUC4HU7uWpiDtdPyx/QEW4BHeA/l/0n/9j2D2aMmMHvZ/6eVE8qv5z2S8akjWFM+pjuT1K2Dja9A5sXQunnQIQZLrLGQc0eyDDfBSVlSeEZgZbKSqreWkDV66+TcMopDLn/58SlpxN/8kk0rv4S14gRJJ1xBomnn4534oSe9+kcjWQXiuuOQKD9/4seh/IN0se2bxPs3yQ1rlAaK9vXgmr2woIftfcTnyr9T8nZ0h+XlCW1p0nfCfqpKjVNfgnSHOhOBHeS/DrdtgnQEhWsAQICAc0flmzlt4s20xKQgvu8wiE8PPsk0rwD16nsD/iJc8ThUI62b3aW7VpGWV0Z2YnZnDeyk8Vhm+ulIz601vK3W2DPqvb+EtJhzNdhzDkwemaXtRwA7fOhXC6038+Wc88jUCU1p+Zdu8i6+6c4PB6G3HsvjpQU3Pn5A9r/dVQSPj/d6JniQmmolKa+ihIxGBUlYlRaqem4nlFbv1T5uuC+wePaG6B1f4NF90XW5XTLAJLETDj5Gpj6v4LH6g5I35gdXGEZAI55A7S/tokfv7a6ra/H7XRw34Xj+I+peQNWwDa3NDO/eD5z187lhfNfYEjiEG4bfxu+gI9bT7mV7MTsjoFq9koNZ9PbsO1DGH8dXBQyu3PuFDFAmWNh7Hlw/HmQM1m+femCpi1bqHnvPWr+tZi4jAxG/OG/UXFxeCdNovb993ENG0bq5ZejfT7weEgo6qIpynLoJKSJ66zJb9gE+OE6qNolTX5VpeZ3F9SVy8fAtWUdXzY6G74O0NIM1bvEhRvEBT+UYfeDxohra/obLtvJQ+RjYNcR0s9niSmO6clIF28q5655q9lf2wxA3iAvT39zAicOH9jmpHUH1vGNt6Tp66JRF/HrM37d0VOLH3b/G7Z9IB3Vu75ofzz7RLj5o+D/g9tBB6QTuwu01jRtLqZm4UKqFy6keevWtmPK7eb4T5bj8Hqp/+ILtM+Hd/JkO7P0kYbWMuDEHfLRb+VOGUDhb5Tac5urNUPaD8gsFidfAydfFQz31Kmwf3P31/zuezBClr6gsRrmfw/iPNLvGOeR0YvKASj5VQ7pWwsd9OFvhoBPmgUtA4KdjDQGaPS18PA7G3nu45K2fRcXDeO/Lj9xQOZxC+gAi0oWUd1czdVjr6ZwUCEzR8xkc8Vmpo+Y3t5zTRm8dSeULJNO7HASs2TwwHGz2u/PGNnRr0Fr3VabO/DMM+x74ncd/HiOG0PSWTPRzc3g9eKdOLHX92mJEZRqb3xARjVGGNnYLdPvlhklyjdIc2BVKfjqOvrzhnxP1VwnA2C6w5vZ3gCVLIUXZ8sHwFkF8jFwVoH0r2UeB87orihs6X+OOQO0cW81d7y8ik1l8m1KotvJA5eeyBUThg9Yk9sDyx9gfvF8El2JzMqbRVp8Gr+Y9guSmxpwlSyT5pPU4eI5IV1qPb764Akyj4cTLoSxF8oHoT2okWi/n4bVq6lZ9C41777LiD//Gc+okXhPO63NT3xhIcnnnkvKrHNw5+f3701bjg5OulJcK21D00vF1ZXLB8HJYZPEDi0Cf5PUuPxN8hEwWmrpWsv/xLBmwn0bxU9FibhNbwePOVxikLILofByaWa2HPEcUwbouY+281/vbKTZL6ORxuem8cQ1p5A3qH+r/LXNtbyx5Q1mHzcbr8vLOXnnML94Ph6Hm63rXmXi/q/I2Lo42Gl8wWMw+fuyHeeGwivky/1R0+XjxVbj1AVaa3w7duAaNgzldlPx6quUPfhQ2/Gad9/Fc9MPSCgqIvvee0maeRbunCNrcTpLDNBuaPrJkf2kDIWblnR/rvBRgblTpMZVvkHcwa1isECa5srWiEvNaW+AXv0W7PlSRgPGpwY//vUkSxOgK0F+i64VbSBN3BvfklpVnAdcieKvdbJb76COtUhLv3NMGaB9tU00+wM4FNw28zhumzmGOGf/9m9UNFZw4esXUuOrwYGD6zKKmLbtM37BIC7Ysh7vxp92DLTj46ABArjs6S6vobXGv3s3jRs30rhhI40bNtC4fj3+PXvIfe45EqecRuLUqeJZKbwTJ+LOleYX5XCQ8R/f7q/btVj6TnhNfvjE4JRPAL5GGZpeth7K1orbu1YMUCj7t3Q+dVIoo2cGDZCvDuZd37X/+DS51k1LgpPxVu6UpsKEDGmtSEgXYxyf1u2AH0tHjqkYu/Prx1NyoJ4bp+UzKT+j+wA9YP7m+SzasYgTM0/ktvG3keZJIy0+jRpfDUs3vMJ1a25BAVeGBlJOedBGnwWjzoKczvsEtdb4y8tRTidxmZn4du1i+xWzaamKPNFm3UcfkTjlNNwjRzLsscdInHIacZmZ/XKvFsthxRUvTXmhIwK1DtaKWim4BA6eGPz4N/QjYH+jOGj/IXCLj25prJQh6o6Qj79LP5cprCLhSZURjN4M6aMNnZ1962Kp0blav8HySq3M6ZFWj9bBGolZx1TN65gyQC6ng6e/OaFXYUI78N//6n2Wli7F4/Rwz2n3APDOtrf4tGwF5eVruO2LN1E3vMWNJ95IZnwm0xNHwBrzRpc+0nz3cZZMgRNhihWtNQQCKKeTpuJiyh59lMYNG2jZt5/M229j8C23EDdkCAFf+4fHlZtL/LhxJBQVkTRjBgBKKVIvurCXMWSxxDhKyQtcKKEFfSS0FiMUOoVVfBrcvFyGp/ubpUbkaxDXXCd9W9W724eBjh8Kh9JUJa5yh3yHFcqXr8Lql7u/v4ufhIkhNbMXZ4tBTUgTzQlpMs9hV/MgHkEcUwaoNzy58kk+KP0AgNcveR0qdvDBupf5W/mnZDjc/GzratTBbRQE9rEjMZ7x1bvxHajAtfMzrjo+ZBjrpU/L/Gphw6O11vh27qRx3Toa162jYd06GtdvYOiDD5AyaxYqPp66JUvb/Deulf4i5XSS+YMf4EhMJL5gHJ6xY3EmDfw6RBbLEYtSHadBcsZBdkHvz1V0rbxE1lfIQowNFeLqQ7YbDnbsH2uOMHIwEuGLKu5ZLcPjQ5l4Y+91xyjWAAGf7fmM1zf/la8ObuYvebNRe9fgD+yjuKIYh3Lga/HhWngveXuWkJSWwuiGaurL/kmi1tysFD88qFHKIc1qgbCq/fhvEWhoQFdX40xJoaW2lp1z5tC0cROB2toOWhrXrydl1ixcOTnEn3QS7rw84gsK8E4M1twy59w00FFisVgi4fbKVFa9bcG//BkZbOQL+QbL3yQfAbeOFPQ1tO8DA2miry2T5sCGCmioOqomqD3mDNDuii38a+M8VpWv4qHEAuIrSiiuXMsCt7QTf/X2neT5/Uwfdy5bhp9BbkoujS2NuJKH8K1NNXynqhqH0w2DZObihIxRkDcNPWIq/qpGHElJOIHmHTvY+8CDNG3fhn/3HgZ9//tk/fhHOBITadpc3N74OJ14xowhvrCwbaYBpRQj570WhRiyWCz9jtvbt76d2X/qfy0xRMwYIKXUecDvACfwZ631w90E6RNr1s/jN1tkGetr1y9mYlMT490ukodkc2pjI81KQVw8411Z/K7gXgL19QQ2bMOXeynx4y4hkDScA//4kJbqGlo2V9Gy/wDNO/5I84770E1NDP3Vr0ibfQUqIYG6j4IzFTRu3Nh6n6RedCHa34LnhLEkFBbiGTv2yFmywGKxWPqJmDBASikn8DRwDlAKfK6UelNrvb6/r1WUeAozV71Idl2AlopE9vgzSQ4k8pLfQ6DJwbBf/h6mzKJ++afsnHl2W7jBd9xO5s03o3w+yh99rNPzN5eUABA3eDAJEybgGpKNe+Qo4k8MzpY85P77+/u2LBaL5YgjJgwQMBnYorXeBqCUegW4FOh3A5TSlM6cd1qHccZTiQZqjQN/IBmccTgS21eXA/UyM4FyuXB4vQQaG3GmpuJMS8OVOwJPfj6uvDy8E6SvRilF/kt/6W/5FovFctQQKwZoOLAz5H8pcFonfg8J56CQb2JcLjEiKSk4M9KJS0/HmSyjUNz5+Qx96EEcXi/K68UTMlXNmCVLcHgT7CSdFovFcgjEigHqEUqpHwA/AMjN7ds4eHdeHmP+9T7O1FSU19vp/G9x6emkXXllxGPOJDtbr8VisRwqsfIKvwsInao3x+xrh9b6j1rrSVrrSYMHd724WmcolwvXsGE4EhPtgmoWi8USRWLFAH0OHKeUGqmUcgPfAN6MsiaLxWKxDCAx0QSntfYrpW4FFiLDsJ/VWq/rJpjFYrFYjmBiwgABaK3fBt7u1qPFYrFYjgpipQnOYrFYLMcY1gBZLBaLJSpYA2SxWCyWqGANkMVisViigtJaR1tDn1BK1QCboq0DyAT2R1tEPxAr92F1dCSWtPSEWNEbKzogdrSM1Vond+/t8BAzo+D6wCatdedrWR8mlFIrYkHHoRIr92F1dCSWtPSEWNEbKzogdrQopVZEW0MotgnOYrFYLFHBGiCLxWKxRIUj2QD9MdoCDLGi41CJlfuwOjoSS1p6QqzojRUdEDtaYkUHcAQPQrBYLBbLkc2RXAOyWCwWyxGMNUAWi8ViiQ5a635xyHo+i5FltNcBd5j9GcC7QLH5TTf7rwO+BNYAHwNFIec6D/nGZwvwsy6ueb05bzFwfYiOA0CjcR8hM2x30AE8C1QZf206gP+NrEe01Rzb3VsdZv8/gdUmPv4AOHsSbyH79gNNRssbQP7hjMswfTUmLjpL1yvNdfYCe0K0/NpcWwNXH2K6tsZTNbCns/xl7nm3ibu9Iel6NrDSpGs9sGOAdQxo/go5/iawtovn8mOgzlxrT0ga/t7sbwLKgbzD8GxWmOs1ICsfZ3USdxOBr4zf/SFxdxXynASAkijqOAX4JCQNd/YlDYHlSF5sNFru6yQ//dZcozEsbX4O7ANWGS17+xInZv8HJm1XGZcVIawXWABsNOnwcMixHyHPxZfA+635qUu70Z2HnjpgKDDBbCcDm4EC4JHWyAB+BvzGbE8jWICeD3xqtp0mIkcBbqQAL4hwvQxgm/lNN9vpRscZITpqgB9H0gGcCdwArA/VgRQQdx2KDnMsxfwqYD7wjR7G25nABGAWkGb2/dloO2xxGaLvx8BLJnNFStd7kAd6lNG+1vg5H3lQ8pHCYvshpusE4ArgNaRAiJS/HjH3fCVSqKwGbjJxtxkoNMd/DrwwgDoGPH+Z41eYtOnMAA1F8tEEJH8Vm7QoMPrvDSl8PjkMz+YKYBLdlBHAZ8D3Tbh3THp9CowzrgG4NIo6FgEXmvj4DvBhX9IQMSLX9aDc/P9Gd31Y2mwFnjrUtAnJA5O6Kee9wFlm2w0sBc43/88CvGb7ZuDV7uxGvzXBaa33aK1Xmu0aYAMwHMkkzxtvzwOXGT8fa60rzP5PkFVQASYDW7TW27TWzcAr5hzhnAu8q7U+aM7zLnCe0bHU+GlE3vDSI+nQWi9BIj0QQUfuoegw91ht/MQhidVhxEcn8ebRWq/UWi/SWleafaXIg3fY4tIcqwEuBx4y8RQpXdcAbnOdJcBfzPFPgAytdQngAbYfSroiD+ePkAK8KYKO54FrzD3/VWtdbq4zzMSJBqYgb4h+E6cDpWPA85dSKsnoeChCOKAtfy0y+akGeYnYbTQXAXON1xeQgm9An02g1lyjqzJiNvLy9icT/gWkYM3RWm9AXsoagF3R0oHkpfFIXmpAarR9eb6aMTO6dKNlstEdCEubDLPdH896t2it67XWi812M9KikGP+L9Za14doy4l8liAD0geklMpHEudTINtEHEj1MDtCkO8ibxcgkb8z5Fip2RdOl/6UUguRKnMy8FgfdFwDnKqUelYplX6IOsqRgvyvEcIT4jefYLyF7zsNacI73HH5IFL9rwdcRE7XeNrPqtEaPlSLk/bLrB+KlgxzzUj5KzNC+LONju8BTwCnA98GHh5AHYcjf4WmTbeYvDQJaYIK13w5kkZdae6XZxOYq5RaD0yPoKM17krDwp8WpqMpyjruRJrLv4aUL/ccoo5VSqnf0vty80vEUL4CHK+UGtHJNXqr5edKKRUhfBtKqTTgYqS5LZK2dyLsb0e/T8Vj3srmA3dqratD70FrrZVSOsz/WYjY0/tZymxgCZJRTw090AMdccib4iygDHnIF/dFhNb6XKVUPFIrmIm8cXQgPN7C9i1Fqr6+XtzDIaOUOgUYrbX+oVKqAHlrvy48XTthOFLw96sWpAlkObC3J/kLqTUWIG+DfwJ+BYxB3jofR5pOBlxHf+evsLTJ74H/JKQfsRG4K1SzUuo+pEbY3IXm/uI6pF9sKdIUeFnowU7ScDxiNO+OIR2/AJ5DWlcWAf+PYI2lVzq01ruUUkOQmvXcXuanixGDcjFiFJ9Hypm+0KolGSl3vo3U+jqglIoDXgae1FpvCzv2LeRFZ3p3F+zXGpBSyoUI/4vW+nWzu0wpNdQcH4rUBlr9n4z0bVyqtT5gdu9CErmVHGCXUuo0Y5lXKaUu6cxfmI4Xgf9GCp8DSqm1JvxPQ3UgzUNtOrTWZUiijkAKrcl90dGK1roR+DtwqVJqREj4OZ3FW8i+zUi1/7ooxOVUYJJSqgSparuA281bVryJzzlIoeYPCT8J6f8I1dJC+zetPmlBOlxHAEOUUh/QMV0PtIY3cXIT0szkQJqcPjTHX0X6OgZKx0Dnr9C0WYa8/X7QRf56HUgAng57Nu8ALkL6+Qb82TTXmI/0aTxh7r0sJO4eN35yQnTcBywI0+GJso7rTZyOAObRxzLCFPguxHAsAJxKKSfB5+uBbp71LVrr1oFKdcigiT7Fida69bcG6VecrJRyhoR/ICTcH4FirfUTIftQSn3dxNMlRlfX6P4bhKAQa/lE2P5HCeskNtu5SPvptDD/cUjH2EiCnWmFEa6XgXRqpxu33exLQjLEE+ZcrwK3dqFjGlJLmhZy7qEhOh5EOmv7omNoyD29Ctzak3gL2fcG8qY8OBpxGablWUI6usO03AtUmuuMNvF5Xdg1Sozra7q2xRMyqGFtJ3HyqLnnr5k4KUYGHsQhTbLjzPG7kQJkoHQMaP4K89Omo4v8tZ6Oz+Y8pAY2+HDkJ4LPwRPIy8xfgTmR4g7p/L/U6FgOXBCmowG4JFo6kL6as018XIe8oPVFR6ZJnydbdXSTn+pC04b2Zcxe4N+HECeZxo8rVEuEczyEGG9H2P7xyECI43psN3rqsdsTSTVdI22SrcP4LgAGIW2ExcB7BAu2PyMjp1r9rgg51wXIm/9WzLDETq75HZMYW4Abzb6LjY4G4/Yhb3gddCBVyHrjvxkZbrkCeStaYxKnFik4e6sjG/jcxMdaZMhrXA/j7SdmX5PR1WDiYu7hjMswfRuMjs7S9WpzneoQf6tMnJYiNaQDSLNHX9I1NJ7Wm2tEzF9mfxVS69rTGidIP8capNBoHYY9kDoGLH+FHc+ncwPUqjf0mdhqNG9Daq9NSB/l3AF+Nr9Oz5/NScBBk4atw4xb07AUaY72m/iNho7TgS9MHDYgNdre6khEhjNrkw6t54+Un540962RQS17jd89yHDo1cZt72PaJJr7+dKc73dE/mykdQDGhpD88T1z7D3khaZ1/5vd2Q07FY/FYrFYooKdCcFisVgsUcEaIIvFYrFEBWuALBaLxRIVrAGyWCwWS1SwBshisVgsUcEaIIullyilPo62BovlaMAOw7ZYooBSyqm1bom2DoslmtgakMXSS5RStUp41EyXskYpdY05NkMp9VaI36eUUjeY7RKl1G+UUiuRdW0slmOafp+M1GI5RrgCWZSsCJlO5XOl1JIehDugtZ4woMosliMEWwOyWPrG6cDLWusWLZOLfkjYrOud8OrAyrJYjhysAbJY+hc/7Z+r+LDjdYdRi8US01gDZLH0jaXANWa6+sHI8hOfIROcFiilPEoW7Do7miItlljG9gFZLL1HI0tlTEVmINbAT7XWewGUUq8hM6BvR6bHt1gsEbDDsC2WXqCUGgSs1FrnRVuLxXKkY5vgLJYeopQahixK9li0tVgsRwO2BmSxWCyWqGBrQBaLxWKJCtYAWSwWiyUqWANksVgslqhgDZDFYrFYooI1QBaLxWKJCv8Dt+TbOmaCWIAAAAAASUVORK5CYII=\n",
            "text/plain": [
              "<Figure size 432x288 with 1 Axes>"
            ]
          },
          "metadata": {
            "tags": [],
            "needs_background": "light"
          }
        }
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "d7ZOg2X46pih"
      },
      "source": [
        "On peut donc voir que les hospitalisations sont en baisse , ansi que le nombre de personnes en réanimation et egalement décèdés suites au covid19 au seins des hopitaux en France et le nombre de retour à domicile après une hospitalisation du au covid 19 est en hausse ce qui est plutot bon signe .\n"
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "ZMBQl0-10H7T"
      },
      "source": [
        "# **4.3- Visualisation Cartographique :**"
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "A6wRThNk0Pve"
      },
      "source": [
        "# Représenter sur une Map par région et ensuite par département les indicateurs de cette liste :\n",
        "* le nombre de patients hospitalisés,\n",
        "* le nombre de personnes actuellement en réanimation ou soins intensifs,\n",
        "* le nombre cumulé de personnes retournées à domicile,\n",
        "* le nombre cumulé de personnes décédées."
      ]
    },
    {
      "cell_type": "markdown",
      "metadata": {
        "id": "OzZzETlW0Z7e"
      },
      "source": [
        "( je n'ai pas très bien reussi cette partie...)"
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "HF5ATYIucAA-",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 88
        },
        "outputId": "b96b58d0-b209-4a1d-e09b-ee1d8db037ad"
      },
      "source": [
        "!pip install geojson\n",
        "import folium\n",
        "import json\n",
        "from folium.plugins import FastMarkerCluster"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "stream",
          "text": [
            "Collecting geojson\n",
            "  Downloading https://files.pythonhosted.org/packages/e4/8d/9e28e9af95739e6d2d2f8d4bef0b3432da40b7c3588fbad4298c1be09e48/geojson-2.5.0-py2.py3-none-any.whl\n",
            "Installing collected packages: geojson\n",
            "Successfully installed geojson-2.5.0\n"
          ],
          "name": "stdout"
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "V0oDEG1-fM2u",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 399
        },
        "outputId": "1ae50023-10cc-4962-d4ef-5e5e1cfc5988"
      },
      "source": [
        "data_dep = pd.read_csv('/content/data/sursaud-covid19-hebdomadaire-2020-05-20-19h00.csv',sep=';')\n",
        "data_dep.head()\n",
        "\n",
        "df_mean= data_dep.groupby('dep', as_index=False).sum().sort_values(['Nbre_hospit_Corona'], ascending=False)\n",
        "df_mean"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div>\n",
              "<style scoped>\n",
              "    .dataframe tbody tr th:only-of-type {\n",
              "        vertical-align: middle;\n",
              "    }\n",
              "\n",
              "    .dataframe tbody tr th {\n",
              "        vertical-align: top;\n",
              "    }\n",
              "\n",
              "    .dataframe thead th {\n",
              "        text-align: right;\n",
              "    }\n",
              "</style>\n",
              "<table border=\"1\" class=\"dataframe\">\n",
              "  <thead>\n",
              "    <tr style=\"text-align: right;\">\n",
              "      <th></th>\n",
              "      <th>dep</th>\n",
              "      <th>Nbre_pass_Corona</th>\n",
              "      <th>Nbre_pass_tot</th>\n",
              "      <th>Nbre_hospit_Corona</th>\n",
              "      <th>Nbre_acte_corona</th>\n",
              "      <th>Nbre_acte_tot</th>\n",
              "    </tr>\n",
              "  </thead>\n",
              "  <tbody>\n",
              "    <tr>\n",
              "      <th>75</th>\n",
              "      <td>75</td>\n",
              "      <td>32292.0</td>\n",
              "      <td>157991.0</td>\n",
              "      <td>7679.0</td>\n",
              "      <td>12145.0</td>\n",
              "      <td>103013.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>94</th>\n",
              "      <td>94</td>\n",
              "      <td>14628.0</td>\n",
              "      <td>110686.0</td>\n",
              "      <td>5754.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>95</th>\n",
              "      <td>95</td>\n",
              "      <td>15836.0</td>\n",
              "      <td>92795.0</td>\n",
              "      <td>5146.0</td>\n",
              "      <td>3616.0</td>\n",
              "      <td>33199.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>69</th>\n",
              "      <td>69</td>\n",
              "      <td>9814.0</td>\n",
              "      <td>122522.0</td>\n",
              "      <td>4468.0</td>\n",
              "      <td>5549.0</td>\n",
              "      <td>47333.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>59</th>\n",
              "      <td>59</td>\n",
              "      <td>11530.0</td>\n",
              "      <td>197415.0</td>\n",
              "      <td>4184.0</td>\n",
              "      <td>2999.0</td>\n",
              "      <td>54832.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>...</th>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "      <td>...</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>43</th>\n",
              "      <td>43</td>\n",
              "      <td>28.0</td>\n",
              "      <td>2950.0</td>\n",
              "      <td>14.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>11</th>\n",
              "      <td>12</td>\n",
              "      <td>30.0</td>\n",
              "      <td>13012.0</td>\n",
              "      <td>10.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>102</th>\n",
              "      <td>977</td>\n",
              "      <td>78.0</td>\n",
              "      <td>2436.0</td>\n",
              "      <td>8.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>97</th>\n",
              "      <td>972</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>266.0</td>\n",
              "      <td>15826.0</td>\n",
              "    </tr>\n",
              "    <tr>\n",
              "      <th>100</th>\n",
              "      <td>975</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "      <td>0.0</td>\n",
              "    </tr>\n",
              "  </tbody>\n",
              "</table>\n",
              "<p>104 rows × 6 columns</p>\n",
              "</div>"
            ],
            "text/plain": [
              "     dep  Nbre_pass_Corona  ...  Nbre_acte_corona  Nbre_acte_tot\n",
              "75    75           32292.0  ...           12145.0       103013.0\n",
              "94    94           14628.0  ...               0.0            0.0\n",
              "95    95           15836.0  ...            3616.0        33199.0\n",
              "69    69            9814.0  ...            5549.0        47333.0\n",
              "59    59           11530.0  ...            2999.0        54832.0\n",
              "..   ...               ...  ...               ...            ...\n",
              "43    43              28.0  ...               0.0            0.0\n",
              "11    12              30.0  ...               0.0            0.0\n",
              "102  977              78.0  ...               0.0            0.0\n",
              "97   972               0.0  ...             266.0        15826.0\n",
              "100  975               0.0  ...               0.0            0.0\n",
              "\n",
              "[104 rows x 6 columns]"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 87
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "16eR7a48yPtV"
      },
      "source": [
        "coord_reg = json.load(open(\"/content/geoloc/regions.geojson\"))"
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "xrXjBGppy2Nu",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 35
        },
        "outputId": "fc3c613b-44e7-44a8-c2cf-3b9a8b5f70cf"
      },
      "source": [
        "coordinates_reg = list(coord_reg['features'][0]['geometry']['coordinates'])\n",
        "lat_reg = [coordinates_reg[0][i][0] for i in range(len(coordinates_reg[0]))]\n",
        "lon_reg = [coordinates_reg[0][i][1] for i in range(len(coordinates_reg[0]))]\n",
        "\n",
        "loc = set(zip(lon_reg, lat_reg))\n",
        "\n",
        "map_reg = folium.Map(location = [lon_reg[0], lat_reg[0]], zoom_start=16)\n",
        "FastMarkerCluster(data=loc).add_to(map_reg)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "<folium.plugins.fast_marker_cluster.FastMarkerCluster at 0x7fce89cbed30>"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 89
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "p02oxiSEy7OA",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 788
        },
        "outputId": "a7922841-ee49-49e4-acb6-bcb96abc3f3d"
      },
      "source": [
        "map_reg"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div style=\"width:100%;\"><div style=\"position:relative;width:100%;height:0;padding-bottom:60%;\"><span style=\"color:#565656\">Make this Notebook Trusted to load map: File -> Trust Notebook</span><iframe src=\"about:blank\" style=\"position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;\" data-html=PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgPHNjcmlwdD5MX1BSRUZFUl9DQU5WQVM9ZmFsc2U7IExfTk9fVE9VQ0g9ZmFsc2U7IExfRElTQUJMRV8zRD1mYWxzZTs8L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS40LjAvZGlzdC9sZWFmbGV0LmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NvZGUuanF1ZXJ5LmNvbS9qcXVlcnktMS4xMi40Lm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvanMvYm9vdHN0cmFwLm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvTGVhZmxldC5hd2Vzb21lLW1hcmtlcnMvMi4wLjIvbGVhZmxldC5hd2Vzb21lLW1hcmtlcnMuanMiPjwvc2NyaXB0PgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS40LjAvZGlzdC9sZWFmbGV0LmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvY3NzL2Jvb3RzdHJhcC10aGVtZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vZm9udC1hd2Vzb21lLzQuNi4zL2Nzcy9mb250LWF3ZXNvbWUubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9yYXdjZG4uZ2l0aGFjay5jb20vcHl0aG9uLXZpc3VhbGl6YXRpb24vZm9saXVtL21hc3Rlci9mb2xpdW0vdGVtcGxhdGVzL2xlYWZsZXQuYXdlc29tZS5yb3RhdGUuY3NzIi8+CiAgICA8c3R5bGU+aHRtbCwgYm9keSB7d2lkdGg6IDEwMCU7aGVpZ2h0OiAxMDAlO21hcmdpbjogMDtwYWRkaW5nOiAwO308L3N0eWxlPgogICAgPHN0eWxlPiNtYXAge3Bvc2l0aW9uOmFic29sdXRlO3RvcDowO2JvdHRvbTowO3JpZ2h0OjA7bGVmdDowO308L3N0eWxlPgogICAgCiAgICA8bWV0YSBuYW1lPSJ2aWV3cG9ydCIgY29udGVudD0id2lkdGg9ZGV2aWNlLXdpZHRoLAogICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgIDxzdHlsZT4jbWFwXzk0MmNmNTkyMWQ5YTRiMWI4ZWRkZmE1NzVjYTVmYTJhIHsKICAgICAgICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgICAgICAgd2lkdGg6IDEwMC4wJTsKICAgICAgICBoZWlnaHQ6IDEwMC4wJTsKICAgICAgICBsZWZ0OiAwLjAlOwogICAgICAgIHRvcDogMC4wJTsKICAgICAgICB9CiAgICA8L3N0eWxlPgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIuanMiPjwvc2NyaXB0PgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL01hcmtlckNsdXN0ZXIuRGVmYXVsdC5jc3MiLz4KPC9oZWFkPgo8Ym9keT4gICAgCiAgICAKICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfOTQyY2Y1OTIxZDlhNGIxYjhlZGRmYTU3NWNhNWZhMmEiID48L2Rpdj4KPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgCiAgICAgICAgdmFyIGJvdW5kcyA9IG51bGw7CiAgICAKCiAgICB2YXIgbWFwXzk0MmNmNTkyMWQ5YTRiMWI4ZWRkZmE1NzVjYTVmYTJhID0gTC5tYXAoCiAgICAgICAgJ21hcF85NDJjZjU5MjFkOWE0YjFiOGVkZGZhNTc1Y2E1ZmEyYScsIHsKICAgICAgICBjZW50ZXI6IFs0OS4wNzk3LCAyLjU5MDVdLAogICAgICAgIHpvb206IDE2LAogICAgICAgIG1heEJvdW5kczogYm91bmRzLAogICAgICAgIGxheWVyczogW10sCiAgICAgICAgd29ybGRDb3B5SnVtcDogZmFsc2UsCiAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICB9KTsKCgogICAgCiAgICB2YXIgdGlsZV9sYXllcl81NjhmNmRkYjdjMWY0MzBkYjFhMjJhOTgzOWIwMjdmNCA9IEwudGlsZUxheWVyKAogICAgICAgICdodHRwczovL3tzfS50aWxlLm9wZW5zdHJlZXRtYXAub3JnL3t6fS97eH0ve3l9LnBuZycsCiAgICAgICAgewogICAgICAgICJhdHRyaWJ1dGlvbiI6IG51bGwsCiAgICAgICAgImRldGVjdFJldGluYSI6IGZhbHNlLAogICAgICAgICJtYXhOYXRpdmVab29tIjogMTgsCiAgICAgICAgIm1heFpvb20iOiAxOCwKICAgICAgICAibWluWm9vbSI6IDAsCiAgICAgICAgIm5vV3JhcCI6IGZhbHNlLAogICAgICAgICJvcGFjaXR5IjogMSwKICAgICAgICAic3ViZG9tYWlucyI6ICJhYmMiLAogICAgICAgICJ0bXMiOiBmYWxzZQp9KS5hZGRUbyhtYXBfOTQyY2Y1OTIxZDlhNGIxYjhlZGRmYTU3NWNhNWZhMmEpOwogICAgCgogICAgICAgICAgICB2YXIgZmFzdF9tYXJrZXJfY2x1c3Rlcl9lN2IyNzRmZTE4Mzk0MWJhOWQ3ZGY5ZWRlYzYwNWMyOSA9IChmdW5jdGlvbigpewogICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgY2FsbGJhY2sgPSBmdW5jdGlvbiAocm93KSB7CiAgICAgICAgICAgICAgICAgICAgdmFyIGljb24gPSBMLkF3ZXNvbWVNYXJrZXJzLmljb24oKTsKICAgICAgICAgICAgICAgICAgICB2YXIgbWFya2VyID0gTC5tYXJrZXIobmV3IEwuTGF0TG5nKHJvd1swXSwgcm93WzFdKSk7CiAgICAgICAgICAgICAgICAgICAgbWFya2VyLnNldEljb24oaWNvbik7CiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIG1hcmtlcjsKICAgICAgICAgICAgICAgIH07CgogICAgICAgICAgICAgICAgdmFyIGRhdGEgPSBbWzQ5LjE3NDYsIDIuMjAwMl0sIFs0OC4yOTU2LCAxLjk4Ml0sIFs0OC40MiwgMS45MzQ3XSwgWzQ4LjQ4MjEsIDEuNzkzXSwgWzQ4LjY1MTIsIDEuNjIyMl0sIFs0OC41NjAyLCAxLjc2NzFdLCBbNDguMzg0MSwgMS45NjgzXSwgWzQ4LjU3NTUsIDEuNzMyXSwgWzQ4Ljc3OTksIDEuNTgxMV0sIFs0OC44NzE4LCAzLjM4MzhdLCBbNDguODA5MiwgMS41Nzk2XSwgWzQ5LjE1ODksIDIuMjc3XSwgWzQ5LjE4NDYsIDIuMzA2MV0sIFs0OC45OTEsIDMuMjI0N10sIFs0OS4xNjk5LCAyLjMzNjNdLCBbNDkuMTUyNSwgMi4zNjM5XSwgWzQ5LjIyMjUsIDEuNjkwOF0sIFs0OS4yMjg0LCAxLjcwM10sIFs0OS4xODM0LCAyLjMwNThdLCBbNDkuMDc5MiwgMi45MjA3XSwgWzQ4LjkzODgsIDMuMzEwNF0sIFs0OS4xMDA1LCAzLjE0OTddLCBbNDkuMDcxNSwgMi43MzE2XSwgWzQ5LjE5MDEsIDIuMDk1OV0sIFs0OC45MDU1LCAxLjUzODhdLCBbNDkuMTczNiwgMi4xOTI0XSwgWzQ4Ljk4MDEsIDEuNTExMl0sIFs0OS4wNjExLCAyLjc1NDhdLCBbNDkuMDgzOCwgMi45NzE4XSwgWzQ5LjE3OTIsIDIuMjIwM10sIFs0OS4xNDg3LCAyLjM1Nl0sIFs0OC40ODgsIDMuNDA4M10sIFs0OS4xNjMyLCAxLjg4NzRdLCBbNDkuMTg4MSwgMi4xNDddLCBbNDkuMTUzNSwgMi4zNjQ5XSwgWzQ5LjE5NTYsIDIuMDkyNl0sIFs0OS4xMzU4LCAyLjQ2NzZdLCBbNDguMzUxNiwgMy4wOTk2XSwgWzQ5LjE3OTgsIDIuMTYxXSwgWzQ5LjE2NjEsIDEuODM4XSwgWzQ4Ljc2MDMsIDEuNjA2NF0sIFs0OC41MDQ1LCAzLjQyOTNdLCBbNDkuMTQ5OCwgMi4zOTU1XSwgWzQ4LjkzMDMsIDEuNTA5M10sIFs0OS4yMDQ3LCAxLjcxNTldLCBbNDkuMTk0MSwgMi4wOTI4XSwgWzQ5LjE1ODEsIDIuMzcwMl0sIFs0OS4xNDk4LCAyLjQxNzVdLCBbNDguODkzMiwgMS41NTYxXSwgWzQ5LjE1MjIsIDIuMjMzNl0sIFs0OS4xNTc0LCAyLjI2MV0sIFs0OS4xOTM5LCAxLjczNzNdLCBbNDguODQ0NCwgMS41NzczXSwgWzQ5LjExMiwgMy4wNzk4XSwgWzQ5LjEzOTcsIDEuNjUyOF0sIFs0OS4wNjkyLCAxLjUyMzldLCBbNDkuMDgwNywgMS41ODY0XSwgWzQ5LjA4NDEsIDEuNjAwMV0sIFs0OS4wOCwgMS42MTIzXSwgWzQ4LjU3NTUsIDEuNzMxOF0sIFs0OS4xMjQ5LCAxLjY0NzRdLCBbNDkuMTY2NCwgMS42NjYxXSwgWzQ5LjE2OTcsIDEuNjcwM10sIFs0OS4xODA2LCAxLjY3MThdLCBbNDkuMjE4MiwgMS42ODddLCBbNDkuMTgyNCwgMS42NzA5XSwgWzQ4LjY1LCAxLjY0MzddLCBbNDguNzA5OCwgMS41OTM0XSwgWzQ4LjY1OSwgMS42MDg2XSwgWzQ4LjY4NDEsIDEuNjEwMV0sIFs0OC41NTMsIDEuNzgwOV0sIFs0OC42MTM2LCAxLjcwOTJdLCBbNDguNjE1MSwgMS42NzI2XSwgWzQ4LjM3NDksIDEuOTgyMV0sIFs0OC40NDYyLCAxLjg0NDldLCBbNDguNTczMywgMS43NDI4XSwgWzQ5LjEzMTUsIDEuNjU2XSwgWzQ5LjIwNzIsIDIuMDkxXSwgWzQ5LjE1NjMsIDIuMjY5NV0sIFs0OC40NDkzLCAzLjQwNzVdLCBbNDkuMTgxNiwgMi4zMjEzXSwgWzQ5LjE2ODIsIDIuMzM4XSwgWzQ5LjE5MTMsIDIuMTI2XSwgWzQ4LjQ4LCAzLjM4MzddLCBbNDguMzExMSwgMy4wMTk0XSwgWzQ5LjIwNDQsIDIuMDkxNV0sIFs0OS4xNzYxLCAyLjI5NjddLCBbNDguMjU0OSwgMi40MzI3XSwgWzQ4LjE3OTUsIDIuOTM1N10sIFs0OC4yMjgxLCAyLjUxODFdLCBbNDguMjcxNiwgMi40MTldLCBbNDguMzExLCAyLjM1NjVdLCBbNDguMzMyMSwgMi4yMzc3XSwgWzQ5LjEwMjEsIDMuMDU2Nl0sIFs0OS4xMDMzLCAzLjA1OTZdLCBbNDkuMTExOSwgMy4wNjczXSwgWzQ5LjEwOCwgMy4xMTE0XSwgWzQ5LjEwNjYsIDMuMTI4M10sIFs0OS4wODY3LCAzLjAzOTldLCBbNDkuMTA3NywgMy4wNjI2XSwgWzQ5LjExMzUsIDMuMDY4OF0sIFs0OS4xMDgsIDMuMTAyNF0sIFs0OC4yMDEzLCAyLjUxODVdLCBbNDguMzIyOCwgMi4xODQ2XSwgWzQ5LjE4NTIsIDIuMzE4OF0sIFs0OC43MzksIDEuNjIxNl0sIFs0OS4yMDI4LCAxLjcxODRdLCBbNDguODkyNSwgMS41NTU4XSwgWzQ5LjE1NTcsIDIuMjU5OF0sIFs0OC44Nzc1LCAxLjU1MzNdLCBbNDkuMDgyNiwgMS42MTYzXSwgWzQ5LjE5NDEsIDIuMDkyNl0sIFs0OC44NjM5LCAxLjU3MjFdLCBbNDguODY4MywgMy40MDA5XSwgWzQ4Ljg0ODMsIDMuNDQ2N10sIFs0OC42NDE0LCAzLjQ1NTddLCBbNDguNTc5NSwgMy40ODE4XSwgWzQ4LjUyODEsIDMuNDM5XSwgWzQ4LjQ4MDUsIDMuMzg3Ml0sIFs0OC4zNjQxLCAzLjE5OTddLCBbNDguMzY4NiwgMy4xMjhdLCBbNDguNjkyMiwgMy40NzI2XSwgWzQ4LjQ4NCwgMy4zOTc5XSwgWzQ5LjA4NDQsIDIuNzg4NV0sIFs0OS4wOTQyLCAyLjYxNzddLCBbNDkuMDk3MywgMi42MjM5XSwgWzQ5LjA3MjksIDIuNzMwNV0sIFs0OS4wNzk1LCAyLjg4NzZdLCBbNDkuMDcxLCAyLjk4NjddLCBbNDguNzQ0OCwgMS42MjM4XSwgWzQ4LjU4NDMsIDEuNzAzNl0sIFs0OC44MDM1LCAxLjU3ODZdLCBbNDkuMTEwNiwgMS42MzE2XSwgWzQ5LjEwMjMsIDIuNTU3N10sIFs0OS4wNzk4LCAyLjU4MzZdLCBbNDguOTc1NywgMS40NzMyXSwgWzQ4LjM0NjMsIDMuMDM5NF0sIFs0OS4xODQ5LCAxLjc5NTNdLCBbNDkuMTMxMSwgMi40NzU4XSwgWzQ5LjEyMiwgMi41NDldLCBbNDkuMTcxNSwgMS45NTMxXSwgWzQ5LjE1NCwgMi4zNjY2XSwgWzQ5LjA2NDEsIDEuNDYxN10sIFs0OS4wNjM3LCAxLjQ2MzJdLCBbNDkuMDUzNSwgMS40NzY5XSwgWzQ5LjA4NjEsIDEuNjIzM10sIFs0OS4xMDA5LCAxLjYyMThdLCBbNDkuMTI3NSwgMS42NTA3XSwgWzQ5LjIwMTgsIDEuNjc2Nl0sIFs0OS4yMTkyLCAxLjY4ODhdLCBbNDkuMjM1MSwgMS43MTMyXSwgWzQ5LjIyNTUsIDEuNzM3Nl0sIFs0OS4xNzQ5LCAxLjkzMTNdLCBbNDguMzQ5NiwgMS45NzQ5XSwgWzQ4LjYxNTYsIDEuNjgyM10sIFs0OC40MywgMS45MzY4XSwgWzQ4LjY0ODYsIDEuNjMzNV0sIFs0OC40MzEzLCAxLjkzNjhdLCBbNDguNDY1OSwgMS44MzYyXSwgWzQ4LjMzNTMsIDEuOTc0OV0sIFs0OC40NDY4LCAxLjg1NzZdLCBbNDguMzg1OCwgMS45NzA0XSwgWzQ4LjYxMjEsIDEuNjk5XSwgWzQ4LjYzNjEsIDMuNDUzM10sIFs0OC4yMjIxLCAzLjAxMjhdLCBbNDguOTM2NCwgMy4zMTE3XSwgWzQ4LjQyNzYsIDMuMzkzOF0sIFs0OC45NDA5LCAxLjUwMl0sIFs0OS4xNzYsIDEuOTY0XSwgWzQ4Ljg2MDUsIDMuNDQwMl0sIFs0OC40NTQ1LCAzLjQwMzZdLCBbNDkuMTY3NiwgMS44ODIyXSwgWzQ4Ljk3MTUsIDMuMjUyNF0sIFs0OC44OTI2LCAzLjM2OTldLCBbNDguNjIzMSwgMy41NTEyXSwgWzQ4LjQ4NTYsIDMuNDA5NV0sIFs0OS4xNzA4LCAxLjg1NzRdLCBbNDguOTEzMSwgMy4zMjYyXSwgWzQ4LjczOTEsIDMuNDM5XSwgWzQ4LjczNzgsIDMuNDQyXSwgWzQ4LjkzMTgsIDEuNTExXSwgWzQ5LjA5NjIsIDIuNjU5XSwgWzQ5LjE5NjcsIDIuMDkxOF0sIFs0OC40OTAxLCAzLjQxNzVdLCBbNDguMjg4MiwgMi4wMzY3XSwgWzQ5LjE2NjcsIDIuMTcwOV0sIFs0OS4xNjg1LCAyLjIzMzRdLCBbNDguNjIzNywgMy41NTA2XSwgWzQ4LjQxNSwgMy40MTM0XSwgWzQ4LjI0OTMsIDMuMDQzMV0sIFs0OC4zNzMxLCAzLjMzMTJdLCBbNDkuMTc1NiwgMS44MzM5XSwgWzQ4Ljg3MTcsIDMuMzkxOV0sIFs0OC44NTQ0LCAzLjQ0OTldLCBbNDguNzg0OCwgMS41NzYzXSwgWzQ5LjIwOTEsIDEuNjc0XSwgWzQ5LjIzMDgsIDEuNzAyOV0sIFs0OC4zNzYzLCAzLjM1NTldLCBbNDguMzY4NywgMS45ODMxXSwgWzQ5LjIwNTcsIDIuMDgzNF0sIFs0OC40OTAzLCAzLjQxNjhdLCBbNDguNDE1NiwgMy40MTUzXSwgWzQ4LjMyODIsIDEuOTgyMl0sIFs0OS4xNDgyLCAxLjY1NThdLCBbNDkuMTg0NSwgMS43NDI3XSwgWzQ4LjMxMzEsIDIuMTgwOV0sIFs0OC4yOTkxLCAyLjE1NjVdLCBbNDguODcxMSwgMS41NDcxXSwgWzQ4LjkzNjYsIDEuNTA5XSwgWzQ5LjA3NzksIDEuNjA4OF0sIFs0OS4xNTIxLCAyLjIyMl0sIFs0OC42NzQsIDMuNDQ0OF0sIFs0OC42NjIyLCAzLjQ0MzNdLCBbNDkuMjIzOCwgMS42OTc1XSwgWzQ4Ljc3OTYsIDMuNDI3OF0sIFs0OC40OTAyLCAzLjQyMDFdLCBbNDguNDg4NiwgMy40MDc5XSwgWzQ5LjE4MjMsIDEuODAxXSwgWzQ4Ljk4MjMsIDEuNDY2N10sIFs0OS4xNjI2LCAxLjY2NDFdLCBbNDkuMjMwNSwgMS43MDM3XSwgWzQ5LjE4MTMsIDEuNzQxOF0sIFs0OC44NTk2LCAzLjQzMjldLCBbNDguODQwOCwgMy40NjAzXSwgWzQ4LjM1ODUsIDMuMDgzOF0sIFs0OC4zMzAzLCAzLjA0MjddLCBbNDguODYzMywgMS41NzM5XSwgWzQ4LjI5MDcsIDIuNDIyNV0sIFs0OS4xOTQ0LCAyLjA0MjhdLCBbNDguNjE3MywgMS42NzY0XSwgWzQ4Ljg5NzIsIDEuNTUxNF0sIFs0OC43NzkzLCAxLjU4MDRdLCBbNDkuMTI1MywgMS42NDk4XSwgWzQ4Ljg3MTgsIDMuMzgxM10sIFs0OC44MTgzLCAzLjQ3NDJdLCBbNDkuMDI0MiwgMS40NjA1XSwgWzQ5LjA4MjYsIDEuNTEzOF0sIFs0OS4wNjkxLCAxLjUyNl0sIFs0OS4wNjk5LCAxLjUyNl0sIFs0OS4wNzAxLCAxLjUyNzVdLCBbNDkuMDc4MywgMS41NzMzXSwgWzQ5LjA4MDMsIDEuNjEyOV0sIFs0OS4wOTE4LCAxLjYyMzZdLCBbNDkuMTgxOSwgMS44MDMzXSwgWzQ5LjE3NzIsIDIuMzI2N10sIFs0OC4zNjc1LCAzLjE5NzRdLCBbNDguMzY0LCAxLjk4NjVdLCBbNDguNDY2OSwgMS44MDJdLCBbNDguNjE4NSwgMS42Nzg1XSwgWzQ4LjM1MTQsIDEuOTc0M10sIFs0OC4yODY0LCAxLjk5ODddLCBbNDguNDI1MiwgMS45NDA3XSwgWzQ4LjQzMzcsIDEuOTM5Ml0sIFs0OC4xNjkxLCAyLjUxNDhdLCBbNDguNTk2OSwgMS43MTIxXSwgWzQ4LjU5OTIsIDEuNzE0OF0sIFs0OC45NTAyLCAzLjI2MDRdLCBbNDkuMTkwOCwgMi4xMzUzXSwgWzQ5LjEzNTksIDIuNDYxNV0sIFs0OC4yMzkxLCAyLjQ4NDFdLCBbNDkuMjIzLCAxLjY5MTFdLCBbNDguNTA2LCAzLjQyOF0sIFs0OC40OTQxLCAzLjQzNF0sIFs0OC4xNjIzLCAyLjczOTRdLCBbNDguNDg3NywgMy40MDgyXSwgWzQ4LjE1ODYsIDIuNTAxNl0sIFs0OC4yMjc2LCAyLjUxODNdLCBbNDguMzA5MSwgMi4yOTcyXSwgWzQ4Ljg4MDEsIDMuMzgyMV0sIFs0OS4xMjEsIDIuNTQzN10sIFs0OS4xMTgxLCAxLjY0NF0sIFs0OC4yNTE4LCAyLjQ1ODddLCBbNDguMzM4NywgMi4yMTE3XSwgWzQ4LjM0MTgsIDIuMjA3Ml0sIFs0OC45NzY4LCAxLjQ3NzNdLCBbNDkuMTUxOCwgMi4zNTQ5XSwgWzQ5LjEyMjksIDIuNDk2OF0sIFs0OC4zNTc3LCAzLjA1OTVdLCBbNDkuMTAyLCAyLjU1NzhdLCBbNDguMjU0MSwgMi40NjgzXSwgWzQ5LjIyNDIsIDEuNzM5M10sIFs0OS4xNTMzLCAyLjM1NTVdLCBbNDguMTg5MSwgMi45NDg1XSwgWzQ4LjE1NjYsIDIuNTA2NV0sIFs0OC4yOTEsIDIuNDIyNl0sIFs0OC4zMzE4LCAyLjMyMl0sIFs0OC4zMjU2LCAyLjI0NDNdLCBbNDguMzAyNiwgMi4xNjE5XSwgWzQ4LjMwMzEsIDIuMTYxOV0sIFs0OC4xNTIyLCAyLjc5OTFdLCBbNDguMjI2MiwgMi41MTFdLCBbNDguMzA0MiwgMi40MTUxXSwgWzQ5LjEwNzgsIDMuMTA0NV0sIFs0OS4wODYyLCAzLjE1NjJdLCBbNDguMTUxMSwgMi43NTQ4XSwgWzQ4LjI1NDgsIDIuNDM0Nl0sIFs0OS4wOTExLCAzLjA2MTddLCBbNDkuMDg5NSwgMy4xNTkzXSwgWzQ4LjIxMDgsIDIuNTE3XSwgWzQ5LjE3NzEsIDEuODMwNl0sIFs0OC44MDc5LCAzLjQwNTldLCBbNDguNjA0MywgMy41MDM1XSwgWzQ4LjMwNzMsIDMuMDE1N10sIFs0OS4wNzM3LCAxLjU0MTNdLCBbNDkuMTA4LCAxLjYyOTddLCBbNDguMjk5NywgMi4wOTIzXSwgWzQ5LjA3MjYsIDEuNTQ3Nl0sIFs0OC40ODczLCAzLjQwNDFdLCBbNDkuMTU1OSwgMi4zNjg0XSwgWzQ4LjMzMTMsIDIuMjI5Ml0sIFs0OC4zMzA1LCAyLjE4ODFdLCBbNDguNjQzNCwgMy41MTc1XSwgWzQ4LjU0MjUsIDMuNDgwOV0sIFs0OC44MDU4LCAxLjU4MjJdLCBbNDguMzA2OSwgMi4yNjE5XSwgWzQ5LjE3NDMsIDIuMTc4XSwgWzQ5LjE4MzksIDIuMzA0NV0sIFs0OC40ODkyLCAzLjQxNTddLCBbNDguMjU3NywgMy4wNDU0XSwgWzQ5LjE3MDQsIDEuODM1OV0sIFs0OC43Nzk1LCAzLjQyODJdLCBbNDguNzQ0NiwgMy40Mzc0XSwgWzQ4LjM5OTMsIDMuMzg1NF0sIFs0OC40Mjg0LCAzLjM5NDZdLCBbNDguNDQ4NiwgMy40MDY4XSwgWzQ4LjQzNjEsIDMuMzk0Nl0sIFs0OC4zMjI2LCAzLjAzMDNdLCBbNDguOTQ4OCwgMy4zMDQ3XSwgWzQ4LjkyODQsIDMuMzY3Ml0sIFs0OC44Nzk2LCAzLjM4MDldLCBbNDkuMTA4NCwgMi42MzQzXSwgWzQ5LjA3NjUsIDIuODgyOF0sIFs0OS4wNzc5LCAyLjkyMjRdLCBbNDkuMDcxNSwgMi45ODE5XSwgWzQ5LjEwMiwgMi42MzU4XSwgWzQ5LjA2ODUsIDIuNzMxOV0sIFs0OS4xNDkzLCAyLjM1NTFdLCBbNDguMzUzNywgMy4xMDAxXSwgWzQ4LjI4NDcsIDIuMDA1OV0sIFs0OC45MjM2LCAxLjUzMDddLCBbNDkuMTcxLCAxLjkxNzFdLCBbNDguNjYzNywgMy40NDA2XSwgWzQ4LjUzNjIsIDMuNDY4XSwgWzQ4LjUyODgsIDMuNDM1OV0sIFs0OC4zNzMsIDMuMzEwOV0sIFs0OS4xNzg0LCAyLjIxNTRdLCBbNDkuMTU4MiwgMi4zNzg1XSwgWzQ4LjQ5MjIsIDMuNDIyMV0sIFs0OC4zOTU1LCAzLjM5NDddLCBbNDguMTIyNCwgMi40NTQ0XSwgWzQ5LjE3OCwgMS44MTM4XSwgWzQ5LjEwNzYsIDIuNTU2NV0sIFs0OC43NTUzLCAzLjQzMzRdLCBbNDguNTM4NiwgMS43ODE1XSwgWzQ4LjMzLCAyLjI0MzFdLCBbNDkuMDg2OSwgMi42MDQ0XSwgWzQ5LjA3NDcsIDIuODgwM10sIFs0OS4wNzk4LCAyLjkyOTFdLCBbNDkuMDUxNCwgMS40ODY3XSwgWzQ5LjA3MjQsIDEuNTM4NV0sIFs0OS4wODE0LCAxLjU5MDNdLCBbNDkuMDg0NSwgMS42MDI1XSwgWzQ5LjA3OTYsIDEuNjExN10sIFs0OS4xNDA5LCAxLjY1MjhdLCBbNDkuMTQxNywgMS42NTI4XSwgWzQ5LjE1NDksIDEuNjYzNV0sIFs0OS4yMTE5LCAxLjY3NzJdLCBbNDguMzI2NCwgMi4xODVdLCBbNDguOTc5NywgMS40ODQyXSwgWzQ5LjE1MTUsIDIuMzU0M10sIFs0OS4xMjA4LCAyLjU0NzhdLCBbNDguNjE3OCwgMy41NTg3XSwgWzQ4LjM3MjcsIDMuMzI4Nl0sIFs0OC4zNjQsIDMuMjAxOV0sIFs0OC41NTk0LCAxLjc2NzRdLCBbNDguNjM4MSwgMS42NTE2XSwgWzQ4LjQ0MTIsIDEuOTM5N10sIFs0OC42NjgzLCAxLjYwMTNdLCBbNDguNDk5MSwgMS43ODg4XSwgWzQ4LjcxMDYsIDEuNTg3Nl0sIFs0OC4zNzg2LCAxLjk3NzhdLCBbNDguNDU2MSwgMS45MjldLCBbNDguMzYzMiwgMS45ODg1XSwgWzQ4Ljc2MTcsIDEuNTg5MV0sIFs0OS4xNjEyLCAyLjIyMzddLCBbNDkuMTE4NiwgMi41NTYxXSwgWzQ4LjY4NTcsIDMuNDcxN10sIFs0OC40ODU4LCAzLjM5ODVdLCBbNDguNjg5OCwgMy40NzE4XSwgWzQ4LjE5MTgsIDIuOTU2N10sIFs0OC4xNDQ0LCAyLjg1NDZdLCBbNDguMzAyLCAyLjQxNzFdLCBbNDguMzI1OCwgMi4zMzY0XSwgWzQ5LjA3MjIsIDIuODU0Nl0sIFs0OS4xMDksIDIuNTU1OF0sIFs0OC4zMzIxLCAyLjIzNzldLCBbNDguNzg0NCwgMy40Mzk5XSwgWzQ4LjM5ODYsIDMuMzgwNl0sIFs0OC45NzY4LCAzLjIzMTJdLCBbNDguOTc3MywgMy4yMzQyXSwgWzQ4LjMxMDQsIDIuNDA4NF0sIFs0OS4yMDksIDIuMDg4Ml0sIFs0OC42MTYsIDMuNTQ1OF0sIFs0OC4zMjYsIDMuMDM2Nl0sIFs0OC4zMDg2LCAyLjI5NjJdLCBbNDguOTIzNywgMS41MTY1XSwgWzQ5LjE4NjUsIDIuMzExNF0sIFs0OS4xMTg2LCAyLjUzODVdLCBbNDguODk5MSwgMy4zNzAyXSwgWzQ4Ljg4ODYsIDMuMzgyNF0sIFs0OC4zNzg0LCAzLjMwMDJdLCBbNDguNzM2LCAxLjYxNzFdLCBbNDguMjU1MiwgMi40NjgyXSwgWzQ4LjMzMDgsIDIuMzEyNl0sIFs0OS4wODE5LCAyLjc3MTVdLCBbNDkuMTkxMywgMi4wOTYyXSwgWzQ4Ljg3MDgsIDMuNDA1OV0sIFs0OC41MzA3LCAzLjQ1OTJdLCBbNDguOTc3NSwgMy4yMzY2XSwgWzQ5LjE4NDcsIDEuNzgwNl0sIFs0OC43Mzg4LCAxLjYyMTZdLCBbNDkuMjAxNSwgMS43MTk5XSwgWzQ4Ljg5MzksIDMuMzY5XSwgWzQ4Ljg5MDYsIDMuMzc1Ml0sIFs0OC40MzE5LCAzLjM5NTFdLCBbNDguMTM4NywgMi44NDJdLCBbNDguODMzNywgMS41OTM5XSwgWzQ4LjgwNTgsIDEuNTgwN10sIFs0OC4zMzc2LCAyLjIxMzFdLCBbNDguOTI4MywgMy4zNjhdLCBbNDguODYwMSwgMy40MzJdLCBbNDguNTUzLCAzLjQ3NjFdLCBbNDguNDk5LCAzLjQzMzVdLCBbNDguNDM5OCwgMS44NzA5XSwgWzQ4LjgxMDQsIDEuNTgxM10sIFs0OS4wODM1LCAyLjc2OTNdLCBbNDkuMTMzOSwgMi40MzU0XSwgWzQ4LjkxMywgMy4zNDFdLCBbNDguODkyNSwgMy4zNzAxXSwgWzQ4Ljg0MjUsIDMuNDQ5M10sIFs0OC43Nzk5LCAzLjQwODJdLCBbNDguNTg5NCwgMy41MDg4XSwgWzQ4LjUxNDQsIDEuNzc2Ml0sIFs0OC4zNjk1LCAxLjk3ODldLCBbNDguNDkwMiwgMy40MTcxXSwgWzQ4LjQ2NjMsIDMuMzk3Ml0sIFs0OS4wODYsIDMuMDQ5Ml0sIFs0OC45NDc4LCAzLjI2MjFdLCBbNDguNDgwNCwgMy4zODcxXSwgWzQ4LjI1MDksIDMuMDM2M10sIFs0OC4zMDkxLCAyLjQwODldLCBbNDguOTI1NCwgMS41MTkxXSwgWzQ5LjEwNDgsIDIuNDk4OF0sIFs0OC44MDM2LCAzLjQxMjldLCBbNDguNTQ5MSwgMy40ODQ2XSwgWzQ4LjMyMTcsIDIuMzA1XSwgWzQ4LjMxNjQsIDIuMjM4XSwgWzQ4LjI4ODUsIDMuMDI2M10sIFs0OC41MjEzLCAxLjc3N10sIFs0OC43ODM2LCAxLjU3NzNdLCBbNDkuMTExOSwgMy4wNzk4XSwgWzQ5LjE3MjUsIDIuMTU3N10sIFs0OC40Nzg4LCAzLjM4NDNdLCBbNDguMzM1LCAzLjAzNjddLCBbNDkuMDU3MywgMS40NTU3XSwgWzQ5LjA1NywgMS40OTM4XSwgWzQ5LjA3MTgsIDEuNTMzNF0sIFs0OS4wNzA2LCAxLjU1MzNdLCBbNDkuMDcwMiwgMS41NTYzXSwgWzQ5LjA3MzEsIDEuNTY3XSwgWzQ5LjA3NjEsIDEuNTddLCBbNDkuMDc5NiwgMS41ODA3XSwgWzQ5LjA5OTYsIDIuNTMxMV0sIFs0OC43NTUsIDMuNDMzN10sIFs0OC40MTYxLCAzLjQxODVdLCBbNDguMzY1MSwgMy4yMDY2XSwgWzQ4LjQxNjMsIDEuOTI3Nl0sIFs0OC41MTg2LCAxLjc3ODJdLCBbNDguNDc4MSwgMS43OTM0XSwgWzQ4LjU2MTIsIDEuNzY2XSwgWzQ4LjU4NSwgMS43MDJdLCBbNDguNjkyOSwgMS41OTA3XSwgWzQ4LjM3OTYsIDEuOTc2NF0sIFs0OC41ODQ5LCAxLjcwMl0sIFs0OC42MTY4LCAxLjY3NjFdLCBbNDguNzEzNCwgMS41OTA3XSwgWzQ4LjgzMjgsIDEuNTg2OF0sIFs0OC45OTU3LCAxLjQ3MjZdLCBbNDguODkxMywgMy4zNzQ5XSwgWzQ4LjMzLCAyLjI0NjNdLCBbNDguMzU4LCAzLjA5NTddLCBbNDguODg4NiwgMy4zODIyXSwgWzQ4Ljc1NDcsIDMuNDE0M10sIFs0OC4zNjc1LCAzLjI0OF0sIFs0OC45NTIzLCAxLjUwNDldLCBbNDkuMTc0LCAxLjgxMzRdLCBbNDguMzIxMiwgMi4yNDA5XSwgWzQ4LjM3MjMsIDMuMzY1Ml0sIFs0OC4zNzEyLCAzLjE2NTVdLCBbNDguMTY2MiwgMi41MTY1XSwgWzQ4LjIyNzgsIDIuNTE2NV0sIFs0OC4zMTA1LCAyLjQwODRdLCBbNDkuMTcyLCAxLjg1NzddLCBbNDkuMTAyOCwgMi41MTY1XSwgWzQ5LjA5NSwgMi41NjUzXSwgWzQ4LjkxMjUsIDMuMzM5OV0sIFs0OC44NzU0LCAzLjM5MzJdLCBbNDguMzEwNCwgMi4yNjI2XSwgWzQ5LjA4NCwgMi45OTEyXSwgWzQ5LjExOTQsIDIuNTQzXSwgWzQ4LjE2MzcsIDIuNzc0Nl0sIFs0OC4xMjQ1LCAyLjY4MzJdLCBbNDguMTI0NiwgMi40NDY5XSwgWzQ4LjMyODgsIDIuMzExMl0sIFs0OC4zMTYxLCAyLjMwMl0sIFs0OC4xOTQ4LCAyLjk3MTNdLCBbNDkuMTA3LCAzLjEzMDFdLCBbNDkuMTAwMSwgMy4xNTE1XSwgWzQ5LjAxMjUsIDMuMTc1OV0sIFs0OC4xNTUxLCAyLjQ3ODhdLCBbNDkuMDM1OSwgMy4xNzg5XSwgWzQ5LjA5MDYsIDMuMDE3M10sIFs0OS4wMDQzLCAzLjIwMDNdLCBbNDkuMDAwNywgMy4yMDQ4XSwgWzQ5LjA4NzMsIDMuMDQwMl0sIFs0OS4xMDU0LCAzLjA2MTZdLCBbNDguMjQ5MywgMi40Nzg5XSwgWzQ5LjA5NywgMi41NjExXSwgWzQ4LjkxMjIsIDMuMzc1M10sIFs0OS4xMDk0LCAxLjYyOTddLCBbNDguMzIxNiwgMi4zMDU3XSwgWzQ4LjI5NDEsIDIuMDcwOV0sIFs0OC4yODQ4LCAyLjA0Ml0sIFs0OC45Nzk0LCAxLjUxMThdLCBbNDkuMDg0OSwgMi45NDQ0XSwgWzQ5LjE0OTUsIDIuNDI0NV0sIFs0OC40MTU4LCAzLjQxNzhdLCBbNDguOTgxNSwgMy4yMjg4XSwgWzQ4LjU0MzUsIDMuNDgwM10sIFs0OS4xMzk5LCAyLjQzODJdLCBbNDguMjk2NywgMS45NzI3XSwgWzQ4Ljg5NTYsIDEuNTUyOF0sIFs0OS4wNzQsIDIuODc4Nl0sIFs0OC45MTYzLCAzLjMyMDhdLCBbNDguNjM2MiwgMy40NjI3XSwgWzQ4LjE2MjIsIDIuNzUxMl0sIFs0OS4xNzM2LCAxLjkyNjFdLCBbNDguNjI2OCwgMy41NDc4XSwgWzQ4LjQ2OCwgMy4zOTg0XSwgWzQ4LjE2MzQsIDIuNzU4Nl0sIFs0OC44OTU0LCAzLjM2OTNdLCBbNDguODk0NSwgMy4zNjkzXSwgWzQ4LjkxODIsIDMuMzYwMV0sIFs0OC44NzU5LCAzLjQwNTldLCBbNDguODc0MSwgMy40MDU5XSwgWzQ4Ljg1MywgMy40NDg1XSwgWzQ4Ljc3OTQsIDMuNDI4OF0sIFs0OC43OCwgMy40MjczXSwgWzQ4LjczNjYsIDMuNDQ4NV0sIFs0OC40ODQxLCAzLjM5NTJdLCBbNDkuMDkxNSwgMi42MDldLCBbNDkuMTAyNSwgMi42MzA0XSwgWzQ5LjA5NDQsIDIuODAyNV0sIFs0OS4wNzA0LCAyLjg1OV0sIFs0OS4wNzg5LCAyLjkyMTVdLCBbNDkuMDc5OSwgMi45MjkyXSwgWzQ4LjE1NjksIDIuODc1XSwgWzQ4LjEzODMsIDIuNjMzOV0sIFs0OC44NzU4LCAzLjQwNF0sIFs0OC44NTgsIDMuNDQ5Nl0sIFs0OC4xMjQxLCAyLjY2MDRdLCBbNDguMTM0NCwgMi41Mjk0XSwgWzQ4LjI5NjcsIDIuNDIxMV0sIFs0OS4xNjc4LCAxLjY2NzddLCBbNDkuMjA2OCwgMi4wODEyXSwgWzQ4LjUzMDUsIDMuNDQ5NV0sIFs0OC4zMTYyLCAyLjI0NTddLCBbNDguODUwNSwgMS41Nzk4XSwgWzQ5LjIwODcsIDIuMDc0OV0sIFs0OS4xMDcyLCAzLjEzMzFdLCBbNDkuMDEyMywgMy4xNjgyXSwgWzQ4LjE0MDcsIDIuNTQ2NF0sIFs0OC4xMzU3LCAyLjQ1NV0sIFs0OS4yMTgzLCAxLjY4NzldLCBbNDkuMTg2NCwgMS43NDEyXSwgWzQ5LjEyMTcsIDIuNTU3MV0sIFs0OC45NDQzLCAzLjI5NDRdLCBbNDkuMDI5NiwgMS40NTc1XSwgWzQ5LjAzMDMsIDEuNDU3NV0sIFs0OS4wMzY2LCAxLjQ1Nl0sIFs0OS4wNiwgMS40NjgyXSwgWzQ5LjA1ODQsIDEuNDk3MV0sIFs0OS4wODQ3LCAxLjUwNjNdLCBbNDkuMDczNSwgMS41MTg1XSwgWzQ5LjA3MzEsIDEuNTY4OF0sIFs0OS4wODQsIDEuNjA2OV0sIFs0OC4xODQ3LCAyLjk0MjddLCBbNDguMjY5NywgMi40MTk4XSwgWzQ4Ljk3OTQsIDEuNDc1XSwgWzQ5LjEzOTUsIDIuNDU0OV0sIFs0OC44NzY0LCAzLjM5NzFdLCBbNDguNDgxMywgMy4zOTQxXSwgWzQ4LjQzMDMsIDMuMzk1Nl0sIFs0OC42MjI2LCAxLjY1NTJdLCBbNDguNzA5NiwgMS41ODk3XSwgWzQ4LjQ3ODIsIDEuNzkyNF0sIFs0OC40NDg1LCAxLjkzMjZdLCBbNDguNDQ5NCwgMS44NDQyXSwgWzQ4LjQ3OTIsIDEuNzkzOV0sIFs0OC42MjI3LCAxLjY1NTJdLCBbNDguMTY3NiwgMi43ODAyXSwgWzQ4LjYxNDcsIDEuNjkxOF0sIFs0OC42OTMyLCAxLjU5MjddLCBbNDkuMTc0MywgMS42NjcyXSwgWzQ4Ljg0NzUsIDEuNTc3N10sIFs0OS4wODQsIDIuODM5NV0sIFs0OS4xNDkzLCAyLjM5MTNdLCBbNDkuMTI0NCwgMi41NTI5XSwgWzQ4Ljc1MzEsIDEuNjE3Ml0sIFs0OS4xNTg1LCAyLjI3NTRdLCBbNDkuMTAzOCwgMi41MDRdLCBbNDguNjgyNiwgMy40NTU0XSwgWzQ4LjY2NjksIDMuNDQ2Ml0sIFs0OC4zMjMzLCAzLjAzMzFdLCBbNDguOTgzOCwgMS41MDc5XSwgWzQ5LjE0OTQsIDIuNDIzN10sIFs0OS4xMTY2LCAyLjU0NzJdLCBbNDguNTk4OSwgMy41MDg2XSwgWzQ4LjkzODksIDMuMjczOF0sIFs0OC45MDY5LCAzLjM3NDRdLCBbNDguODUxLCAzLjQ3MDVdLCBbNDkuMTk1MSwgMS42NzI5XSwgWzQ4LjI3NjEsIDIuNDE5MV0sIFs0OC4zMDU2LCAyLjQxNDRdLCBbNDkuMTczMSwgMi4xOTVdLCBbNDguMTkwOSwgMi41MTcxXSwgWzQ4LjMxNTIsIDIuNDA0M10sIFs0OS4xOTY5LCAxLjcyNTZdLCBbNDkuMDkxMiwgMi45NjUzXSwgWzQ4Ljg2NTcsIDMuNDE2XSwgWzQ4LjYxNjEsIDMuNTQyNV0sIFs0OS4xMDY2LCAzLjEzOTVdLCBbNDkuMTg0NCwgMS42NzA1XSwgWzQ5LjE4NTMsIDEuNzk1NV0sIFs0OS4xODkyLCAyLjEwOTldLCBbNDguODM5NCwgMy40NjA3XSwgWzQ4LjcwNjMsIDMuNDY1NF0sIFs0OC4zNjY0LCAzLjExNzhdLCBbNDguNzkwNywgMS41NzU3XSwgWzQ5LjIyNjUsIDEuNzMzM10sIFs0OC45NDY0LCAzLjMwNjVdLCBbNDguMTMzMiwgMi44MDA5XSwgWzQ4LjUxNzcsIDEuNzc4NF0sIFs0OC45MTk0LCAzLjMxNjNdLCBbNDguOTA5MywgMy4zMzE1XSwgWzQ4LjkxMjgsIDMuMzQwN10sIFs0OC45MTM2LCAzLjM3NDNdLCBbNDguNDc5OCwgMy4zODVdLCBbNDkuMTc2OSwgMS45ODk4XSwgWzQ4LjgxNDUsIDMuNDI1Ml0sIFs0OC4zNTg1LCAzLjA0NzhdLCBbNDguOTEwOSwgMy4zMjg0XSwgWzQ5LjE0NzIsIDEuNjU1OF0sIFs0OS4xOTEsIDEuNjcxM10sIFs0OS4xNzk3LCAyLjE2NF0sIFs0OC42NjE5LCAzLjQ0NjNdLCBbNDkuMjEwNSwgMS42NzQ2XSwgWzQ5LjA5MzcsIDMuMDU3OF0sIFs0OC4xMjM2LCAyLjcwNTddLCBbNDkuMTAwNCwgMi41NThdLCBbNDguMzA5NiwgMy4wMTc3XSwgWzQ4LjE1NjQsIDIuODA0N10sIFs0OC45MDI2LCAxLjU0MjldLCBbNDkuMDk0NywgMi42MTg3XSwgWzQ4LjM3NjYsIDMuMjkyN10sIFs0OC4yMDcxLCAzLjAwMzFdLCBbNDguODcxOCwgMy4zOTMzXSwgWzQ5LjE3NTEsIDEuOTMyNl0sIFs0OS4wMDU0LCAzLjE5ODNdLCBbNDguMzY5NSwgMy4xMzI1XSwgWzQ4LjM3MjQsIDMuMzI5XSwgWzQ4LjkwODUsIDMuMzc2M10sIFs0OC41OTY1LCAzLjUxMl0sIFs0OC40MzEyLCAzLjM5NDddLCBbNDguODk2LCAxLjU1MTVdLCBbNDkuMDQsIDMuMTgyMl0sIFs0OC4zMTc2LCAyLjQwNDFdLCBbNDguMzE2OCwgMi4xODMyXSwgWzQ5LjIzNDgsIDEuNzEzMl0sIFs0OC45MjYyLCAzLjMxMjldLCBbNDkuMTE1MiwgMy4wNzUzXSwgWzQ4LjIwODIsIDIuOTkwMV0sIFs0OC4zMzEsIDIuMjM1Nl0sIFs0OS4yMzE2LCAxLjcwMzFdLCBbNDkuMDcwNCwgMi43MzI0XSwgWzQ5LjE1MTYsIDIuMjQxNl0sIFs0OC4zNzY5LCAzLjMxMTFdLCBbNDguNDA2NSwgMy40MTk0XSwgWzQ4Ljc4NDUsIDMuNDM2MV0sIFs0OC40MTc0LCAzLjQxMDJdLCBbNDguNDA1MiwgMS45NTc0XSwgWzQ4Ljc2MDcsIDEuNjA4M10sIFs0OC43OTkyLCAzLjQ0MDRdLCBbNDkuMDY0NSwgMS41MDgxXSwgWzQ5LjA3NTIsIDEuNTcwNl0sIFs0OS4wOTU1LCAxLjYxNzldLCBbNDguNzIxMSwgMS41OTddLCBbNDguOTMxMiwgMS41MTAxXSwgWzQ5LjEzNTQsIDIuNDcxNl0sIFs0OC4zNjQ4LCAzLjExNV0sIFs0OC42MTMxLCAxLjY4NV0sIFs0OC42NDgxLCAxLjY0MzldLCBbNDguNDg0MiwgMS43OTYzXSwgWzQ4LjYxMzcsIDEuNjcyOF0sIFs0OC40Nzg0LCAxLjc5NDhdLCBbNDguNDkwMSwgMS43ODU2XSwgWzQ4LjM5NDMsIDMuMzY3Ml0sIFs0OC42MTU0LCAxLjY3MjhdLCBbNDguNjczMiwgMS42MDczXSwgWzQ4LjUwMTcsIDEuNzgyNl0sIFs0OS4yMTYsIDEuNzM1NV0sIFs0OC44NjQzLCAzLjQxMDddLCBbNDkuMTU1NiwgMi4yNTg2XSwgWzQ4LjEyNDUsIDIuNjgyOV0sIFs0OC4xMjQyLCAyLjY3MjJdLCBbNDguMzM1NCwgMi4yMTk1XSwgWzQ5LjE0NzYsIDIuMzU5N10sIFs0OC44OSwgMy4zNzc0XSwgWzQ4LjgyMDEsIDMuNDg1N10sIFs0OC43NTU4LCAzLjQzMjRdLCBbNDguMzM1NiwgMi4xOTVdLCBbNDguOTA5NywgMy4zNzY1XSwgWzQ4LjQ4NjQsIDMuNDAwOV0sIFs0OC40MTk5LCAzLjQxMTZdLCBbNDguMjY2LCAyLjQxOTldLCBbNDguMzI4NSwgMi4yMzI0XSwgWzQ4LjMyMTUsIDIuMTgyMV0sIFs0OC4yOTM2LCAyLjA4MTVdLCBbNDguMjg4MiwgMi4wMzc0XSwgWzQ4LjI1MSwgMi40NzY0XSwgWzQ5LjEwNjUsIDMuMTI0N10sIFs0OC4zMzcxLCAyLjIxNTddLCBbNDguMzA0OSwgMi4wOTk5XSwgWzQ5LjEwNzQsIDMuMTE0XSwgWzQ5LjEwNjksIDMuMTM1Ml0sIFs0OS4wMzAzLCAzLjE3NjVdLCBbNDkuMDMzLCAzLjE3NjVdLCBbNDkuMDg5MywgMy4wNjM3XSwgWzQ5LjExNzUsIDMuMDY5N10sIFs0OC4xNzU5LCAyLjkzNDZdLCBbNDkuMjI5LCAxLjcwNDFdLCBbNDkuMTM4MiwgMi40NTNdLCBbNDguNjkwMywgMy40NzE0XSwgWzQ4LjU3MzIsIDEuNzU4N10sIFs0OS4xMTIzLCAzLjA4NTldLCBbNDguMTQzMiwgMi43OThdLCBbNDguMTIyMSwgMi42NzE1XSwgWzQ4LjM0MjMsIDIuMjA1MV0sIFs0OS4xNDg0LCAxLjY1NTldLCBbNDkuMTIyMywgMi40OTkyXSwgWzQ4Ljk5NDksIDMuMjA5MV0sIFs0OC4zODAxLCAzLjI5MTNdLCBbNDguNzk3MywgMS41Nzg3XSwgWzQ5LjA5MzksIDIuNjEwNF0sIFs0OC44MTMsIDMuNDQxM10sIFs0OC44OTk0LCAxLjU0NTZdLCBbNDguMTM3NSwgMi42NDI5XSwgWzQ4LjI5ODgsIDIuMDkxMV0sIFs0OC44NzAxLCAxLjU0NTddLCBbNDkuMDc4OCwgMS41NzddLCBbNDkuMjMzMiwgMS43MDVdLCBbNDkuMTAxOCwgMy4xNDQ4XSwgWzQ4LjE0NzUsIDIuNzk5N10sIFs0OC4yODgyLCAyLjAzNDVdLCBbNDguNjE5NCwgMy41NTY1XSwgWzQ4Ljg3MjMsIDMuMzg1OV0sIFs0OC44NjYzLCAzLjM5OTZdLCBbNDguNjM4MSwgMy41MjE2XSwgWzQ4LjYzMjMsIDMuNTMzOF0sIFs0OC41ODUzLCAzLjQ4OTVdLCBbNDguNDQ2OCwgMy40MDU2XSwgWzQ4LjI3MzgsIDMuMDMwNl0sIFs0OC4yMDY2LCAzLjAwMDJdLCBbNDkuMDg4MywgMi42Nzc0XSwgWzQ5LjA4MjksIDIuNzg1N10sIFs0OS4wODQ5LCAyLjg0MzVdLCBbNDkuMDc1MywgMi44NTI3XSwgWzQ5LjA3NjQsIDIuNzg1N10sIFs0OS4wNjEzLCAyLjc1NTFdLCBbNDkuMDc4NCwgMi43Ml0sIFs0OC4xMjA3LCAyLjY2NzZdLCBbNDguMzE2NywgMi40MDM5XSwgWzQ4LjMwMiwgMi4wOTc2XSwgWzQ4LjkwNTMsIDEuNTRdLCBbNDkuMTgyOSwgMi4xNTYyXSwgWzQ4LjQxNSwgMy40MDY0XSwgWzQ4LjkxNywgMy4zNTAxXSwgWzQ4LjgzNzIsIDMuNDYyOV0sIFs0OC41NDA1LCAzLjQ3MzZdLCBbNDguODMwMywgMS41ODAxXSwgWzQ4Ljg2MTEsIDEuNTgwMV0sIFs0OC43MzcxLCAzLjQ0MzRdLCBbNDguMTIzOCwgMi40NTExXSwgWzQ4LjQ4NTgsIDMuNDA5N10sIFs0OS4wNzgzLCAyLjkzNTddLCBbNDkuMDgyOSwgMi45NDQ5XSwgWzQ4Ljc1OTgsIDMuMzk2M10sIFs0OC4yNDk3LCAzLjAzMzVdLCBbNDguODczMiwgMy4zOTMzXSwgWzQ4Ljg3NDEsIDMuMzkzM10sIFs0OC44MDc0LCAzLjQwN10sIFs0OC40Mjg3LCAzLjM5NDhdLCBbNDguNDc4LCAzLjM4NDFdLCBbNDkuMTY0MiwgMi4yM10sIFs0OC4yOTg3LCAyLjQyMTFdLCBbNDguMzEyMywgMi4zODc1XSwgWzQ5LjA5NTIsIDIuNTcxMV0sIFs0OS4xNzA0LCAxLjg0NDVdLCBbNDguODc1OCwgMy4zODFdLCBbNDguOTc5LCAzLjIyOTldLCBbNDguOTc4MSwgMy4yMjk5XSwgWzQ4Ljc4MzEsIDMuNDEyOV0sIFs0OC42MDAzLCAzLjUwNzVdLCBbNDguMzQ5NSwgMy4xMDM0XSwgWzQ4LjMzNzcsIDMuMDM2M10sIFs0OC40MTYyLCAzLjQyMjFdLCBbNDguODI1NCwgMS41ODUxXSwgWzQ4LjIyNzYsIDIuNTE1NF0sIFs0OC43ODgsIDEuNTc2OF0sIFs0OS4xODg1LCAyLjAyNjFdLCBbNDguODQ3LCAzLjQ0NzFdLCBbNDguNjYwNCwgMy40NDcxXSwgWzQ4LjkwNDksIDEuNTM5Ml0sIFs0OC45MjQyLCAxLjUyODVdLCBbNDkuMjAxNywgMi4wOTA3XSwgWzQ5LjE5NzUsIDIuMDkyMl0sIFs0OC40MjA3LCAzLjQxMTddLCBbNDguOTI0LCAzLjM3MjFdLCBbNDkuMDY3NywgMS41MDk5XSwgWzQ5LjA3MTEsIDEuNTA5OV0sIFs0OC45MjQ0LCAxLjUyOTFdLCBbNDkuMDcyNiwgMS41NDk1XSwgWzQ5LjA4ODgsIDEuNjE5N10sIFs0OS4wOTA1LCAxLjYyMjddLCBbNDkuMTAxMiwgMS42MjI3XSwgWzQ5LjEyMDcsIDEuNjQ1Nl0sIFs0OC4yOTEyLCAyLjQyMjhdLCBbNDguMzQ1NywgMy4wMzg4XSwgWzQ4LjcwNzIsIDMuNDY0MV0sIFs0OC42NDA3LCAzLjQ1MzZdLCBbNDguMzQyMywgMS45NzA2XSwgWzQ4LjY4MjksIDEuNjA5M10sIFs0OC4zMjM3LCAxLjk3NTFdLCBbNDguNDQwNywgMS45MzU1XSwgWzQ4LjM5MiwgMS45NzM2XSwgWzQ4LjY1MTIsIDEuNjI0NV0sIFs0OC40NDU2LCAxLjg1NzhdLCBbNDguMzA3NSwgMS45NTk5XSwgWzQ4LjYxMzQsIDEuNzA4NF0sIFs0OC4yODgsIDEuOTc1MV0sIFs0OS4xNzA5LCAxLjkzNDldLCBbNDkuMTc2OSwgMS44MTk0XSwgWzQ5LjA4MDcsIDIuODQ4N10sIFs0OC4yNzYsIDMuMDI1XSwgWzQ5LjE3NTMsIDEuODc2OF0sIFs0OC4yODg1LCAyLjQyMzNdLCBbNDguMzEzOCwgMi4yNzIyXSwgWzQ4Ljk4OTQsIDEuNDY3OF0sIFs0OS4xNzYxLCAyLjIxMjldLCBbNDkuMTQ5NSwgMi40MTg2XSwgWzQ4LjQ1NzksIDMuNDAwNl0sIFs0OC4xMzM4LCAyLjgyNDZdLCBbNDkuMTU3OCwgMi4zNzA0XSwgWzQ5LjE1ODcsIDIuMzcwNF0sIFs0OC42NDc0LCAzLjQ5NjRdLCBbNDguNDU3LCAzLjQwMThdLCBbNDkuMDcwNCwgMy4xNzU2XSwgWzQ5LjA5OTIsIDIuNjI0OF0sIFs0OS4wNzYyLCAyLjcyMDldLCBbNDguODUwMywgMy40NDk3XSwgWzQ5LjIwMjksIDIuMDY2OF0sIFs0OC42MTMsIDEuNzE1N10sIFs0OC42NDIyLCAzLjQ4Nl0sIFs0OC4zNzQsIDMuMzEwN10sIFs0OC4zMTQyLCAyLjQwNTddLCBbNDkuMTk4MywgMi4wOTAyXSwgWzQ4LjI5NDgsIDMuMDE4N10sIFs0OC44Mzc1LCAzLjQ2MjJdLCBbNDguNjg3MiwgMy40NzI5XSwgWzQ4LjY0NzYsIDMuNDkyOF0sIFs0OC42NTk2LCAxLjYwNzhdLCBbNDguNzMwMywgMS42MTA4XSwgWzQ4LjEzMSwgMi44MTQ3XSwgWzQ5LjE4MzYsIDEuNzk0Nl0sIFs0OS4xODczLCAyLjExMl0sIFs0OS4xOCwgMi4zMjM5XSwgWzQ4LjQ4NjMsIDMuMzk4MV0sIFs0OS4xNDk1LCAyLjQyXSwgWzQ5LjIwNzMsIDEuNzE0OF0sIFs0OC4xNDksIDIuNDc0N10sIFs0OS4wNzc5LCAyLjg4NDhdLCBbNDguODU5NywgMy40MzM2XSwgWzQ4LjEyOTcsIDIuODE4Ml0sIFs0OC4zMzI4LCAyLjI0MzVdLCBbNDkuMDcxOCwgMi43MTYxXSwgWzQ4LjkxNzIsIDMuMzE5Ml0sIFs0OC40NjEsIDMuMzk2OV0sIFs0OC4zMDg0LCAyLjQwOTVdLCBbNDkuMjA2OCwgMS43MjAxXSwgWzQ5LjA3NDksIDIuNzIwNV0sIFs0OS4xODM3LCAyLjMwNDRdLCBbNDguNDM4MSwgMy40MDJdLCBbNDguNjE3MiwgMS42OTA4XSwgWzQ4Ljg2MjcsIDEuNTc1XSwgWzQ5LjA5OTgsIDMuMTY0NF0sIFs0OC4zMDg4LCAyLjM1OThdLCBbNDguNTI1NCwgMS43NzYzXSwgWzQ5LjE1OTEsIDIuMzQ5MV0sIFs0OC40ODE0LCAzLjM5NDJdLCBbNDguNDE3MywgMy40MDM0XSwgWzQ4LjM5MjgsIDMuMzk3Ml0sIFs0OC4xOTY4LCAyLjk3MzhdLCBbNDguMTMxNCwgMi44MTM5XSwgWzQ4LjE2MDEsIDIuNzQwN10sIFs0OC4xODEyLCAyLjUwODldLCBbNDkuMTU1NywgMi4zNjc2XSwgWzQ4Ljc4MDIsIDMuNDMxNF0sIFs0OC40ODAzLCAzLjM4NzFdLCBbNDguMzcwMywgMy4zMzUzXSwgWzQ4LjczODYsIDEuNjIyNl0sIFs0OC4yNTQ5LCAyLjQzNDhdLCBbNDkuMTc3NSwgMS42Njc3XSwgWzQ5LjA3MDIsIDIuNjkxXSwgWzQ5LjE3ODgsIDIuMTY1MV0sIFs0OC40OTE5LCAzLjQyMDZdLCBbNDguNDM1MiwgMy40MDA3XSwgWzQ5LjE3MzIsIDIuMTk1NV0sIFs0OS4xNTYxLCAyLjM2OTNdLCBbNDguMzE0MywgMi4xNTg4XSwgWzQ4LjI5ODUsIDIuMTYwM10sIFs0OC40MTQyLCAzLjQxMzVdLCBbNDguMzgwNywgMy4yODg1XSwgWzQ4LjQ0NCwgMS44NjM5XSwgWzQ5LjEyOTUsIDEuNjUyOF0sIFs0OS4wODc5LCAyLjY3NzZdLCBbNDkuMDk1NSwgMi44MDQxXSwgWzQ5LjA2NDEsIDEuNDYyMl0sIFs0OS4wNzU0LCAxLjUxMjVdLCBbNDkuMDc4NSwgMS41MTRdLCBbNDkuMDczMiwgMS41Mzk5XSwgWzQ5LjA3MzgsIDEuNTQxNF0sIFs0OS4wNzI2LCAxLjU0OTFdLCBbNDkuMDcxNCwgMS41NjQzXSwgWzQ5LjA3ODcsIDEuNTc4XSwgWzQ5LjA4MTEsIDEuNTg3Ml0sIFs0OS4wODQ1LCAxLjYwMzldLCBbNDguMTcsIDIuOTM1XSwgWzQ5LjE3NjYsIDEuNjY2MV0sIFs0OC45NjA1LCAxLjQ5OTRdLCBbNDkuMDg2NywgMi41Nzk5XSwgWzQ4LjM2LCAzLjA3MzldLCBbNDguMzUzNSwgMy4wNDM1XSwgWzQ4LjY1MDUsIDEuNjM4M10sIFs0OC4zNjM4LCAxLjk4NzRdLCBbNDguNTU3NiwgMS43NzFdLCBbNDguNjEyNCwgMS43MDA4XSwgWzQ4LjYyNzYsIDEuNjU4Ml0sIFs0OC4zNDI0LCAxLjk3MDddLCBbNDguNjE2MSwgMS42ODU2XSwgWzQ4LjEzNzQsIDIuNjMwOF0sIFs0OC4yOTY3LCAxLjk3MDddLCBbNDguNDQ1NCwgMS44NjA5XSwgWzQ4Ljc0MTQsIDEuNjIzNF0sIFs0OS4wOTk2LCAxLjYyMTJdLCBbNDkuMTMzMiwgMS42NTc4XSwgWzQ5LjEzMDQsIDEuNjU2XSwgWzQ4LjEyNCwgMi40NTY3XSwgWzQ4LjIyNjMsIDIuNTE2Ml0sIFs0OS4wNjUsIDIuNzA1Ml0sIFs0OS4xODAzLCAyLjI5OThdLCBbNDguNDQ2NCwgMy40MDY2XSwgWzQ4LjM3NzcsIDMuMjk2OF0sIFs0OC4zNzc3LCAzLjE3MThdLCBbNDguNjQ0MiwgMy40NTU0XSwgWzQ4LjU1MDYsIDMuNDc5OF0sIFs0OS4xNzMzLCAxLjkyNjJdLCBbNDkuMTU2OSwgMi4zNjk4XSwgWzQ5LjAxOTksIDMuMTYzXSwgWzQ5LjE1MDksIDIuNDAxXSwgWzQ4Ljk1MDQsIDMuMjYwMV0sIFs0OC42ODQ5LCAzLjQ2MTNdLCBbNDkuMTgzMiwgMS43NDQ2XSwgWzQ4LjE1MDIsIDIuNzk4Nl0sIFs0OC4zMTM3LCAyLjE4MTNdLCBbNDguMjk5MSwgMi4wOTEyXSwgWzQ5LjE1OTksIDIuMjg2NF0sIFs0OC42NTM5LCAzLjQ1ODldLCBbNDguNjEyNSwgMy41Mzk2XSwgWzQ4LjE2LCAyLjQ5NTldLCBbNDguMzEzNiwgMi4zOTIxXSwgWzQ4LjM5ODMsIDEuOTc2NF0sIFs0OC42MTIxLCAxLjY4OThdLCBbNDkuMDY4MiwgMi43NzE4XSwgWzQ5LjA3ODUsIDIuOTM3OV0sIFs0OC4yMDM1LCAyLjk3MTZdLCBbNDguMTYyLCAyLjc1OTddLCBbNDguMTU4NSwgMi43NDZdLCBbNDguMjc1LCAyLjQxOThdLCBbNDguMzEwNSwgMi4yNjI3XSwgWzQ4LjMzMTEsIDIuMjM1M10sIFs0OS4xMTQ4LCAzLjA2ODFdLCBbNDkuMTAxOCwgMy4xNDQzXSwgWzQ4LjE3MTIsIDIuOTM1XSwgWzQ4LjE2NTgsIDIuODA4NV0sIFs0OS4xMDg3LCAzLjExNjldLCBbNDkuMTAyOSwgMy4xNDI4XSwgWzQ5LjAwNDgsIDMuMTk2MV0sIFs0OS4wODk1LCAzLjAwMDldLCBbNDkuMDksIDMuMDYzNF0sIFs0OS4xMTEsIDMuMDY0OV0sIFs0OC4zMTEsIDIuNDA4N10sIFs0OC40MzQzLCAzLjM5NzFdLCBbNDguOTY3LCAxLjQ5NDVdLCBbNDkuMDgzMywgMi44NDYyXSwgWzQ4Ljc0MzcsIDMuNDM2M10sIFs0OS4xMTI0LCAxLjYzMjddLCBbNDguMTMyLCAyLjU4NjFdLCBbNDguMzA3NiwgMi4xMDc1XSwgWzQ5LjE2MjcsIDIuMjI2M10sIFs0OS4xNTMzLCAyLjM2NV0sIFs0OC43ODQ0LCAzLjQ0MjJdLCBbNDguNDMyNywgMy4zOTY2XSwgWzQ4LjE1MTQsIDIuODYzNF0sIFs0OC40MTk5LCAxLjkzODVdLCBbNDguNjY2OSwgMS42MDE2XSwgWzQ4Ljc1MzcsIDEuNjE2OF0sIFs0OS4xOCwgMS44MDM1XSwgWzQ5LjE0OCwgMS42NTZdLCBbNDkuMTcxNSwgMi4yOTAyXSwgWzQ4Ljk0OTQsIDMuMjYxNV0sIFs0OC42NTAyLCAzLjQ1OF0sIFs0OC41MDUsIDMuNDI5MV0sIFs0OC4zMjkyLCAzLjA0MTldLCBbNDguMTMzMywgMi44MjU5XSwgWzQ4LjEzMDQsIDIuODA3NV0sIFs0OS4xNDY2LCAyLjQzNzJdLCBbNDguOTc3MSwgMy4yNDE1XSwgWzQ4Ljg2OTEsIDMuNDAxNF0sIFs0OC41MDE3LCAzLjQzMDVdLCBbNDguMzU0MSwgMy4xMDczXSwgWzQ5LjAzMDgsIDMuMTc2OV0sIFs0OC4xNjUyLCAyLjc5MDVdLCBbNDguMjM5LCAyLjQ4NDJdLCBbNDkuMTY2MywgMS44ODMyXSwgWzQ4Ljg4ODgsIDMuMzgzM10sIFs0OC43MTU3LCAzLjQ2NzJdLCBbNDguMzY4OSwgMy4xNDFdLCBbNDguMjQ5NiwgMy4wNDA0XSwgWzQ4LjIwNjksIDMuMDAwOF0sIFs0OC4zOTYzLCAzLjQxNTRdLCBbNDguODQ3MSwgMy40NDU4XSwgWzQ4LjgzNzIsIDMuNDYyN10sIFs0OC43NTU2LCAzLjM5ODddLCBbNDguNjcwNSwgMy40NDQzXSwgWzQ5LjA5OCwgMi42MjQ3XSwgWzQ5LjA2NTQsIDIuNjk2Ml0sIFs0OS4wODA0LCAyLjc3NDFdLCBbNDkuMTAzNSwgMi42MzA3XSwgWzQ5LjA5NDUsIDIuNjE0XSwgWzQ5LjA5MzcsIDIuNjYyOF0sIFs0OS4xMDcxLCAzLjEzMjVdLCBbNDkuMDAwNywgMy4yMDcyXSwgWzQ4LjgwMzcsIDMuNDExMV0sIFs0OC43ODIzLCAzLjQyNDhdLCBbNDguMzYwNSwgMy4wODE3XSwgWzQ5LjA4MTUsIDIuNTk3M10sIFs0OS4xNTkzLCAyLjM3MzJdLCBbNDguODAyNCwgMy40MjIyXSwgWzQ4LjM5NzQsIDMuNDE2Ml0sIFs0OC4zNjk2LCAzLjEyODFdLCBbNDguOTU0LCAxLjUwNjhdLCBbNDguMTYzOCwgMi45MzYzXSwgWzQ4LjI4NTksIDIuMDA4XSwgWzQ5LjE3MDEsIDEuOTM0OV0sIFs0OS4xNzM4LCAxLjY2NzddLCBbNDkuMTgwMiwgMi4zMjM1XSwgWzQ4Ljg2NCwgMy40MTI5XSwgWzQ4LjI3MzQsIDMuMDM3OV0sIFs0OC4xMjUsIDIuNjg3N10sIFs0OC4xMjU4LCAyLjQ1OTFdLCBbNDguMzEzLCAyLjI4MDZdLCBbNDguNjY4MiwgMS42MDEyXSwgWzQ5LjIxMDUsIDIuMDgwOV0sIFs0OS4wOTQ1LCAyLjU3MDRdLCBbNDguNDI2OSwgMy4zOTIxXSwgWzQ4LjM2NTIsIDMuMTk4Nl0sIFs0OC4xODMxLCAyLjUxXSwgWzQ4LjgwNDgsIDEuNTc3NF0sIFs0OC43ODIxLCAzLjQwODddLCBbNDkuMDc5NCwgMS41MTQzXSwgWzQ5LjA3OTgsIDEuNTE0M10sIFs0OS4wODM0LCAxLjUxMjhdLCBbNDkuMDcwMywgMS41Mjk1XSwgWzQ5LjA3MjYsIDEuNTM4N10sIFs0OS4wNzEzLCAxLjU2MzFdLCBbNDkuMDg0NSwgMS42MDEyXSwgWzQ5LjEwNjksIDEuNjI4Nl0sIFs0OS4xMTU1LCAxLjYzNzhdLCBbNDguMTQ2NywgMi43OTkzXSwgWzQ4LjE2MTgsIDIuNzU5N10sIFs0OS4xOTAyLCAxLjY3MDldLCBbNDkuMDc3NCwgMi44OTU0XSwgWzQ5LjIwNzEsIDIuMDc5OV0sIFs0OS4xNjM1LCAyLjM0MzZdLCBbNDguNTY5NCwgMS43NjUzXSwgWzQ4LjQwNDMsIDEuOTYyXSwgWzQ4LjUxNywgMS43Nzc1XSwgWzQ4LjU1NTYsIDEuNzc2XSwgWzQ4LjU5NjMsIDEuNzEwNV0sIFs0OC42MTQ5LCAxLjY3MzldLCBbNDguNDU5LCAxLjgzODVdLCBbNDguNjM5MiwgMS42NDhdLCBbNDkuMTA4MSwgMy4xMjI5XSwgWzQ5LjAyNTcsIDMuMTYyNV0sIFs0OC4xMjkyLCAyLjQ2OTJdLCBbNDguMzA4MiwgMi4yOTU0XSwgWzQ4LjY1MzUsIDEuNjE0M10sIFs0OS4xMjQ3LCAxLjY0NzFdLCBbNDguODk2NCwgMy4zNjk0XSwgWzQ4LjQ4MzcsIDMuMzk4NV0sIFs0OC40ODM5LCAzLjM5N10sIFs0OC40MzU1LCAzLjRdLCBbNDkuMTc0NCwgMS44MTEzXSwgWzQ4LjIwNzEsIDIuOTk2OV0sIFs0OC4xMjUyLCAyLjY5NjZdLCBbNDkuMTM5MywgMi40NTQzXSwgWzQ4LjY0MDUsIDMuNTI1M10sIFs0OC42MTYyLCAxLjY4MzhdLCBbNDkuMTg4NywgMS42Njk5XSwgWzQ4Ljk4MTksIDMuMjI3MV0sIFs0OC40ODI3LCAzLjM5MzJdLCBbNDguOTE2NywgMS41NDAzXSwgWzQ4Ljk1MzYsIDEuNTA1M10sIFs0OS4xNzQxLCAxLjg3MzVdLCBbNDguODYzNywgMy40MDUzXSwgWzQ4LjMwMDcsIDMuMDI3M10sIFs0OC42MTMsIDEuNzA1NV0sIFs0OS4xMTQ1LCAzLjA3ODVdLCBbNDguMjcyMSwgMi40MTc5XSwgWzQ5LjE3NDMsIDIuMjA0NV0sIFs0OC4yNjY2LCAyLjQyXSwgWzQ4LjM0MDYsIDIuMjEyNl0sIFs0OS4xNTQ2LCAyLjM2NjZdLCBbNDguODQyNiwgMy40NDg0XSwgWzQ4Ljg0MjQsIDMuNDQ5OV0sIFs0OC43MTI5LCAxLjU5XSwgWzQ4LjE2NzEsIDIuOTM1MV0sIFs0OC4zMjAxLCAyLjQwMTVdLCBbNDguNjQ5NiwgMS42MjZdLCBbNDguNzM1NiwgMS42MTUzXSwgWzQ5LjA5MDIsIDIuNjc0NF0sIFs0OS4wOTI3LCAyLjU3NjhdLCBbNDguOTQ2NywgMy4yNjE1XSwgWzQ4Ljg1MTYsIDMuNDQ5XSwgWzQ4LjQ2NjUsIDMuNDAwMl0sIFs0OC4xOTI1LCAyLjk1NTRdLCBbNDguMTY2MiwgMi43NzcxXSwgWzQ4LjM3MTgsIDEuOTc5OV0sIFs0OC4zNzI1LCAxLjk4MTRdLCBbNDkuMDkzMSwgMi41NzI3XSwgWzQ4LjQ4NzEsIDMuNDEwNl0sIFs0OC4yOTM0LCAzLjAyMDRdLCBbNDguNjczOSwgMy40NDU3XSwgWzQ5LjExNjQsIDMuMDcwMV0sIFs0OS4wMzQsIDMuMTc5OV0sIFs0OC4yNTM3LCAyLjQzOTldLCBbNDkuMTM0NywgMi40NjldLCBbNDguNDUzOCwgMy40MDUyXSwgWzQ5LjA4NjcsIDMuMTU2OV0sIFs0OC4yMDYyLCAyLjk5NTVdLCBbNDguMTM5OCwgMi44NDYxXSwgWzQ4LjEyODEsIDIuNDgzM10sIFs0OC4xNTUsIDIuNDc4Nl0sIFs0OC42NjM4LCAxLjYwMjVdLCBbNDkuMjExNSwgMS42NzQ5XSwgWzQ5LjEwMzcsIDIuNTA3N10sIFs0OS4xMDMsIDIuNTU4XSwgWzQ4LjM3NTcsIDMuMTc5M10sIFs0OC42NjIxLCAzLjQ0Nl0sIFs0OC4zMjIxLCAzLjAyOTldLCBbNDguMTY0MywgMi43Mzc3XSwgWzQ4LjM3MjYsIDEuOTgwNF0sIFs0OS4wODUyLCAyLjk3MjNdLCBbNDkuMTk1OSwgMi4wNDddLCBbNDguMzcxMywgMy4xNl0sIFs0OC45MTQsIDMuMzI0Nl0sIFs0OC44Nzk3LCAzLjM4MTFdLCBbNDguOTA5NCwgMy4zMzY4XSwgWzQ4Ljc4NDMsIDMuNDE5Ml0sIFs0OC41MzE3LCAzLjQ2MDNdLCBbNDguMTMwOCwgMi44MTI4XSwgWzQ4LjI4OTgsIDIuNDIyNl0sIFs0OC4zMDcxLCAyLjE1NDRdLCBbNDkuMTcyLCAxLjg2NzRdLCBbNDkuMDg5LCAyLjk3MTRdLCBbNDkuMTE5LCAyLjU0NzZdLCBbNDguNjM2MSwgMy40NjE3XSwgWzQ4LjU0NTUsIDMuNDc5OV0sIFs0OC4xNzg4LCAyLjkzNDddLCBbNDguMTQxMSwgMi41NjU3XSwgWzQ4LjMyNTMsIDIuMTgzMl0sIFs0OC40MTI3LCAxLjkyNTldLCBbNDkuMjM3NCwgMS43MTMyXSwgWzQ5LjE4MzEsIDEuNzg2NF0sIFs0OC45MTYxLCAzLjM0OTVdLCBbNDguNjA0NiwgMy41MDM0XSwgWzQ4LjM5NjMsIDMuMzkwNl0sIFs0OC4xOTMsIDIuNTEzXSwgWzQ5LjEyODIsIDEuNjUyOF0sIFs0OS4xNzk1LCAxLjgyNjZdLCBbNDguMzY2NSwgMy4xOTgzXSwgWzQ4LjkxOTYsIDEuNTM5OV0sIFs0OS4wNTIxLCAxLjQ3OTVdLCBbNDkuMDU0NCwgMS40ODg3XSwgWzQ4LjgwODksIDEuNTc5NF0sIFs0OS4wNzg5LCAxLjUxNzZdLCBbNDkuMDY5OCwgMS41MjY4XSwgWzQ5LjA3LCAxLjUzMTNdLCBbNDkuMDgyLCAxLjYxNTJdLCBbNDkuMTAyOCwgMS42Mjc0XSwgWzQ4LjMxMDEsIDIuNDA5MV0sIFs0OS4wNzk5LCAyLjU5MDZdLCBbNDkuMTk5LCAyLjA1NF0sIFs0OS4xODY1LCAyLjExMzNdLCBbNDguMzEyMSwgMS45NjU5XSwgWzQ4LjQ5NjgsIDEuNzkwNl0sIFs0OC41NzQ1LCAxLjc1NF0sIFs0OC42MTE3LCAxLjY4ODVdLCBbNDguNzA5NywgMS41OTM5XSwgWzQ4LjM5OTQsIDEuOTc2Nl0sIFs0OC41MDkyLCAxLjc3NjldLCBbNDguNDcxNSwgMS44MDEzXSwgWzQ4LjUwNTEsIDEuNzgxNF0sIFs0OC41MjI0LCAxLjc3NjldLCBbNDguMzg4NCwgMS45NzI1XSwgWzQ5LjE4NDgsIDEuNzk1XSwgWzQ5LjE4OCwgMi4wMjg1XSwgWzQ4LjU4OTQsIDMuNTA2Nl0sIFs0OC40ODEsIDMuMzkwOF0sIFs0OC4zMjAyLCAyLjI0MDNdLCBbNDguNzI1NywgMS42MDVdLCBbNDkuMTU4MSwgMi4yNzM5XSwgWzQ5LjAyNjksIDMuMTY0NV0sIFs0OC43MiwgMS41OTY0XSwgWzQ5LjA4MTcsIDIuNTk2XSwgWzQ4Ljg2MzgsIDMuNDA5NV0sIFs0OC40NTI1LCAzLjQwNjVdLCBbNDguMzUwMywgMy4xMDE1XSwgWzQ4LjIyMjYsIDMuMDEzMV0sIFs0OS4xMTc1LCAzLjA3MDVdLCBbNDguMTY0NCwgMi43NDM4XSwgWzQ5LjE1NzgsIDEuNjYxXSwgWzQ5LjIxNzMsIDEuNjg1NF0sIFs0OC43NTU1LCAzLjQzM10sIFs0OC42NDYsIDMuNTI4OV0sIFs0OC4zNDE3LCAzLjAzOTZdLCBbNDguMzM5NCwgMy4wMzY2XSwgWzQ4LjU1NDcsIDMuNDc1NV0sIFs0OC4yOTU0LCAyLjA1MzddLCBbNDguNzA2MiwgMS41ODc3XSwgWzQ4Ljk3OTQsIDEuNDk4NF0sIFs0OS4wOTE1LCAyLjY3MTJdLCBbNDkuMTkyNSwgMi4wMzg1XSwgWzQ4LjMxOTYsIDIuMTg0MV0sIFs0OC4xNjM0LCAyLjc0NjZdLCBbNDguMTI4OCwgMi43MTNdLCBbNDguMTgwNywgMi41MDg4XSwgWzQ4LjIwNjYsIDIuNTIxXSwgWzQ4LjMwODIsIDIuNDExMl0sIFs0OC4zMTMxLCAyLjQwNjddLCBbNDguMzM2MywgMi4xOTc4XSwgWzQ5LjA2NzUsIDMuMTc4M10sIFs0OC4xMzE0LCAyLjgxMzZdLCBbNDkuMTE3MiwgMy4wNzMyXSwgWzQ4LjE1NjQsIDIuNTA2M10sIFs0OS4xMDYyLCAzLjA2MjVdLCBbNDkuMTAwNiwgMy4xNDk0XSwgWzQ5LjAwMjMsIDMuMjAyN10sIFs0OS4wOTk1LCAzLjE2MTZdLCBbNDguMTMzMywgMi44MjY1XSwgWzQ5LjIwNTgsIDIuMDc5NV0sIFs0OC41ODc3LCAzLjQ5MTNdLCBbNDguODY0NiwgMS41NTldLCBbNDguODcyOCwgMy4zODA5XSwgWzQ5LjE5MjMsIDEuNjcxMV0sIFs0OS4wODA4LCAyLjc3MzZdLCBbNDguMjk5NSwgMy4wMjYxXSwgWzQ4LjYxMTUsIDEuNjg5MV0sIFs0OS4xODE3LCAxLjc4OTVdLCBbNDguMTY3NCwgMi43ODFdLCBbNDguNjYyNCwgMS42MDMxXSwgWzQ5LjA3MDQsIDIuODY5NF0sIFs0OS4wODMsIDIuOTA2XSwgWzQ4Ljg5MjcsIDMuMzY5Nl0sIFs0OC4yNTA5LCAzLjAzNTldLCBbNDguOTA1NywgMy4zNzE3XSwgWzQ4LjYyMDMsIDEuNjU4NV0sIFs0OC44OTMzLCAxLjU1MzRdLCBbNDkuMDc4NCwgMi45NDE3XSwgWzQ5LjE5MDYsIDIuMTM1Ml0sIFs0OC45NjIxLCAzLjI1NTJdLCBbNDguNjM3MiwgMy40NTM0XSwgWzQ5LjA4NjQsIDMuMDA2MV0sIFs0OS4wNDE1LCAzLjE4MjldLCBbNDguOTU4MiwgMy4yNTY3XSwgWzQ4Ljg3MjEsIDMuMzgzMl0sIFs0OC42MzUzLCAzLjUxODldLCBbNDguNTMwOSwgMy40MjldLCBbNDguNDg4NCwgMy40MDQ2XSwgWzQ4LjQyOTEsIDMuMzk1NF0sIFs0OC40MDczLCAzLjQxOThdLCBbNDguMzkwMiwgMy40MDYxXSwgWzQ4LjM3ODQsIDMuMjk5M10sIFs0OC4yNzA3LCAzLjA0NDhdLCBbNDkuMTA3MSwgMi42MzY2XSwgWzQ5LjA4NzUsIDIuOTQ3Nl0sIFs0OC45NzMyLCAzLjI1MTFdLCBbNDkuMDkxOSwgMi43OTUyXSwgWzQ5LjA4MzIsIDIuOTA2NV0sIFs0OS4wODksIDIuOTcwNV0sIFs0OC4zMDA1LCAyLjQxOTNdLCBbNDguMjA3NiwgMi45ODQ4XSwgWzQ4LjE2MTYsIDIuNzcxNF0sIFs0OC4xNDA2LCAyLjUzODFdLCBbNDguMjcwNiwgMi40MTkzXSwgWzQ4LjcwODgsIDEuNTkxOF0sIFs0OC43MTE5LCAxLjU4ODhdLCBbNDguMzMzNywgMS45NzY1XSwgWzQ5LjE4MTIsIDEuNzQxNV0sIFs0OS4xNzQ1LCAxLjc1NTJdLCBbNDguMTMyMSwgMi41Nzc2XSwgWzQ4LjI2MDQsIDIuNDIzNV0sIFs0OS4xNTksIDIuMzc2NF0sIFs0OC40ODIsIDMuMzkzM10sIFs0OC45OTc5LCAzLjIwODhdLCBbNDguODY0MywgMy40MDRdLCBbNDguNzg0LCAzLjQzNTldLCBbNDguNzgyLCAzLjQyNTRdLCBbNDkuMTc4NSwgMS44Mjc1XSwgWzQ5LjEwODYsIDMuMDk5OF0sIFs0OC43NjA1LCAxLjYwMjddLCBbNDkuMDcxMSwgMi45ODY1XSwgWzQ5LjEwMiwgMi41MjAxXSwgWzQ4Ljg5NDksIDMuMzY5Ml0sIFs0OC43NTE0LCAzLjQzNjRdLCBbNDguNDE0MiwgMy40MDldLCBbNDkuMTExNywgMy4wNjYxXSwgWzQ4LjE5MTQsIDIuOTU4XSwgWzQ4LjE1NjcsIDIuNzQ3OF0sIFs0OC4zMzI1LCAyLjE4OThdLCBbNDkuMDc2LCAyLjk3NDldLCBbNDguOTQ1NSwgMy4yNjA4XSwgWzQ4LjQ1MzMsIDMuNDA1N10sIFs0OC4zNjQyLCAzLjIwNDVdLCBbNDkuMDczOSwgMS41MTc5XSwgWzQ5LjA2OTgsIDEuNTI3MV0sIFs0OS4xMzc3LCAxLjY1NjZdLCBbNDkuMTU0LCAxLjY2NDNdLCBbNDkuMTY1NSwgMS42NjQzXSwgWzQ5LjEwMDcsIDMuMDU2XSwgWzQ5LjE2NjIsIDEuNjY1OF0sIFs0OC4xNTgyLCAyLjgwN10sIFs0OC4yMTQ0LCAyLjUxNzRdLCBbNDguMjgzOSwgMi40MTk4XSwgWzQ5LjExMTUsIDEuNjMyOF0sIFs0OC41NDk0LCAzLjQ4NF0sIFs0OC40MzU4LCAzLjQwMTZdLCBbNDguNDMzNSwgMy4zOTcxXSwgWzQ4LjQwMjMsIDEuOTY3OV0sIFs0OC41Mzk1LCAxLjc4MTldLCBbNDguNDM4NSwgMS45MDM5XSwgWzQ4LjM4MTYsIDEuOTY2NF0sIFs0OC40NDAzLCAxLjg5MzJdLCBbNDguNTM5LCAxLjc4MDRdLCBbNDguMzc0OCwgMS45ODAxXSwgWzQ4LjY5NiwgMS41ODIyXSwgWzQ4LjU3NjEsIDEuNzE3OV0sIFs0OC42NTEzLCAxLjY0MzJdLCBbNDguMTQ1LCAyLjQ2Nl0sIFs0OS4xOTYyLCAxLjY3NDVdLCBbNDguNDMzMSwgMy4zOTddLCBbNDguNDM5MiwgMS45MDE0XSwgWzQ4LjkyMTksIDEuNTE0Ml0sIFs0OS4xNzY4LCAxLjY2NjRdLCBbNDkuMDI5MSwgMy4xNzUzXSwgWzQ4LjE2NTQsIDIuNzg5MV0sIFs0OC4xNjUsIDIuNzM3M10sIFs0OC4yNTIxLCAyLjQ1OTddLCBbNDguMzIxNiwgMi4zMDU4XSwgWzQ4LjkwNTYsIDMuMzcxNV0sIFs0OC43NTY1LCAzLjQyNjVdLCBbNDguNjQ3MiwgMy40OThdLCBbNDguMTMwNCwgMi44MTA5XSwgWzQ4LjE2NjgsIDIuNTE2OF0sIFs0OC4zMjA1LCAyLjMwNDldLCBbNDkuMTY4LCAxLjY2ODJdLCBbNDkuMTkyMSwgMi4wMzgyXSwgWzQ4Ljg2NTQsIDMuNDAxOF0sIFs0OC44NTg5LCAzLjQ0NzZdLCBbNDguODIzOCwgMS41ODYyXSwgWzQ5LjE1NzMsIDEuNjYwN10sIFs0OS4xODE1LCAxLjk4MjRdLCBbNDkuMTc3OCwgMi4zMjZdLCBbNDguOTY2OCwgMy4yNTQ1XSwgWzQ4LjM1OTksIDMuMDgyNF0sIFs0OS4xODU4LCAxLjc4NDhdLCBbNDkuMTc5MSwgMS44MTA3XSwgWzQ5LjE3MjQsIDEuOTIyXSwgWzQ4LjEyNDQsIDIuNzA2MV0sIFs0OC4xNjk2LCAyLjUxNDFdLCBbNDguMjUzLCAyLjQ2MjNdLCBbNDguMzE1NywgMi4zMDA3XSwgWzQ4LjQwNDEsIDEuOTMwNl0sIFs0OC45ODE5LCAzLjIyODVdLCBbNDguNDg0MywgMy4zOTQ2XSwgWzQ4LjM2NzIsIDMuMTE4N10sIFs0OC4yODgzLCAyLjAyNDVdLCBbNDguMTc0OCwgMi41MTU1XSwgWzQ5LjExNjgsIDEuNjQwMV0sIFs0OS4xMDI3LCAyLjUxN10sIFs0OC41MzA4LCAzLjQyNzNdLCBbNDguNDM5OSwgMS44OTc0XSwgWzQ5LjE3NDIsIDEuOTMxNV0sIFs0OC4yODgsIDIuNDIzXSwgWzQ4LjMzMDYsIDIuMjQxN10sIFs0OC4zMTQ5LCAyLjE1NDhdLCBbNDguOTUyNywgMS41MDExXSwgWzQ5LjE1NTIsIDIuMzY2N10sIFs0OC44MjUsIDMuNDg1XSwgWzQ4LjQ5NTUsIDMuNDM0N10sIFs0OS4xMjc3LCAxLjY1MjNdLCBbNDguMjg5MiwgMi4wMjVdLCBbNDguNDcxNywgMS44MDEzXSwgWzQ4Ljk3OTcsIDEuNDc5Nl0sIFs0OC4yOTAyLCAyLjA1MTVdLCBbNDguODYzMiwgMy40MDkxXSwgWzQ4LjcxNzksIDEuNTk1XSwgWzQ5LjE3OTgsIDEuNzQyN10sIFs0OC4xMzY5LCAyLjcyMDVdLCBbNDguMzEyLCAyLjI3MjNdLCBbNDguMzE1OSwgMi4xNzE3XSwgWzQ4Ljg1OTYsIDMuNDM1Nl0sIFs0OC42NDY1LCAzLjUzMzJdLCBbNDguNDg2LCAzLjQwOTddLCBbNDguMjA4OSwgMi45ODkzXSwgWzQ4LjE1LCAyLjgwMDNdLCBbNDguMjU0NywgMi40NDUyXSwgWzQ4Ljc4MzksIDMuNDE3MV0sIFs0OC4xOTg1LCAyLjk3MzhdLCBbNDguMTk3NiwgMi45NzM4XSwgWzQ5LjE3MDcsIDEuOTQxNV0sIFs0OS4wODMsIDIuODMzNl0sIFs0OS4xNTM1LCAyLjI0OTldLCBbNDguODg4OCwgMy4zODExXSwgWzQ4Ljg2MDMsIDMuNDQyMV0sIFs0OC42NDM3LCAzLjUxMDZdLCBbNDkuMSwgMi41NTc3XSwgWzQ4LjI5NTQsIDEuOTgyNF0sIFs0OC4zMDc1LCAyLjEwNTZdLCBbNDguMTIyMiwgMi42NjM0XSwgWzQ4LjEyODYsIDIuNDcyOV0sIFs0OS4wODA3LCAyLjU4M10sIFs0OS4xNTE1LCAyLjIzMjFdLCBbNDkuMTUyNSwgMi4zNjMxXSwgWzQ4LjM3NzQsIDMuMTc1MV0sIFs0OC45NTA5LCAzLjI1OV0sIFs0OS4wNjEsIDIuNzQ0OV0sIFs0OC44OTg3LCAxLjU1XSwgWzQ4LjMxMzgsIDIuMTgxNV0sIFs0OS4xOTQxLCAxLjcyNjldLCBbNDkuMTcwNywgMS45NDhdLCBbNDkuMTY0MSwgMi4xNjk4XSwgWzQ4LjI2NzgsIDMuMDQ2Ml0sIFs0OC45MDI5LCAzLjM3MDldLCBbNDguODg4NywgMy4zNzk5XSwgWzQ4Ljg3NDcsIDMuNDA1OF0sIFs0OC44MzY1LCAzLjQ5MTJdLCBbNDkuMTA3MiwgMy4xMzE2XSwgWzQ4LjE0MTYsIDIuODQ5OV0sIFs0OC4xMzIxLCAyLjU5MDddLCBbNDkuMjIxNiwgMS42OTA5XSwgWzQ4Ljg3NiwgMS41NDg3XSwgWzQ4LjUwMjQsIDMuNDMwMV0sIFs0OC40MTc2LCAzLjQwODddLCBbNDkuMDM0OCwgMS40NThdLCBbNDkuMDU3OCwgMS40NTY1XSwgWzQ5LjA3MzcsIDEuNTExM10sIFs0OS4wODM4LCAxLjUxMTNdLCBbNDkuMDc2OCwgMS41NzIzXSwgWzQ5LjA3NjksIDEuNTcyM10sIFs0OS4xMTcxLCAzLjA3MjddLCBbNDkuMDc4NiwgMS42MTA0XSwgWzQ4LjE1NjQsIDIuODY4XSwgWzQ4LjEzNzYsIDIuODQwNl0sIFs0OC4xMzQsIDIuNTczN10sIFs0OC4xMjUxLCAyLjUyMTldLCBbNDkuMTQ5NiwgMS42NTg3XSwgWzQ5LjE3NjEsIDIuMjk3OF0sIFs0OC44OTcyLCAzLjM2OTddLCBbNDguODkwMSwgMy4zNzcyXSwgWzQ4LjQ3OTQsIDEuNzk0Ml0sIFs0OC42Mjk0LCAxLjY1N10sIFs0OC42NDA0LCAxLjY0NDhdLCBbNDguNDQwMSwgMS44ODQxXSwgWzQ4LjQ3NzksIDEuNzk1N10sIFs0OC41NzI1LCAxLjc0MzldLCBbNDguNjk2NCwgMS41ODIzXSwgWzQ4LjMyNjMsIDEuOTc4N10sIFs0OC40MDYsIDEuOTI4NF0sIFs0OC40NCwgMS44ODQxXSwgWzQ5LjAwNjQsIDMuMTk2MV0sIFs0OC4zMzI2LCAyLjIyNjddLCBbNDkuMDgzNywgMi45NDQ4XSwgWzQ4LjY0NjUsIDMuNTAwNl0sIFs0OC40MTY1LCAzLjQxOTddLCBbNDguMjU0MywgMi40NjU5XSwgWzQ4LjMwNzksIDIuMjYzMl0sIFs0OC43NjE4LCAxLjU4MjFdLCBbNDkuMTc0MywgMi4yMDIyXSwgWzQ4Ljk0NDgsIDMuMjYwMl0sIFs0OC44MDM0LCAzLjQzNTVdLCBbNDguNzU1LCAzLjM5OTFdLCBbNDguNTM4LCAzLjQ2OTFdLCBbNDkuMDA3LCAzLjE5NjRdLCBbNDguMTkzOCwgMi45Njk1XSwgWzQ4LjE0NDIsIDIuNzQ4NF0sIFs0OC4xOTA0LCAyLjUxMzhdLCBbNDkuMDY3LCAyLjczMzJdLCBbNDkuMDc5MSwgMi44NDldLCBbNDguOTM4MywgMy4yNjc4XSwgWzQ4LjY0MzQsIDMuNTEzMV0sIFs0OS4wODA0LCAzLjE1ODldLCBbNDguMTkxMywgMi45NTg3XSwgWzQ4LjEyNDgsIDIuNjc4MV0sIFs0OC4zMTk2LCAyLjQwMzddLCBbNDkuMDk0NywgMi41NzI1XSwgWzQ5LjE2NzksIDIuMjg3OV0sIFs0OS4xMTk0LCAyLjUzNDldLCBbNDguNiwgMy41MDc3XSwgWzQ4LjY0OTYsIDEuNjI1OF0sIFs0OC44NjY1LCAxLjU2NDhdLCBbNDkuMDczNiwgMi43ODRdLCBbNDkuMTk0OCwgMi4wNDNdLCBbNDguMTkyOSwgMi45Njc0XSwgWzQ4LjE2NzYsIDIuNzk4M10sIFs0OC4xNDcsIDIuNzU1NV0sIFs0OC4xMjUxLCAyLjUyMDddLCBbNDguMTQzNywgMi40NjQ0XSwgWzQ4LjE2NzIsIDIuNTE2Ml0sIFs0OC4zMTk0LCAyLjQwMzRdLCBbNDguMzMxNiwgMi4zMjg3XSwgWzQ5LjA4NzcsIDMuMDU2Ml0sIFs0OS4wOTg0LCAzLjE2NDVdLCBbNDkuMDk5NCwgMy4wNTYyXSwgWzQ5LjEwNywgMy4xMzI0XSwgWzQ5LjA0MTcsIDMuMTgyN10sIFs0OS4xMDY4LCAzLjEzODZdLCBbNDkuMTA4OCwgMy4xMTg3XSwgWzQ5LjExMTYsIDMuMDY1NF0sIFs0OC40OCwgMy4zODY0XSwgWzQ5LjE3NzMsIDEuODMxM10sIFs0OC44ODk3LCAzLjM3ODVdLCBbNDguODkxOSwgMy4zNzM4XSwgWzQ5LjExNTgsIDMuMDY5Ml0sIFs0OC4zMzA0LCAyLjI0MTddLCBbNDguMzc4LCAzLjI2OF0sIFs0OC4zMTc4LCAyLjE4MzddLCBbNDkuMDg4NywgMS42MTkzXSwgWzQ5LjA3OTcsIDIuOTI5Ml0sIFs0OS4xNTE2LCAyLjI0XSwgWzQ4LjYxMDksIDMuNTM1M10sIFs0OC45MTQ2LCAzLjM3MzddLCBbNDguODU4OCwgMy40NDg0XSwgWzQ4Ljg0MiwgMy40NTE0XSwgWzQ4Ljc4OTksIDMuNDQzN10sIFs0OC43MzgyLCAzLjQ1NTldLCBbNDkuMTEyNSwgMy4wODVdLCBbNDguMTc3OSwgMi41MDk4XSwgWzQ5LjE4NzUsIDIuMTE3OV0sIFs0OS4xMzkxLCAyLjQ2MjVdLCBbNDguODk2NywgMy4zNjk2XSwgWzQ4Ljg5MTksIDMuMzc0M10sIFs0OC44NTY1LCAzLjQ1Ml0sIFs0OC4yNTI0LCAzLjA0NjRdLCBbNDkuMTI0MSwgMi40OTI5XSwgWzQ4LjIwNywgMi45OThdLCBbNDguMTI3LCAyLjQ4OV0sIFs0OS4wODU5LCAyLjYwMzNdLCBbNDkuMDc4MywgMi45MjVdLCBbNDguOTM3OCwgMy4yNjg5XSwgWzQ4Ljg0MTgsIDMuNDU2NF0sIFs0OS4xNzE4LCAxLjg2NzddLCBbNDguMTg3MiwgMi45NDYxXSwgWzQ4Ljg5OSwgMS41NDg2XSwgWzQ4LjkyNSwgMS41MjQyXSwgWzQ4LjQ2MDEsIDMuNDAwNV0sIFs0OC4zMTI4LCAzLjAyMV0sIFs0OC44OTE5LCAzLjM3NDZdLCBbNDguODAzOSwgMy40MTQyXSwgWzQ4LjQ5MTcsIDMuNDIwNF0sIFs0OC40ODA3LCAzLjM4OThdLCBbNDguMzcxMiwgMy4zNTY0XSwgWzQ4LjMxNDUsIDMuMDI0XSwgWzQ4Ljk0MTYsIDMuMzA5MV0sIFs0OC44NzUyLCAzLjM5Nl0sIFs0OS4wNzAyLCAyLjc3NzRdLCBbNDkuMTAyNiwgMi42Mjk1XSwgWzQ5LjA3MzgsIDIuODc2NV0sIFs0OC4zMjkzLCAyLjIzMDFdLCBbNDguMzA3MywgMi4xMDk4XSwgWzQ5LjA3NSwgMi44NTM2XSwgWzQ4LjE1NzEsIDIuODc2NV0sIFs0OC4zMjMyLCAxLjk3NDVdLCBbNDkuMDk1MSwgMi42MjA1XSwgWzQ5LjA5OTMsIDIuNjUzOV0sIFs0OC42MjQ4LCAzLjU0OThdLCBbNDguNjUwMiwgMS42MjM4XSwgWzQ5LjEwMTMsIDMuMTQ2OF0sIFs0OC4xNjMsIDIuNzU4OV0sIFs0OC4zMjg3LCAyLjMxMjRdLCBbNDguODYwNSwgMS41ODRdLCBbNDkuMTA1NSwgMi40OTM3XSwgWzQ4Ljg3MTQsIDMuMzg0MV0sIFs0OC44NzMxLCAzLjQwNTVdLCBbNDguMjg2NSwgMi4wMzY5XSwgWzQ4LjYxMzYsIDEuNjgzN10sIFs0OC43NzU4LCAxLjU4MzFdLCBbNDguNDQyLCAxLjg2NF0sIFs0OC43OTAxLCAxLjU3NTldLCBbNDguMjc4NCwgMi40MTc4XSwgWzQ4LjMxMjksIDIuMjgwNl0sIFs0OC42MTQ2LCAxLjY5MjZdLCBbNDguNDE1MiwgMy40MTY1XSwgWzQ4LjkwOTMsIDEuNTQyMl0sIFs0OC45Nzg0LCAxLjQ4MTJdLCBbNDkuMTgzNiwgMS45NzQyXSwgWzQ4LjMyNDMsIDIuMTgyMV0sIFs0OC45OTM1LCAxLjQ2OTFdLCBbNDkuMDg0MSwgMi41OTk5XSwgWzQ4Ljg5MzMsIDMuMzY5MV0sIFs0OC44Nzk4LCAzLjM4MTNdLCBbNDguOTE4NCwgMy4zMTczXSwgWzQ4LjQ5MDEsIDMuNDE2NF0sIFs0OC40ODgyLCAzLjQwNDJdLCBbNDguNDg1OSwgMy40MDI3XSwgWzQ5LjA1NDUsIDEuNDc1XSwgWzQ5LjA3MTgsIDEuNTEwMV0sIFs0OS4wNzQxLCAxLjUxMTZdLCBbNDkuMDgyNSwgMS41MTAxXSwgWzQ4LjE2MjEsIDIuNzUwNV0sIFs0OS4wNjQ0LCAyLjY5ODddLCBbNDkuMTgyNCwgMi4xNTYxXSwgWzQ4LjM3NzIsIDMuMjc2Nl0sIFs0OC45NDYyLCAzLjI2MTRdLCBbNDguODc1OSwgMy4zOTg2XSwgWzQ4LjYxNDEsIDEuNzEwOF0sIFs0OC4zMTg2LCAxLjk4MDddLCBbNDguNDM5NywgMS44ODYxXSwgWzQ4LjYwNjcsIDEuNzE4NV0sIFs0OC42MDk5LCAxLjcxODVdLCBbNDguNTc4LCAxLjcwOTNdLCBbNDguNDA2LCAxLjk0NDFdLCBbNDguNjE5OCwgMS42ODQ5XSwgWzQ4LjcwNTIsIDEuNTg1OF0sIFs0OC4zOTUxLCAxLjk3M10sIFs0OC4yNTQ4LCAyLjQzNzFdLCBbNDkuMTAwMiwgMi42NDZdLCBbNDkuMTY1MSwgMi4zNDFdLCBbNDguNjIwOSwgMy41NTU0XSwgWzQ4LjQxNjksIDMuNDA0NV0sIFs0OC43OTQ5LCAzLjQ0MjZdLCBbNDguNzc5OCwgMy40Mjc0XSwgWzQ5LjE1MjgsIDEuNjYzNF0sIFs0OS4wMDUyLCAzLjE5OTddLCBbNDguMTI4NywgMi40NzM2XSwgWzQ5LjIxMzMsIDEuNjc3NF0sIFs0OS4xNjUsIDEuODg5M10sIFs0OC4yOTY0LCAxLjk2OTJdLCBbNDkuMTUyMiwgMi40MDk0XSwgWzQ5LjA2NzYsIDIuNjg5OV0sIFs0OC43MzY4LCAzLjQ1MDldLCBbNDkuMTIyMSwgMi41NDI3XSwgWzQ4LjkxNjIsIDMuMzcyOV0sIFs0OC40ODcxLCAzLjQwOF0sIFs0OC4yOTAyLCAzLjAyNTFdLCBbNDkuMjA3MSwgMS42NzI5XSwgWzQ4LjMxMjMsIDIuNDA2OV0sIFs0OC40MzQ0LCAxLjkzNzddLCBbNDkuMDcyMiwgMS41NDgyXSwgWzQ5LjIwNjksIDIuMDg2N10sIFs0OC42NTY3LCAzLjQ1NDJdLCBbNDguNjQ0OSwgMy40ODc4XSwgWzQ5LjA5MDUsIDIuNzkzXSwgWzQ5LjE5NjgsIDIuMDkxOF0sIFs0OC45MDg4LCAzLjM3NjRdLCBbNDguODAxLCAzLjQyMzVdLCBbNDguOTI3NiwgMS41MDczXSwgWzQ5LjA5NjgsIDMuMTYzOV0sIFs0OS4wODY0LCAzLjE1NjJdLCBbNDguMzM4NSwgMi4yMTJdLCBbNDkuMTM0NywgMS42NTgzXSwgWzQ5LjE1NTYsIDIuMzUyNF0sIFs0OC40NTQsIDMuNDA0NF0sIFs0OC45NDU5LCAzLjI2MV0sIFs0OC43OTE4LCAzLjQ0MjVdLCBbNDkuMTc2MiwgMS42NjYzXSwgWzQ4Ljg2MywgMy40MDg4XSwgWzQ4LjcxODYsIDMuNDY4MV0sIFs0OC4yODg0LCAxLjk3MjddLCBbNDkuMDg4MSwgMy4wNTkxXSwgWzQ5LjExMTEsIDMuMDg4XSwgWzQ4LjMzMjksIDIuMjQyOV0sIFs0OC4zNzg1LCAxLjk3ODFdLCBbNDkuMDkxNCwgMi43OTQ3XSwgWzQ5LjEwNjYsIDIuNTU2OV0sIFs0OC40MjcsIDMuMzkyNV0sIFs0OC4zNjgsIDMuMTIxMV0sIFs0OS4yMjI1LCAxLjczNjhdLCBbNDguMzAwOSwgMi40MTg4XSwgWzQ4LjM5NTEsIDMuNDE1M10sIFs0OC45OTk4LCAzLjIwNzldLCBbNDguNzIxNywgMy40NjcxXSwgWzQ4LjcwNywgMy40NjQxXSwgWzQ4LjQwMzksIDEuOTMwNF0sIFs0OC40ODYxLCAzLjQwMTRdLCBbNDguODcyNCwgMS41NDYyXSwgWzQ4LjE3NTgsIDIuOTMzOV0sIFs0OC4xNjI3LCAyLjQ4MTJdLCBbNDguMjUzOSwgMi40NDMxXSwgWzQ4LjMwMjMsIDIuMjQ0OV0sIFs0OC45MzM3LCAxLjUxMl0sIFs0OS4xMDQ2LCAyLjYzNTFdLCBbNDkuMTEzOSwgMi41NTI3XSwgWzQ4LjMxNywgMy4wMjddLCBbNDguODc4MSwgMy4zODA4XSwgWzQ4Ljc4NzYsIDEuNTc2NV0sIFs0OS4wODUxLCAyLjU3OTJdLCBbNDguMjMxMSwgMy4wMjA3XSwgWzQ4Ljg3NDgsIDMuMzgwNV0sIFs0OC44NzA5LCAzLjQwNDldLCBbNDguODE1NiwgMy40NzY2XSwgWzQ4LjYyMjEsIDEuNjU2M10sIFs0OS4xMDg4LCAzLjA2MjldLCBbNDkuMTEyOCwgMy4wNjc0XSwgWzQ5LjE3NTUsIDIuMjEwOF0sIFs0OC45NywgMy4yNTMxXSwgWzQ4Ljk0NTQsIDMuMjYwNl0sIFs0OC42NTYsIDMuNDU1OF0sIFs0OC4yODUxLCAyLjAwOTVdLCBbNDguMjkxMSwgMy4wMjQyXSwgWzQ4LjkwNjQsIDMuMzczM10sIFs0OC4xNjA4LCAyLjgwOTddLCBbNDguMTY2MiwgMi44MDA1XSwgWzQ4LjI4NTMsIDIuMDA3OV0sIFs0OC44OTA0LCAzLjM3NjldLCBbNDguODYxOCwgMy40Mjg3XSwgWzQ4LjQ5MjIsIDMuNDMzNF0sIFs0OC4zNzAxLCAzLjIyNl0sIFs0OC41ODcxLCAzLjQ5MDddLCBbNDguMTI1NCwgMi40NDI4XSwgWzQ4LjYyNDQsIDEuNjU2Nl0sIFs0OS4wNzE2LCAyLjcxNTddLCBbNDkuMDU0OSwgMS40NzM4XSwgWzQ5LjA2NTYsIDEuNTA4OV0sIFs0OS4wNzY5LCAxLjUxMzRdLCBbNDkuMDc3MywgMS41NzI5XSwgWzQ5LjA4MDEsIDEuNjEyNV0sIFs0OS4xMDAzLCAxLjYyMTddLCBbNDkuMjAwMiwgMS42NzY1XSwgWzQ5LjIxMjYsIDEuNjc2NV0sIFs0OS4yNDEzLCAxLjcxMTZdLCBbNDkuMTgyMywgMS44XSwgWzQ4LjMwMDMsIDIuNDE5OF0sIFs0OC4zMTA0LCAyLjM1NThdLCBbNDguMzE2MywgMi4zNDgxXSwgWzQ5LjA3NjYsIDIuODUxMV0sIFs0OS4xODQ2LCAyLjEzNjJdLCBbNDguNDg0NSwgMy4zOTQxXSwgWzQ5LjE1OSwgMi4yODExXSwgWzQ5LjA5OSwgMi41NTg1XSwgWzQ4LjQ1MDYsIDEuOTIyMV0sIFs0OC40MDE3LCAxLjk3MzldLCBbNDguNDk0MiwgMS43ODk0XSwgWzQ4LjYxMzUsIDEuNjg0M10sIFs0OC42MTg5LCAxLjY1OTldLCBbNDguNDcwOSwgMS44MDE2XSwgWzQ5LjAwNiwgMy4xOTYxXSwgWzQ4LjQyNTgsIDEuOTM4OF0sIFs0OC43NDE5LCAxLjYyMThdLCBbNDguNzg5OSwgMS41NzZdLCBbNDguMjIwOCwgMy4wMTEzXSwgWzQ4LjI2MzUsIDMuMDQzMl0sIFs0OC4zNjc4LCAzLjI1NjZdLCBbNDguMzU5LCAzLjExMDRdLCBbNDguODk2MSwgMy4zNjk0XSwgWzQ4LjkyODYsIDMuMzEzMV0sIFs0OC44NDg1LCAzLjQ0ODhdLCBbNDguNjU3MiwgMy40NTE4XSwgWzQ4LjYwOTYsIDMuNTMxXSwgWzQ5LjAzMzksIDMuMTc5OF0sIFs0OC4xNDUsIDIuNDY0NF0sIFs0OC4zMTM0LCAyLjQwNjRdLCBbNDguNzk4NSwgMS41NzgyXSwgWzQ5LjExNjksIDEuNjQwNV0sIFs0OS4xODEzLCAyLjE0MTJdLCBbNDkuMDg2MSwgMi41ODAyXSwgWzQ4LjM3MjIsIDMuMTM4NF0sIFs0OC45NDY5LCAzLjI2MTldLCBbNDguMTIwNSwgMi42NjQ3XSwgWzQ4Ljg3MDQsIDEuNTQ2MV0sIFs0OS4xOTA5LCAyLjAzNjVdLCBbNDguOTI1LCAzLjM3MTRdLCBbNDguODA0OCwgMy40MDk1XSwgWzQ4LjQ5MSwgMy40MjAyXSwgWzQ5LjAyODUsIDMuMTc0MV0sIFs0OC4xNDk2LCAyLjgwMDFdLCBbNDguODcwNCwgMy40MDM1XSwgWzQ4LjEzMiwgMi41NzQ1XSwgWzQ4LjEyNjIsIDIuNTE2NV0sIFs0OC4zMzA2LCAyLjIzNDZdLCBbNDguNzYwNiwgMS41OTkzXSwgWzQ5LjA5MzEsIDIuNjY0NF0sIFs0OS4xNTY5LCAyLjM3MDNdLCBbNDguOTE1NiwgMy4zNDkxXSwgWzQ4LjkyMSwgMy4zNzJdLCBbNDguODE2NCwgMy40MTkzXSwgWzQ5LjEwMjUsIDMuMDU5N10sIFs0OC4xODczLCAyLjUxNTNdLCBbNDguMjc2NSwgMi40MTkyXSwgWzQ4LjMxMjIsIDIuMjk4N10sIFs0OC4zMDcyLCAyLjExMTJdLCBbNDguMjkxLCAyLjA1MTldLCBbNDguMjg3OSwgMi4wMjQzXSwgWzQ5LjExNDEsIDMuMDY3NV0sIFs0OS4xMDgsIDMuMTAyNl0sIFs0OC4zMTI0LCAyLjI0ODRdLCBbNDguMTUzNSwgMi44MDA0XSwgWzQ5LjA4NjIsIDMuMDQ5MV0sIFs0OS4wOTkyLCAzLjE2MDRdLCBbNDkuMDI4MSwgMy4xNjgxXSwgWzQ5LjA4ODUsIDMuMDY0NV0sIFs0OS4wNjA5LCAzLjE4MThdLCBbNDkuMDg2NSwgMy4wNDc2XSwgWzQ4LjE2NTEsIDIuODExMV0sIFs0OS4xNzA3LCAxLjk0MDRdLCBbNDkuMDcxMywgMS41MzRdLCBbNDkuMTg0OSwgMS43ODI1XSwgWzQ4LjM2MDMsIDMuMDUwNl0sIFs0OC4zNTA0LCAzLjA0MTZdLCBbNDguODU5MywgMy40NDddLCBbNDguODE3OCwgMy40MTY2XSwgWzQ4LjQ4MDUsIDMuMzg3NV0sIFs0OC4xNjg3LCAyLjUxNDRdLCBbNDguOTc5OSwgMS40OTgxXSwgWzQ4LjgxMzgsIDMuNDU0NF0sIFs0OC43NTc4LCAzLjM5NjZdLCBbNDkuMjA2NSwgMS42NzIyXSwgWzQ4LjE3NjksIDIuOTM1MV0sIFs0OC4yODExLCAyLjQxODJdLCBbNDguNDQ0NSwgMS44NjM4XSwgWzQ5LjA4OTEsIDIuNjA3Ml0sIFs0OC44NjQ3LCAzLjQwMzJdLCBbNDguODQ5NSwgMy40NTA1XSwgWzQ4LjM3MzMsIDMuMzQ4NF0sIFs0OC4zNzg3LCAzLjI5ODFdLCBbNDguNzA4NiwgMy40NjczXSwgWzQ5LjA5NTYsIDIuNjIzXSwgWzQ5LjE1NTcsIDIuMzY3XSwgWzQ4LjIzMTgsIDMuMDE4OV0sIFs0OC40MjkzLCAzLjM5NTRdLCBbNDkuMTAyNSwgMi42MzA2XSwgWzQ4Ljk4NzksIDMuMjI2MV0sIFs0OC40ODg3LCAzLjQwNzZdLCBbNDkuMTcsIDEuOTQyNF0sIFs0OS4xMTc1LCAyLjUzNzhdLCBbNDkuMTA4MSwgMy4xMDIyXSwgWzQ4LjE0MDUsIDIuNTM3NV0sIFs0OC4yMTU2LCAzLjAwODhdLCBbNDguMjcxNywgMi40MTg3XSwgWzQ4LjMxMzgsIDIuMTUxOF0sIFs0OC4zOTg0LCAzLjM3NzVdLCBbNDguODcxMiwgMy4zODk3XSwgWzQ4LjkyNzcsIDMuMzY4M10sIFs0OC44OTIxLCAzLjM3MTNdLCBbNDguODc5NiwgMy4zODA1XSwgWzQ4LjgwMzgsIDMuNDEyNl0sIFs0OC43Mzg2LCAzLjQ2NzRdLCBbNDguNzAxNCwgMy40NzA0XSwgWzQ4LjY5NTcsIDMuNDcxOV0sIFs0OC42Mzg1LCAzLjUyMjJdLCBbNDkuMDYzLCAyLjc2MDRdLCBbNDkuMDcwNywgMi43NzU4XSwgWzQ5LjA4MzYsIDIuNzcyNl0sIFs0OS4wNzMsIDIuODc0OV0sIFs0OS4wNjUyLCAyLjc2NjZdLCBbNDkuMTAxMywgMi42Mzg2XSwgWzQ4LjMxNTUsIDIuMTcyM10sIFs0OC40Mzk3LCAxLjg4NzZdLCBbNDguNDkzNCwgMS43ODg1XSwgWzQ5LjA3NjUsIDIuODUwNl0sIFs0OC42MTksIDMuNTU3M10sIFs0OS4wODg3LCAzLjAwMTldLCBbNDkuMDg3NSwgMy4wMjQ4XSwgWzQ4LjM3MDQsIDMuMjIzN10sIFs0OS4xNDkzLCAyLjQyMl0sIFs0OC40MjczLCAzLjM5MzNdLCBbNDguODcyOSwgMS41NDY0XSwgWzQ4LjMwNDIsIDIuMDk5NF0sIFs0OS4xNzU2LCAxLjgzNDNdLCBbNDkuMDgxOCwgMi41OTc5XSwgWzQ5LjA3MzQsIDIuNzE4NF0sIFs0OS4wNzcyLCAyLjc4MzldLCBbNDguNjU3LCAzLjQ1MjVdLCBbNDguNDc3MiwgMy4zODg1XSwgWzQ5LjE4NTMsIDIuMTQwN10sIFs0OC4zMzE2LCAyLjMxNzJdLCBbNDkuMTUxNywgMi4yMzVdLCBbNDguMzY5NywgMy4yMjE1XSwgWzQ5LjEwMjIsIDMuMTQzOF0sIFs0OC4xOTMsIDIuNTE0NV0sIFs0OC45MTA1LCAzLjMyODhdLCBbNDguMzU4LCAzLjA4NV0sIFs0OC40NTIsIDEuODQ0MV0sIFs0OS4wOTEsIDIuNjcxNF0sIFs0OS4xNTcsIDIuMzgxOF0sIFs0OS4wMDk2LCAxLjQ3NDFdLCBbNDkuMDE2OSwgMS40NzcxXSwgWzQ5LjA3MjEsIDEuNTM2Nl0sIFs0OS4wNzI2LCAxLjU1MDNdLCBbNDkuMDgzOCwgMS41OTc2XSwgWzQ5LjA4NDEsIDEuNTk5MV0sIFs0OS4xNjA5LCAxLjY2MzFdLCBbNDkuMTk4NCwgMS42NzUzXSwgWzQ5LjIwMzksIDEuNjc1M10sIFs0OS4yMjc0LCAxLjcwMTJdLCBbNDguMjA1NiwgMi45Nzc4XSwgWzQ5LjE1ODksIDIuMzcxXSwgWzQ4LjI5MzksIDEuOTc0NF0sIFs0OC42MzE3LCAxLjY1MTJdLCBbNDguNDMyLCAxLjkzNzhdLCBbNDguNDM0OCwgMS45MzYzXSwgWzQ4LjY5MDcsIDEuNjAyNF0sIFs0OC41NzQ4LCAxLjc1MThdLCBbNDguNzEsIDEuNTg4N10sIFs0OC40NTA5LCAxLjkyODZdLCBbNDguNDY2MiwgMS44MTI4XSwgWzQ4LjU3MjYsIDEuNzI3NF0sIFs0OC44ODUsIDEuNTYwOV0sIFs0OS4xNjM1LCAyLjIyODFdLCBbNDguOTEyLCAzLjMyNzRdLCBbNDkuMTY4NiwgMS42Njg4XSwgWzQ5LjE5NDksIDEuNzI2OF0sIFs0OS4xODc1LCAyLjExMjldLCBbNDkuMTg2NSwgMi4zMTA5XSwgWzQ4LjM2NzgsIDMuMjQxOV0sIFs0OC4zNzQ3LCAzLjE4MDldLCBbNDguODk2MiwgMS41NTFdLCBbNDkuMjI0MiwgMS42OTY0XSwgWzQ4Ljk5LCAzLjIyMzddLCBbNDkuMTkwOSwgMi4xMjU0XSwgWzQ5LjE1NzQsIDIuMjcxNV0sIFs0OS4yMTYzLCAxLjY4M10sIFs0OS4xNzksIDIuMTM3OV0sIFs0OS4xMTkxLCAyLjU0Ml0sIFs0OC44NjA5LCAxLjU3OF0sIFs0OC44OTkxLCAxLjU0ODldLCBbNDguOTg1MywgMS40NjJdLCBbNDguOTY0NSwgMS40OTE4XSwgWzQ5LjE3NjQsIDEuODE0Ml0sIFs0OS4xNjk2LCAxLjkxMDldLCBbNDguODE0OSwgMS41OTEyXSwgWzQ5LjA5MTksIDIuNjY5N10sIFs0OS4xMzUxLCAyLjQ0NDFdLCBbNDguODAwOCwgMS41NzkzXSwgWzQ5LjA2MSwgMi43NDA1XSwgWzQ5LjE1MjYsIDIuMzg2OV0sIFs0OC4zNzU0LCAzLjI5OTNdLCBbNDkuMDgsIDIuNTg2Nl0sIFs0OS4yMDE0LCAxLjcyMjhdLCBbNDguNzg2MywgMS41NzY1XSwgWzQ5LjA3ODksIDIuOTI4M10sIFs0OS4xMDU4LCAyLjQ5MjNdLCBbNDguMjEyMiwgMy4wMDg1XSwgWzQ4Ljc5MzgsIDEuNTgxXSwgWzQ5LjE4MDYsIDIuMTU5OF0sIFs0OS4xNTk2LCAyLjI4MjddLCBbNDkuMTUyNSwgMi4zNjQ4XSwgWzQ5LjE3NDIsIDEuODM0OV0sIFs0OS4xMTI2LCAxLjYzMzFdLCBbNDguODY2MiwgMS41NjY2XSwgWzQ4Ljc5NzUsIDEuNTc4OV0sIFs0OS4wMTk3LCAxLjQ2OV0sIFs0OC4zMjgxLCAzLjAzNzNdLCBbNDkuMDU3MywgMS40NTUzXSwgWzQ5LjA1OTUsIDEuNDY2XSwgWzQ4LjQyMDMsIDEuOTM0NV0sIFs0OS4wNTQ2LCAxLjQ4ODldLCBbNDkuMDYxNSwgMS41MDU2XSwgWzQ5LjA3MDEsIDEuNTMxNV0sIFs0OS4wNzMzLCAxLjUzOTJdLCBbNDkuMDcyOCwgMS41NjY2XSwgWzQ5LjA5NzIsIDEuNjE4OF0sIFs0OS4wNzExLCAxLjUzMjJdLCBbNDkuMTM0NSwgMS42NTcyXSwgWzQ5LjE3OTMsIDIuMjE3MV0sIFs0OC4yODc2LCAxLjk5MTJdLCBbNDguMzQ3MSwgMS45NzQ1XSwgWzQ4LjY1MDMsIDEuNjI2OV0sIFs0OC42OTI3LCAxLjU5MThdLCBbNDguNjE3MSwgMS42OTA5XSwgWzQ4LjMxMjYsIDEuOTc0NV0sIFs0OC4zNTczLCAxLjk3Nl0sIFs0OC41MjQ1LCAxLjc3NjNdLCBbNDguNTk5NywgMS43MTM4XSwgWzQ4LjcxMywgMS41OTAzXSwgWzQ5LjA5MDMsIDMuMDYzNF0sIFs0OC40ODE4LCAzLjM5MzhdLCBbNDkuMTk0MiwgMS43MjU5XSwgWzQ5LjE4MjgsIDEuOTc3NF0sIFs0OS4xNTE4LCAyLjIzODhdLCBbNDguMzcwNSwgMy4zMzQ5XSwgWzQ5LjE3NjMsIDIuMDAyNF0sIFs0OS4xNzQ4LCAxLjk2MjhdLCBbNDkuMTk0OSwgMi4wNDI0XSwgWzQ5LjE5MzQsIDIuMTI3OF0sIFs0OC40MjAzLCAzLjQxMTZdLCBbNDkuMTI4NCwgMi40NzU0XSwgWzQ5LjE3NDEsIDEuOTYxOV0sIFs0OS4wODc4LCAyLjU3ODFdLCBbNDguMTY4MSwgMi44MDAxXSwgWzQ4LjEyNTUsIDIuNjczNl0sIFs0OC4xNjcsIDIuNTE2NV0sIFs0OC4yNDU1LCAyLjQ3NjldLCBbNDguMzMwMywgMi4zMTg1XSwgWzQ4LjMwMDUsIDIuMjUyOF0sIFs0OC4yOTc1LCAyLjA4OTddLCBbNDguMTUxNSwgMi43OTg2XSwgWzQ4LjEyODEsIDIuNzExN10sIFs0OC4yMjY0LCAyLjUxNjVdLCBbNDkuMTA4NiwgMy4xMDA4XSwgWzQ5LjExMDcsIDMuMDk3OF0sIFs0OS4xMDcsIDMuMTIzN10sIFs0OS4xMDY2LCAzLjEzNDRdLCBbNDkuMTA3OCwgMy4xMTNdLCBbNDkuMDc3LCAzLjE2NzhdLCBbNDkuMTc5NCwgMi4xNjQ5XSwgWzQ4LjQ5MiwgMy40MjI2XSwgWzQ4Ljg2NzgsIDEuNTYwNV0sIFs0OS4yMjQyLCAxLjY5N10sIFs0OS4xODE3LCAxLjc4OThdLCBbNDkuMTk4NywgMi4wOTA1XSwgWzQ4LjI3NDEsIDMuMDI5N10sIFs0OC45MDcsIDMuMzc0OV0sIFs0OC45OTkxLCAxLjQ3ODddLCBbNDkuMTc0NiwgMS45NjI3XSwgWzQ5LjE0ODUsIDIuNDMxXSwgWzQ5LjE3ODcsIDEuODIzN10sIFs0OC45MDAyLCAzLjM3MDRdLCBbNDguOTE0OSwgMy4zNDNdLCBbNDguNjMyNywgMy41Mjc1XSwgWzQ4LjU4OSwgMy40OTI0XSwgWzQ4LjQ4MzYsIDMuMzk5M10sIFs0OC40NTg2LCAzLjQwMV0sIFs0OC40MjgsIDMuMzk0OF0sIFs0OC40MDE3LCAzLjQxNzddLCBbNDguMjc5NCwgMy4wMjZdLCBbNDguMzEzMSwgMy4wMjEzXSwgWzQ5LjA2NDUsIDIuNzY1N10sIFs0OS4wODA1LCAyLjcyNDRdLCBbNDkuMTA0NSwgMi42MzE1XSwgWzQ5LjA2NTMsIDIuNzA2Ml0sIFs0OS4wNzI0LCAyLjk4ODFdLCBbNDkuMDg2OSwgMi45OTU4XSwgWzQ4Ljg5OTEsIDEuNTQ5Ml0sIFs0OC43NDE4LCAxLjYyMjFdLCBbNDguNzYxOSwgMS41ODRdLCBbNDkuMjAzOSwgMS43MTU5XSwgWzQ5LjE2MjEsIDIuMjg1NV0sIFs0OS4xNTM5LCAyLjM4NTRdLCBbNDguOTk0LCAxLjQ3MDJdLCBbNDkuMTY5OSwgMS44NTgyXSwgWzQ5LjE2NDgsIDIuMTcxMV0sIFs0OS4xNjU3LCAyLjE3MTFdLCBbNDkuMTg1MiwgMi4zMV0sIFs0OC43MjA1LCAxLjYwMTJdLCBbNDkuMTU3MywgMi4yMjAyXSwgWzQ4LjQ4NDMsIDMuMzkzNV0sIFs0OS4wNTI0LCAxLjQ3ODVdLCBbNDkuMDc4LCAxLjUxODFdLCBbNDkuMDcwMywgMS41Mjg4XSwgWzQ4Ljk2MzMsIDEuNDk0XSwgWzQ4Ljk3ODQsIDEuNTE4NF0sIFs0OS4wNjkxLCAxLjU1NzddLCBbNDkuMDcxOCwgMS41NjU0XSwgWzQ5LjA3NTcsIDEuNTY5OV0sIFs0OS4wODI1LCAxLjU5MjhdLCBbNDguOTIyNSwgMS41MzQ1XSwgWzQ5LjIzMiwgMS43MDQ1XSwgWzQ4LjU0NTksIDMuNDg1NV0sIFs0OC42MTIxLCAxLjcwMjFdLCBbNDguNDQxMSwgMS45NDI5XSwgWzQ4LjQ3ODgsIDEuNzkzNV0sIFs0OC42MDU3LCAxLjcxODhdLCBbNDguNDA1NCwgMS45NDE0XSwgWzQ4LjY2NzQsIDEuNjAxNV0sIFs0OC41MDkzLCAxLjc3NjhdLCBbNDguMzk5NSwgMS45NzY1XSwgWzQ4LjQyMDYsIDEuOTM5OV0sIFs0OC40NTc1LCAxLjgzOTNdLCBbNDkuMDcxOSwgMS41MzI1XSwgWzQ4Ljc0OSwgMS42MjVdLCBbNDkuMTE1NiwgMi40OTk2XSwgWzQ4LjkwODYsIDEuNTQxNl0sIFs0OC44NjM5LCAzLjQwNTFdLCBbNDguNzg0MSwgMy40MTczXSwgWzQ4LjYxNiwgMy41NDA4XSwgWzQ5LjE3NzksIDEuOTY2MV0sIFs0OS4xNzc1LCAyLjMyNjNdLCBbNDguNjg4NywgMy40NzM1XSwgWzQ4LjI3MzEsIDMuMDM5XSwgWzQ5LjE4MzYsIDIuMTUyMV0sIFs0OS4xNzk4LCAxLjgwNzRdLCBbNDkuMTQ4MSwgMi40MzI4XSwgWzQ4LjQ2MTEsIDMuMzk2NF0sIFs0OC4zNjgzLCAzLjE0NzldLCBbNDguNDkyMSwgMy40MjIzXSwgWzQ4LjM3MzMsIDMuMzQ0Nl0sIFs0OC4zNTgyLCAzLjA3MDJdLCBbNDkuMTkzNCwgMi4wOTMzXSwgWzQ5LjE3OTUsIDIuMTYyXSwgWzQ4LjYzMTYsIDMuNTM4XSwgWzQ4Ljk1MzEsIDEuNTA1OF0sIFs0OS4xODM3LCAxLjc5MzddLCBbNDkuMTQyMywgMi40MzkzXSwgWzQ4LjczMTMsIDMuNDY2OV0sIFs0OC45MzI5LCAxLjUxMTddLCBbNDguMzEzNiwgMi4zOTcxXSwgWzQ4LjMxMTcsIDIuMTgwN10sIFs0OS4xOTUyLCAxLjczMjFdLCBbNDguNDY3NywgMy4zOTk2XSwgWzQ4LjMyODgsIDMuMDM5OF0sIFs0OC4yNjI1LCAzLjA0MjhdLCBbNDguNTc0NiwgMS43NTMxXSwgWzQ4Ljc4MTIsIDEuNTc3OF0sIFs0OC42NDMyLCAzLjUyODJdLCBbNDguNDgxMiwgMy4zOTRdLCBbNDguNjM3MiwgMy41MTc0XSwgWzQ4LjM0MjYsIDMuMDM3MV0sIFs0OC44MTA1LCAxLjU4MjhdLCBbNDkuMTY1MSwgMS44MzQxXSwgWzQ5LjE4MjksIDEuOTcyOF0sIFs0OC41LCAzLjQzMjZdLCBbNDguMzY5NSwgMy4xNTA0XSwgWzQ5LjE1NjgsIDIuMzcwMl0sIFs0OC45NzkzLCAzLjIzMDJdLCBbNDkuMTY2LCAxLjg5NDVdLCBbNDguMzA5NCwgMi40MDg5XSwgWzQ4LjMzNTMsIDIuMTk1NV0sIFs0OS4xNzA4LCAxLjY2OTJdLCBbNDkuMTY2MSwgMS44MzQ5XSwgWzQ5LjE5ODUsIDIuMDkwMV0sIFs0OC45NzY4LCAzLjI0NDJdLCBbNDguOTI1MiwgMy4zNjc3XSwgWzQ4LjYzNiwgMy40NjUzXSwgWzQ4LjY0MzYsIDMuNDg2N10sIFs0OS4xMzg2LCAxLjY1MTNdLCBbNDguNTQ1NCwgMy40ODM0XSwgWzQ5LjAyNTEsIDEuNDU4OV0sIFs0OS4wNTcyLCAxLjQ1NTldLCBbNDkuMDU5NywgMS40Njk2XSwgWzQ4LjQ3NzgsIDEuNzkyOF0sIFs0OC43MjYsIDEuNjA1M10sIFs0OS4wNTIsIDEuNDgwM10sIFs0OS4wNTIzLCAxLjQ4MThdLCBbNDkuMDgzNCwgMS41MDkyXSwgWzQ5LjA3MTYsIDEuNTMyMV0sIFs0OC4zMTI3LCAyLjI3ODFdLCBbNDguMzA4NiwgMi4yNjQyXSwgWzQ4LjMwNzcsIDIuMjY0Ml0sIFs0OS4wNywgMS41MzA3XSwgWzQ5LjA4OTcsIDIuNTc5OV0sIFs0OC43ODQ5LCAzLjQyM10sIFs0OC40MTQzLCAzLjQwNzhdLCBbNDguMzYwMSwgMy4wNDk1XSwgWzQ4LjY3NCwgMS42MDY5XSwgWzQ4LjY0ODksIDEuNjI5OF0sIFs0OC4zNDMzLCAxLjk2OTddLCBbNDguNzA3NywgMS41OTE3XSwgWzQ4LjU0NiwgMS43ODM3XSwgWzQ4LjY4OTMsIDEuNjA1NF0sIFs0OC4zNCwgMS45Njk3XSwgWzQ4LjMxODgsIDIuMTg0MV0sIFs0OC40NDEzLCAxLjg2OTFdLCBbNDguNjEwOSwgMS43MTY3XSwgWzQ4Ljg3MTEsIDEuNTQ3Ml0sIFs0OS4xNjYsIDIuMjM0NF0sIFs0OS4xNzIyLCAyLjMzMzVdLCBbNDguODE4OSwgMy40NjU1XSwgWzQ4LjM1NzcsIDMuMDk5N10sIFs0OC4zMDU1LCAzLjAxNThdLCBbNDkuMTIwMywgMi41NDM5XSwgWzQ5LjEwMjQsIDEuNjI2OF0sIFs0OC4xNjc2LCAyLjc5MzZdLCBbNDguMTYzNSwgMi43Njc3XSwgWzQ4LjI2NCwgMi40MjE2XSwgWzQ4LjI4NSwgMi4wMzkxXSwgWzQ5LjA4MDMsIDIuNTg0N10sIFs0OS4xODIyLCAxLjk3OTVdLCBbNDguMjE3NiwgMi41MTUzXSwgWzQ4LjgwNjYsIDEuNTgyN10sIFs0OS4xNDg3LCAyLjQyODRdLCBbNDkuMTc5MywgMS45ODY5XSwgWzQ4Ljc3MSwgMS41ODU2XSwgWzQ5LjIwMDgsIDEuNzI1XSwgWzQ5LjEwNCwgMi41MTA1XSwgWzQ4LjY0NTYsIDMuNTA0NV0sIFs0OC40NTQyLCAzLjQwMzldLCBbNDkuMTU5MiwgMi4zNzA5XSwgWzQ5LjA5NDMsIDIuNTY4OV0sIFs0OC4xMzY1LCAyLjgzODhdLCBbNDguMTIwNiwgMi42NjY1XSwgWzQ4LjEyOTYsIDIuNDc2XSwgWzQ4LjEyOTEsIDIuNDY1M10sIFs0OC4yMjYsIDIuNTA5Nl0sIFs0OC4zMjIyLCAyLjE4NDldLCBbNDguMzEzNiwgMi4xNjk1XSwgWzQ5LjEwNDYsIDMuMDYwM10sIFs0OC4xNjE2LCAyLjgwOTldLCBbNDguMjAyMSwgMi41MTg2XSwgWzQ5LjAwNTUsIDMuMTk1OF0sIFs0OS4wMTEzLCAzLjE4MzZdLCBbNDkuMDc5NSwgMy4xNjA5XSwgWzQ5LjA1NTQsIDMuMTgwNl0sIFs0OS4wMDg1LCAzLjE5NzVdLCBbNDkuMDk2OSwgMy4wNTU2XSwgWzQ4LjMxMTUsIDIuMzgxM10sIFs0OC4xNzgyLCAyLjUwOTNdLCBbNDkuMTY0OCwgMi4xNjc5XSwgWzQ4LjM3MzIsIDMuMzQ3OV0sIFs0OS4xMjk5LCAxLjY1NDFdLCBbNDkuMjI0LCAxLjY5NTJdLCBbNDguODgyNywgMy4zODEyXSwgWzQ4LjgwNTQsIDEuNTgxN10sIFs0OS4xOTQ0LCAxLjcyNThdLCBbNDkuMDk3NiwgMi41NjAxXSwgWzQ4LjMxNjQsIDMuMDI1Ml0sIFs0OC4xNjkxLCAyLjc5NTNdLCBbNDguMjk4OCwgMi4xMzIyXSwgWzQ4Ljg0NDIsIDEuNTc5M10sIFs0OC4yODUxLCAyLjQyMDJdLCBbNDguOTc5NywgMS40ODc2XSwgWzQ4LjQxNTMsIDMuNDAyMl0sIFs0OC45MjExLCAzLjMxMzhdLCBbNDguOTI4MSwgMy4zNjcxXSwgWzQ4Ljc1MzYsIDMuNDM1OF0sIFs0OC45MzUzLCAzLjMxMjNdLCBbNDguODYwMSwgMy40NDVdLCBbNDguODAxNywgMy40Mjk2XSwgWzQ4LjYzMjUsIDMuNTI1N10sIFs0OC42MTQzLCAzLjU0MDldLCBbNDguNTU1NCwgMy40NzY5XSwgWzQ5LjA5MzgsIDIuNjE2XSwgWzQ5LjA3NTMsIDIuOTg4XSwgWzQ5LjA2MSwgMi43NDI1XSwgWzQ5LjA5OTEsIDIuNjQxOV0sIFs0OS4wOTkzLCAyLjY0MzRdLCBbNDkuMDYzMSwgMi43NjA5XSwgWzQ5LjE5OTksIDEuNzI1Ml0sIFs0OS4xNzk4LCAyLjEzNzJdLCBbNDkuMDk0MiwgMi41NjddLCBbNDguOTU0NiwgMy4yNTg1XSwgWzQ4Ljk0NTYsIDMuMjk4M10sIFs0OS4wOTQzLCAyLjU3MzJdLCBbNDguMTg5OSwgMi41MTgxXSwgWzQ4LjM3NjQsIDMuMjkxMl0sIFs0OC43NTg5LCAxLjYwODldLCBbNDguOTMxLCAxLjUwODRdLCBbNDkuMTg0NSwgMS43NzldLCBbNDguODg4MiwgMy4zODRdLCBbNDguOTc2NCwgMy4yNDUzXSwgWzQ4LjYwMTksIDMuNTA2XSwgWzQ5LjE3ODksIDEuODI3M10sIFs0OC44NzY3LCAxLjU1MjRdLCBbNDkuMTczMiwgMi4xNTg4XSwgWzQ4LjYzNTksIDMuNTE4Nl0sIFs0OC40MDAxLCAzLjM4NDZdLCBbNDguMzUxOSwgMy4xMDddLCBbNDguMjc0MiwgMi40MTg0XSwgWzQ4LjQ1NDgsIDMuNDAzNV0sIFs0OC4zMDI2LCAyLjA5ODRdLCBbNDkuMTg3OCwgMS43NDEyXSwgWzQ4Ljc1NzMsIDMuNDI3MV0sIFs0OS4wMDQ1LCAxLjQ4MDZdLCBbNDkuMDcwNywgMS41MjAyXSwgWzQ5LjA2ODUsIDEuNTIzMl0sIFs0OS4wNywgMS41NTY4XSwgWzQ5LjA3NDgsIDEuNTcwNV0sIFs0OS4wOTc0LCAxLjYxOTNdLCBbNDkuMDk3NiwgMS42MjA4XSwgWzQ5LjExMzEsIDEuNjM0NV0sIFs0OS4xMjE0LCAxLjY0NjddLCBbNDkuMTQ0OSwgMS42NTQyXSwgWzQ5LjE2MjMsIDIuMjI0Nl0sIFs0OC43MzMxLCAzLjQ2NzNdLCBbNDguNDMwNywgMy4zOTU2XSwgWzQ4LjQxOTgsIDEuOTMyMV0sIFs0OC40ODk5LCAxLjc4NTddLCBbNDguNzE2OSwgMS41OTUyXSwgWzQ4LjYyNjEsIDEuNjU3N10sIFs0OC40NCwgMS44ODQ4XSwgWzQ4LjQ3NTQsIDEuNzk5NF0sIFs0OC42MTM2LCAxLjcwOTVdLCBbNDguMzEsIDIuMjk4NF0sIFs0OC42MTM5LCAxLjcxMV0sIFs0OC42NTA5LCAxLjYyMjZdLCBbNDkuMTkxNSwgMi4wOTU3XSwgWzQ5LjE5MDcsIDIuMTA5NF0sIFs0OC42NDM2LCAzLjUyOF0sIFs0OC43OTkyLCAxLjU3OTFdLCBbNDguOTI0NCwgMS41Mjg4XSwgWzQ5LjA3NTYsIDIuODgyXSwgWzQ4LjM2NTYsIDMuMjQ5N10sIFs0OC45Nzg0LCAxLjQ2ODNdLCBbNDguODMxNSwgMS41ODI3XSwgWzQ4Ljk3MzEsIDEuNTA1XSwgWzQ4LjQ5MDcsIDMuNDIwMl0sIFs0OC4zMTU1LCAzLjAyNTNdLCBbNDkuMTczNywgMS45MzM2XSwgWzQ5LjExMSwgMy4wOTA0XSwgWzQ4LjMxNywgMi4zOTkyXSwgWzQ4LjMzNjQsIDIuMjIzOV0sIFs0OS4xNTcxLCAyLjM3MDNdLCBbNDguNzgyOSwgMy40NDA1XSwgWzQ4LjM3NjEsIDMuMTc4M10sIFs0OS4yMjM4LCAxLjY5NzldLCBbNDkuMTc3NywgMS45ODldLCBbNDguMTYzOCwgMi44MTE0XSwgWzQ4LjM5OTEsIDMuMzc3OV0sIFs0OC44MDg3LCAxLjU4MDVdLCBbNDguMjY1MywgMi40MjA5XSwgWzQ4LjMxMjksIDIuMjQ4Nl0sIFs0OS4wODg4LCAyLjc4NTJdLCBbNDkuMTc3NSwgMi4yMTM3XSwgWzQ4Ljc4NDEsIDMuNDI0MV0sIFs0OC40Mzg3LCAzLjQwMjldLCBbNDguOTc1MywgMS40NzA2XSwgWzQ4LjE0NzQsIDIuODU5XSwgWzQ4LjE0NTUsIDIuNzUzOV0sIFs0OC4zMTQsIDIuMjk5NV0sIFs0OC4zMjkxLCAyLjIyOTVdLCBbNDguOTQ4MSwgMy4zMDM1XSwgWzQ4LjY0MjgsIDMuNTMwNl0sIFs0OC42MzI4LCAzLjUyOTFdLCBbNDguNDUzNSwgMy40MDU2XSwgWzQ4LjM2MDksIDMuMDgwOV0sIFs0OC40MjEzLCAzLjQxMThdLCBbNDguNDgyMywgMy4zOTMxXSwgWzQ5LjE1MzYsIDEuNjY0NV0sIFs0OS4xNTQsIDIuMzY1Ml0sIFs0OC4xNzc4LCAyLjkzNTFdLCBbNDguMTUzOCwgMi44NjQ5XSwgWzQ4LjI4MDgsIDIuNDE4Ml0sIFs0OS4xNzQ4LCAxLjgxNTddLCBbNDkuMjA2MywgMi4wODZdLCBbNDkuMTQ5NywgMi40MTY3XSwgWzQ4Ljk0OSwgMy4yNjNdLCBbNDguNjI5OSwgMy41NDE5XSwgWzQ4LjU3MjUsIDEuNzQzOF0sIFs0OS4yMzM3LCAxLjcxMjRdLCBbNDguMjA0NCwgMi45NzIxXSwgWzQ4LjMxMzMsIDIuMjY2NF0sIFs0OC4zNjY5LCAzLjExOTVdLCBbNDguOTM1NCwgMS41MTExXSwgWzQ4LjE2NjUsIDIuNzg2XSwgWzQ4LjE2MjEsIDIuNzcwOF0sIFs0OS4xODQ3LCAxLjY2OThdLCBbNDkuMjA2MSwgMi4wNzI2XSwgWzQ5LjE3MDcsIDIuMTc5NF0sIFs0OC4zNzgzLCAzLjI5MDddLCBbNDkuMTM0MSwgMi40Mzk5XSwgWzQ4LjE2MDgsIDIuNzU0NV0sIFs0OC4xMzM1LCAyLjYxNDNdLCBbNDguMzIwNiwgMi4zMDQ4XSwgWzQ4Ljc4MywgMS41NzY2XSwgWzQ4LjkzOTYsIDMuMjc4NF0sIFs0OC45MTgsIDMuMzE4XSwgWzQ4LjgwNDUsIDMuNDE4Nl0sIFs0OC4zNjkxLCAzLjI2MTddLCBbNDguMzY1MSwgMy4yNTFdLCBbNDguMzI2MywgMi4zMDkyXSwgWzQ4LjMxMTIsIDIuMzAwMl0sIFs0OC4yODg1LCAyLjAzMThdLCBbNDkuMDg5NSwgMi43ODk1XSwgWzQ4Ljg3MjksIDMuNDA1NV0sIFs0OC42OTEyLCAzLjQ3MjVdLCBbNDguNDMxNSwgMy4zOTQ4XSwgWzQ4LjcyODQsIDEuNjA4OV0sIFs0OS4wNTEsIDMuMTkwOF0sIFs0OC4zMDkxLCAyLjI5MTZdLCBbNDguMjg2NCwgMi4wMzY5XSwgWzQ4LjY1OTQsIDMuNDQ5NV0sIFs0OC4yNjgzLCAyLjQyMV0sIFs0OC4zMzA4LCAyLjIzMzVdLCBbNDkuMjA1MSwgMi4wOTE2XSwgWzQ4Ljg5NDIsIDMuMzY5Ml0sIFs0OC40Mzg4LCAzLjQwNDNdLCBbNDguNDI0LCAzLjM5NjhdLCBbNDguMjU1OCwgMy4wNDYyXSwgWzQ5LjIzMywgMS43MTM1XSwgWzQ5LjE1MSwgMi4zNjIxXSwgWzQ5LjExMTEsIDIuNTUyNl0sIFs0OC42Mzk5LCAzLjUyNDVdLCBbNDguNDc5OSwgMy4zODU4XSwgWzQ4LjQ3MzUsIDMuMzkwNV0sIFs0OS4wMDk3LCAxLjQ3NF0sIFs0OS4wNTc4LCAxLjQ3MjVdLCBbNDkuMDgyNywgMS41MTM2XSwgWzQ5LjA3MjMsIDEuNTM4XSwgWzQ5LjA3MjUsIDEuNTUwMl0sIFs0OS4wNjk4LCAxLjU1OTRdLCBbNDkuMjA2MiwgMS42NzIyXSwgWzQ4LjI4MjgsIDIuNDE5OF0sIFs0OS4xOTA2LCAyLjAzNTZdLCBbNDguNDgxNSwgMy4zOTQxXSwgWzQ4LjU3MzcsIDEuNzU4NF0sIFs0OC41NzQ0LCAxLjcyMzNdLCBbNDguNjk4NiwgMS41ODQ2XSwgWzQ4LjMwNzcsIDEuOTU5Nl0sIFs0OC42NDEyLCAxLjY0NDFdLCBbNDguNDIwNCwgMS45MzIyXSwgWzQ4LjY0OTYsIDEuNjIxMl0sIFs0OC4zMDg5LCAyLjI0NjZdLCBbNDguMzIzNSwgMS45NzQ4XSwgWzQ4LjM2MDIsIDEuOTgyNV0sIFs0OS4wOTc5LCAxLjYyMTJdLCBbNDkuMTA1MywgMi41NTc2XSwgWzQ4LjM3MjQsIDMuMzYxOV0sIFs0OC4xODMsIDIuOTM3XSwgWzQ4Ljg3MzYsIDMuMzgwOF0sIFs0OC4xMzM5LCAyLjgyNDJdLCBbNDkuMjA4NSwgMi4wNzcyXSwgWzQ4Ljg2MDcsIDEuNTgxMV0sIFs0OC4xOTc3LCAyLjUyMjhdLCBbNDguMzA4NSwgMi4zNTgyXSwgWzQ5LjE5MDUsIDEuNzQwNV0sIFs0OS4wODMzLCAyLjc2ODNdLCBbNDkuMTczMiwgMi4yOTU3XSwgWzQ4Ljg2NDksIDMuNDI0N10sIFs0OC40MjQsIDMuMzk3M10sIFs0OS4xMjQyLCAyLjU1NDldLCBbNDguMjA1NiwgMi45Nzk5XSwgWzQ4LjMwMjUsIDIuNDE3NF0sIFs0OS4yMDU5LCAxLjY3MzJdLCBbNDguOTE2NiwgMy4zNDYxXSwgWzQ4LjUzNSwgMy40NjY0XSwgWzQ4LjM2MjEsIDMuMTEyOF0sIFs0OC4yOTkzLCAzLjAyNTldLCBbNDguOTA5LCAxLjU0MThdLCBbNDguMTQxMiwgMi41NTY3XSwgWzQ5LjA3MzgsIDIuODc4NF0sIFs0OC4xNzQ3LCAyLjkzNDZdLCBbNDguMTM0NSwgMi42MTYxXSwgWzQ4LjEyNzQsIDIuNDY4Ml0sIFs0OC4zMjA2LCAyLjE4NDZdLCBbNDguMTQwNiwgMi44NDYyXSwgWzQ4LjMwNDUsIDIuMTU1N10sIFs0OS4wODEsIDMuMTU3Nl0sIFs0OS4wMDA4LCAzLjIwMzRdLCBbNDguMjg2MSwgMi4wMl0sIFs0OC4yOTU2LCAyLjQyMjRdLCBbNDkuMDkxNywgMy4wNl0sIFs0OS4xMTM5LCAzLjA2NzddLCBbNDkuMDkxMSwgMy4xNjA2XSwgWzQ5LjAxMywgMy4xODA1XSwgWzQ5LjExNDQsIDMuMDY3N10sIFs0OS4wODYyLCAzLjA0NzhdLCBbNDguMzI3OCwgMi4yMzE5XSwgWzQ4Ljc2NzQsIDEuNTgyOV0sIFs0OC45MTM5LCAzLjM0MTldLCBbNDguMzU4LCAzLjA5MzRdLCBbNDguNjM3NCwgMS42NTA0XSwgWzQ4LjEyOTcsIDIuODIwOV0sIFs0OC4yNjA5LCAyLjQyM10sIFs0OC44NDQsIDEuNTgzNV0sIFs0OS4wNywgMS41MzA5XSwgWzQ5LjE3MjksIDEuOTM0OF0sIFs0OS4xODI5LCAyLjE1NjNdLCBbNDkuMTUyNSwgMi4yMjAzXSwgWzQ4Ljc0MDQsIDMuNDM5Ml0sIFs0OC40NjgxLCAzLjM5ODFdLCBbNDguNDM2LCAzLjM5NTFdLCBbNDguNDE0MSwgMy40MTE4XSwgWzQ4LjEzMjMsIDIuNTgyOF0sIFs0OC4xOTM5LCAyLjUyMDNdLCBbNDguMjYsIDIuNDI1OV0sIFs0OS4wOTU2LCAyLjY2MjJdLCBbNDguNzIyOCwgMy40NjcyXSwgWzQ4LjQ4NzUsIDMuNDEwOV0sIFs0OC40ODU2LCAzLjM5ODddLCBbNDguNDE3MywgMy40MDMyXSwgWzQ4Ljg0MDEsIDEuNTkyOV0sIFs0OC4xOTM2LCAyLjk2OTFdLCBbNDguMzI2OCwgMi4xODU1XSwgWzQ5LjE1NTYsIDIuMjU4N10sIFs0OS4wODQ1LCAyLjU3ODldLCBbNDguOTUwNywgMy4yNTk3XSwgWzQ4LjE3OTIsIDIuOTM1NF0sIFs0OC4zMTE1LCAyLjM4MzZdLCBbNDguMjY2OSwgMy4wNDYyXSwgWzQ4Ljg1MTksIDMuNDg1Ml0sIFs0OC42NDU1LCAzLjQ1NjFdLCBbNDguNDIzMSwgMy40MDI4XSwgWzQ4LjQxNDksIDMuNDA0M10sIFs0OC4zNTY5LCAzLjEwMV0sIFs0OC42NTk4LCAzLjQ0ODZdLCBbNDguNDgxMiwgMy4zOTM2XSwgWzQ4LjkxNTcsIDMuMzQ0OF0sIFs0OC44OTIyLCAzLjM3MDldLCBbNDkuMDc3MSwgMi43MjAyXSwgWzQ5LjA3MDIsIDIuNzE0Ml0sIFs0OS4wODM2LCAyLjc4ODldLCBbNDkuMDYwOSwgMi43NTA4XSwgWzQ4LjMwNzEsIDIuNDEzMV0sIFs0OC4zMDk0LCAyLjI2NTJdLCBbNDguOTUzNiwgMS41MTFdLCBbNDguNzg5NiwgMS41NzY2XSwgWzQ4LjU4NjYsIDMuNDkwM10sIFs0OC40Nzk5LCAzLjM4MzVdLCBbNDguMzgwOCwgMy4yODYxXSwgWzQ5LjE4MzMsIDEuOTc2M10sIFs0OS4xODAzLCAxLjc5MzZdLCBbNDkuMDkwOCwgMy4wNTk2XSwgWzQ5LjE4NDgsIDEuNzQyNF0sIFs0OS4xNDk2LCAyLjQyMjZdLCBbNDguOTIwNSwgMy4zMTUzXSwgWzQ4LjkxOCwgMy4zNTA0XSwgWzQ4LjM3MDIsIDMuMTkxOF0sIFs0OC4xNjI5LCAyLjc3MzFdLCBbNDguMjYwMiwgMi40MjRdLCBbNDkuMTEzOSwgMi41NTJdLCBbNDguNDg3NSwgMy4zOTk4XSwgWzQ4LjM5ODIsIDMuNDE2NV0sIFs0OS4wNDIxLCAzLjE4MTldLCBbNDkuMDI4NywgMy4xNzQ0XSwgWzQ5LjAyNjYsIDMuMTYzN10sIFs0OC42MTY1LCAzLjU1ODFdLCBbNDguMzc2OCwgMy4yOTQ0XSwgWzQ4LjM1MjIsIDMuMDQyOV0sIFs0OC4zMTkxLCAzLjAyNjJdLCBbNDkuMDQ3NiwgMS40NDk5XSwgWzQ5LjA4MTksIDEuNTEwOV0sIFs0OS4wODM4LCAxLjUxMjRdLCBbNDkuMDgyNSwgMS41MTM5XSwgWzQ5LjA3ODUsIDEuNTczNF0sIFs0OS4wODQsIDEuNTk5M10sIFs0OC4yMDU2LCAyLjk3MzFdLCBbNDkuMTc4NCwgMS45ODg5XSwgWzQ5LjEwMTgsIDIuNTU4NV0sIFs0OC4zNTQzLCAzLjA0MzVdLCBbNDguODExNiwgMy40NDE0XSwgWzQ4LjgxMjMsIDMuNDMyMl0sIFs0OC40NDQsIDEuODY0XSwgWzQ4LjY5OTMsIDEuNTg1MV0sIFs0OC4yOTk4LCAxLjk2MzFdLCBbNDguMzYzNCwgMS45ODldLCBbNDguMjg3MiwgMS45NzUzXSwgWzQ4LjI4NTgsIDMuMDI5OF0sIFs0OC40NzUxLCAxLjc5ODVdLCBbNDguMTMwNSwgMi44MTIxXSwgWzQ4LjYzMiwgMS42NTA2XSwgWzQ4LjQ2NzEsIDEuODM2Nl0sIFs0OC44NjYzLCAzLjRdLCBbNDguODAzOSwgMy40MTIyXSwgWzQ4Ljc4NDUsIDMuNDI0NF0sIFs0OC42NDEyLCAzLjQ1MzNdLCBbNDguMzEyNywgMS45NzkxXSwgWzQ4LjkyMTgsIDEuNTM4Nl0sIFs0OS4xNzYyLCAyLjI5NjddLCBbNDguODI5NiwgMS41NzkxXSwgWzQ5LjIwMjcsIDEuNzE1NV0sIFs0OS4xNDk1LCAyLjQyMTZdLCBbNDguNDg2OCwgMy40MDgxXSwgWzQ4LjQ2MjcsIDMuMzk0NF0sIFs0OC4zNzMzLCAzLjE4MjVdLCBbNDguMzE2MiwgMi4zMDE5XSwgWzQ5LjE4MTUsIDIuMDEwNl0sIFs0OS4xNzE1LCAyLjI5MTJdLCBbNDguODM4OCwgMy40NjEzXSwgWzQ4LjgzNzQsIDMuNDYyOF0sIFs0OC43MDc0LCAzLjQ2NDNdLCBbNDguMjE2MiwgMy4wMDg2XSwgWzQ5LjE0OTUsIDIuNDI1NF0sIFs0OC4xOTgyLCAyLjk3MzldLCBbNDguMTI3MywgMi42NTY5XSwgWzQ4LjE3ODUsIDIuNTA5XSwgWzQ5LjE3MzUsIDEuOTMzOV0sIFs0OC4zNzU5LCAzLjMwOTVdLCBbNDguMzI2NCwgMy4wMzY2XSwgWzQ4LjI0MDEsIDIuNDg2N10sIFs0OC4zMTkzLCAyLjIzOTddLCBbNDkuMTgwNSwgMi4zMjIxXSwgWzQ4Ljc4MzgsIDEuNTc3NV0sIFs0OS4wNTExLCAzLjE4OThdLCBbNDguMTI1NiwgMi40NTldLCBbNDkuMDc3MSwgMi44OTVdLCBbNDguOTQ2NSwgMy4zMDA2XSwgWzQ4LjM1ODIsIDMuMDU4M10sIFs0OC4xMzY3LCAyLjcyMDNdLCBbNDguNDI5NywgMy4zOTUxXSwgWzQ4LjEzNDgsIDIuNDUzM10sIFs0OC4zMTU2LCAyLjQwNDVdLCBbNDkuMTcyMywgMS45MjRdLCBbNDkuMTg1MSwgMS43NzY0XSwgWzQ4Ljc1MTYsIDEuNjIwNF0sIFs0OC43Nzk3LCAzLjQzMDVdLCBbNDguMzkzNiwgMy4zOTU0XSwgWzQ4LjE2NywgMi43NzgzXSwgWzQ4LjMxNTMsIDIuMzk4OF0sIFs0OC4zMTE1LCAyLjM4MjFdLCBbNDguMzI5NCwgMi4yMjk3XSwgWzQ4LjkxMSwgMy4zNzYxXSwgWzQ4LjUzMzYsIDMuNDIzNF0sIFs0OC4zODk3LCAzLjQwMl0sIFs0OC40NDQ0LCAzLjQwNTJdLCBbNDguOTIyNSwgMS41Mzg0XSwgWzQ5LjE4MzksIDEuOTczNF0sIFs0OS4wMzExLCAzLjE3NjZdLCBbNDguODg4NiwgMy4zODJdLCBbNDguODIwOSwgMy40NzA0XSwgWzQ4LjQ1MTcsIDMuNDA2NF0sIFs0OS4wNzk5LCAyLjU4NDhdLCBbNDguMzA4NiwgMi4zNThdLCBbNDguMzEyNywgMi4xNjldLCBbNDguODc0NiwgMS41NDc0XSwgWzQ5LjA4MTUsIDIuOTEzXSwgWzQ4LjUzMTIsIDMuNDI5OV0sIFs0OC4xMzc5LCAyLjcyNDRdLCBbNDkuMTgwMiwgMS42NjkyXSwgWzQ4Ljk0NTIsIDMuMjYwNV0sIFs0OC4zNzM0LCAzLjE2OTFdLCBbNDguNDEyNCwgMy40MjIxXSwgWzQ4LjQ4NzksIDMuNDA4NF0sIFs0OC45OTcyLCAxLjQ3NjJdLCBbNDguOTkzOCwgMy4yMDkzXSwgWzQ4LjczNzYsIDMuNDQyNF0sIFs0OC45NjQ0LCAxLjQ5MTldLCBbNDkuMTY1OSwgMS42NjQ3XSwgWzQ4LjE2MjksIDIuNzQ3OF0sIFs0OC4xMjg3LCAyLjcxMjddLCBbNDguMTIzOSwgMi42NjA5XSwgWzQ4LjMyNDcsIDIuMzA4Nl0sIFs0OC4zNTc0LCAzLjA2MjZdLCBbNDguOTIwOSwgMy4zMTQzXSwgWzQ4Ljg2MDYsIDMuNDQzOF0sIFs0OC42MzYzLCAzLjQ2NTJdLCBbNDguODkwOSwgMy4zNzUxXSwgWzQ4LjI1MDcsIDMuMDM2N10sIFs0OS4wNzUsIDEuNTEyN10sIFs0OS4wNzg0LCAxLjU3ODJdLCBbNDkuMDgyNywgMS41OTQ0XSwgWzQ5LjA4MDEsIDEuNjEzM10sIFs0OC4yOTYyLCAyLjQyMTNdLCBbNDguMzEyMiwgMi4yNzM0XSwgWzQ5LjE5MzEsIDEuNjcwNl0sIFs0OS4wODMzLCAxLjU5NjJdLCBbNDkuMTk2NCwgMi4wNDYzXSwgWzQ5LjE3MzUsIDIuMTkxMl0sIFs0OC4zNzM1LCAzLjMyMjRdLCBbNDguODM3NCwgMy40NjI2XSwgWzQ4Ljc4MzMsIDMuNDM1Ml0sIFs0OC40ODcyLCAxLjc5MTddLCBbNDguNjExNiwgMS42ODk2XSwgWzQ4LjYxMjQsIDEuNzAwM10sIFs0OC4yODY0LCAxLjk4OTldLCBbNDguNjE0NSwgMS43MTRdLCBbNDguNjE4OCwgMS42Nzg5XSwgWzQ4LjY0LCAzLjQ1MzZdLCBbNDguMTU3OSwgMi44MDc2XSwgWzQ4LjQ0MjEsIDEuODY2NF0sIFs0OC4zMTg1LCAxLjk3OTJdLCBbNDguNzY0NCwgMy4zOTg1XSwgWzQ4LjUzNDYsIDMuNDY1NV0sIFs0OC41MzM0LCAzLjQ2MjVdLCBbNDguNTMyMiwgMS43Nzc5XSwgWzQ4Ljg0MiwgMS41OTA0XSwgWzQ5LjIyOTksIDEuNzAzXSwgWzQ4LjMzMDgsIDIuMjM1OF0sIFs0OC41MDQxLCAzLjQyOTVdLCBbNDkuMjI3NiwgMS43MDIxXSwgWzQ4LjMwODEsIDIuMjk1N10sIFs0OC4zNzUsIDMuMzE5Nl0sIFs0OC45NDM2LCAzLjI5MjJdLCBbNDguNzgyOCwgMy40MDhdLCBbNDguNzM1MiwgMy40Njc1XSwgWzQ5LjEzMTksIDEuNjU3N10sIFs0OC4xODMsIDIuOTM4OF0sIFs0OS4xMDEyLCAyLjY0XSwgWzQ4Ljk5OTksIDMuMjA3NF0sIFs0OS4xMzUsIDIuNDY3NV0sIFs0OS4xNjM3LCAyLjIyOV0sIFs0OC4xNjQ0LCAyLjgwMjVdLCBbNDguMTY1NSwgMi43Mzg1XSwgWzQ4LjMzMDksIDIuMzI4Nl0sIFs0OC4yMDUxLCAyLjk5MTddLCBbNDguMTgzMiwgMi45MzgyXSwgWzQ4LjE2OSwgMi45MzUyXSwgWzQ5LjA1NjgsIDMuMTgxMV0sIFs0OC4xNjg2LCAyLjc5OTVdLCBbNDguMTMxNywgMi41OTM4XSwgWzQ4LjE5NDUsIDIuNTIwNl0sIFs0OS4wMjkyLCAzLjE3MTldLCBbNDguMzE0OSwgMi4zOTVdLCBbNDkuMTA2NiwgMy4xMzM4XSwgWzQ5LjAwOTYsIDMuMTg3MV0sIFs0OS4wNTg4LCAzLjE4MTFdLCBbNDkuMDg2LCAzLjA0OTldLCBbNDguOTE2MSwgMy4zNTU2XSwgWzQ4Ljg5MjksIDMuMzY5M10sIFs0OS4wODg1LCAzLjA1ODVdLCBbNDkuMDE2NywgMy4xNjgzXSwgWzQ4LjI4NjYsIDIuMDAyMl0sIFs0OC4xNDEyLCAyLjg0ODNdLCBbNDguMTMxOCwgMi43MTczXSwgWzQ4LjEyNTUsIDIuNDQ4OV0sIFs0OC4zMTY1LCAyLjI1MjJdLCBbNDkuMTgxNSwgMi4zMjA5XSwgWzQ4LjkyOCwgMy4zNjc1XSwgWzQ4Ljg2NzQsIDMuNDI0XSwgWzQ4LjUxNTksIDMuNDIxXSwgWzQ4LjMxODcsIDIuMzk4NV0sIFs0OC4zMDk0LCAyLjM1NzJdLCBbNDkuMDc0OCwgMi45NzQ3XSwgWzQ5LjE2NDYsIDIuMTY4Ml0sIFs0OC4zNzA2LCAzLjEzNV0sIFs0OC40ODE2LCAzLjM5MjVdLCBbNDguODEwOSwgMS41ODIyXSwgWzQ4LjI4NTEsIDIuMDQyM10sIFs0OS4yMDk3LCAyLjA3NzRdLCBbNDkuMTgyNywgMi4xNTY2XSwgWzQ4Ljg2NzEsIDMuMzk5OV0sIFs0OC40LCAzLjM4MzJdLCBbNDguNjgzOSwgMy40NTg2XSwgWzQ4LjEzMjMsIDIuNDUwNl0sIFs0OC4zMTUsIDIuMzk4OF0sIFs0OC4zNjkyLCAzLjE5MzhdLCBbNDguODYwNCwgMy40NDUzXSwgWzQ4LjczODEsIDMuNDUzXSwgWzQ4LjYyODEsIDMuNTQ1OV0sIFs0OC41OTMyLCAzLjUxNF0sIFs0OC40OTE4LCAzLjQyODZdLCBbNDguNDg2MiwgMy40MDQyXSwgWzQ4LjQxNTQsIDMuNDA1N10sIFs0OC4zNywgMy4yMjQyXSwgWzQ4LjI4MDUsIDMuMDI2Ml0sIFs0OS4wOTMxLCAyLjYxMDNdLCBbNDkuMDk0OSwgMi42MTAzXSwgWzQ5LjA3ODgsIDIuNzIwMV0sIFs0OS4wNzU1LCAyLjc4NzFdLCBbNDkuMDc1MSwgMi45NzQ2XSwgWzQ4LjEyMTUsIDIuNjY5M10sIFs0OC4yODcyLCAyLjQyMjNdLCBbNDguMzMwNCwgMy4wNDM2XSwgWzQ4LjkxNDMsIDMuMzQyNF0sIFs0OC4yNTUyLCAyLjQ0NjRdLCBbNDguMzczMiwgMy4zMzY1XSwgWzQ4LjMxNjksIDIuNDAzOF0sIFs0OS4wODQ1LCAyLjk3MjNdLCBbNDkuMjA1NywgMi4wODA2XSwgWzQ4Ljk1OTYsIDMuMjU2MV0sIFs0OC44NTY4LCAzLjQ1MTNdLCBbNDguNDIzOSwgMy40MDFdLCBbNDkuMTY4LCAyLjI4OTVdLCBbNDguMzMxNywgMi4yNDQzXSwgWzQ4Ljc3MTYsIDEuNTg2MV0sIFs0OC40OTgxLCAzLjQzNDNdLCBbNDguODc1LCAzLjQwNThdLCBbNDguNzYwNiwgMy4zOTY4XSwgWzQ4LjYzNzYsIDMuNTE4Nl0sIFs0OS4xMTI2LCAzLjA3OThdLCBbNDguMTQwMywgMi43MzM5XSwgWzQ4LjE4OTIsIDIuNTE3NV0sIFs0OS4wODcyLCAyLjk0NzVdLCBbNDguMzY2NywgMy4yMTJdLCBbNDguMzM2OSwgMy4wMzY3XSwgWzQ4Ljk3MjQsIDMuMjUxOF0sIFs0OS4wMTM4LCAxLjQ3NzldLCBbNDguNzI0OCwgMS42MDM4XSwgWzQ5LjA3ODYsIDEuNThdLCBbNDkuMDgxMiwgMS41ODc3XSwgWzQ5LjE0MDIsIDEuNjUzMl0sIFs0OS4xNDI0LCAxLjY1MzJdLCBbNDkuMTQzMywgMS42NTMyXSwgWzQ5LjE3NjQsIDEuOTkyNl0sIFs0OC42OTc2LCAzLjQ3NjNdLCBbNDguNjM3NiwgMy41MTkxXSwgWzQ4LjYxMzcsIDEuNjk0Nl0sIFs0OC42NDIsIDEuNjQyOF0sIFs0OC43MDE1LCAxLjU4MDNdLCBbNDguNjE4NSwgMS42Nzk0XSwgWzQ4LjQ2NjEsIDEuODAxNF0sIFs0OC40ODI0LCAxLjc5MzddLCBbNDguNDcyOCwgMS44MDI5XSwgWzQ4LjYxNDQsIDEuNjkzMV0sIFs0OC42NzUyLCAxLjYwNDddLCBbNDguNDY5NCwgMS44MDI5XSwgWzQ4LjMxNTgsIDIuMTcxOV0sIFs0OC44ODk4LCAzLjM3ODZdLCBbNDguNDU1MywgMy40MDNdLCBbNDguNjM2NiwgMy40NTM2XSwgWzQ4LjMwMjEsIDIuMTEyM10sIFs0OS4yMjA3LCAxLjY5MTFdLCBbNDguODI2NiwgMS41ODQxXSwgWzQ5LjE4NDIsIDIuMzIxNl0sIFs0OS4wODQxLCAyLjU3OTNdLCBbNDguODQ4OCwgMy40NDkxXSwgWzQ4LjQ5MDcsIDMuNDI2Ml0sIFs0OC40OTA4LCAzLjQyMDJdLCBbNDguODkxNiwgMS41NTczXSwgWzQ4Ljk2MjUsIDEuNDk2M10sIFs0OS4yMDg1LCAyLjA5MTJdLCBbNDguNjUzLCAzLjQ2MDRdLCBbNDguMzIzMiwgMy4wMzIxXSwgWzQ4LjMxMjgsIDIuMjgyM10sIFs0OS4xNjM3LCAyLjIzMDVdLCBbNDguNTY0NCwgMy40NzM4XSwgWzQ5LjE3NjYsIDIuMjEyXSwgWzQ4Ljk0OTcsIDMuMjYxXSwgWzQ4Ljg2MjIsIDMuNDI3M10sIFs0OC44ODAzLCAzLjM4MjRdLCBbNDguMjA2NiwgMi45OTE3XSwgWzQ4LjEyNTMsIDIuNTE5MV0sIFs0OC4zMTM1LCAyLjE2MzhdLCBbNDguMzI0MSwgMy4wMzM4XSwgWzQ4LjkyODMsIDMuMzY3NV0sIFs0OC45MTQ5LCAzLjM3MzddLCBbNDguNDYxOSwgMy4zOTUxXSwgWzQ4LjM2OTksIDMuMTQ4MV0sIFs0OC42OTE3LCAxLjU5OTJdLCBbNDguMzY1NywgMy4xNDY2XSwgWzQ4Ljg4NDksIDEuNTYxMV0sIFs0OC4xOTI5LCAyLjk2NTVdLCBbNDguNTg3MywgMS43MDM3XSwgWzQ5LjE3MzQsIDIuMTg2Nl0sIFs0OC4zNzA0LCAzLjIyMzRdLCBbNDguODQ5NywgMy40NTA1XSwgWzQ4LjY3NzIsIDMuNDQ3NV0sIFs0OC42MTM3LCAxLjY2NjJdLCBbNDkuMTYyMSwgMS42NjM5XSwgWzQ4LjQ4NTUsIDMuMzk5OV0sIFs0OS4xMzU5LCAxLjY1NzNdLCBbNDkuMDA0OSwgMy4xOTY2XSwgWzQ4LjE0MDMsIDIuNTM3NV0sIFs0OS4yMTU3LCAxLjY4Ml0sIFs0OS4wODE2LCAyLjk0NDZdLCBbNDguODcxNywgMy4zODUzXSwgWzQ5LjE4MjIsIDEuNzg3N10sIFs0OS4xODY2LCAyLjExNDNdLCBbNDguNzgzOCwgMy40MDk0XSwgWzQ4LjY0MzgsIDMuNTE3N10sIFs0OS4xMDI4LCAzLjA1OTldLCBbNDguNjc2MiwgMS42MDU0XSwgWzQ4Ljc4MzcsIDMuNDFdLCBbNDguNjM3NywgMy41MTgzXSwgWzQ4LjQwMzQsIDEuOTMyMV0sIFs0OS4xNjQyLCAxLjg5XSwgWzQ4LjE5NjIsIDIuOTcyOV0sIFs0OC4xNjQ5LCAyLjc2NzJdLCBbNDguMzMwOSwgMi4yMzk4XSwgWzQ5LjE5MzMsIDEuNjcwN10sIFs0OS4xNzUsIDIuMjA3N10sIFs0OC44NjAzLCAzLjQzMjhdLCBbNDkuMDUyNCwgMy4xODIyXSwgWzQ4Ljc5MTEsIDEuNTc1M10sIFs0OS4wNzI0LCAyLjk4OF0sIFs0OS4xMTY1LCAyLjUzOThdLCBbNDguOTE3LCAzLjM0NjVdLCBbNDguMzYwNSwgMy4wNzUxXSwgWzQ4LjI4MDQsIDIuNDE4NF0sIFs0OC4zMTAzLCAyLjM1NTldLCBbNDkuMTAxNSwgMS42MjM5XSwgWzQ5LjA5MzQsIDIuNTcyNV0sIFs0OC43MTc3LCAzLjQ2ODJdLCBbNDguNTY0NSwgMy40NzQyXSwgWzQ4Ljg5MjMsIDMuMzcwNl0sIFs0OS4wODk2LCAxLjYyMDddLCBbNDguNDQyLCAxLjkzM10sIFs0OC45OTg5LCAxLjQ3ODhdLCBbNDkuMTEwNCwgMS42Mjk5XSwgWzQ5LjE3MzQsIDEuNjY4XSwgWzQ5LjA4NDgsIDMuMTU1MV0sIFs0OS4yMTQzLCAxLjY4MDJdLCBbNDkuMTg0NCwgMS43ODE1XSwgWzQ5LjE1MDYsIDIuMzk5OV0sIFs0OC45NDg4LCAzLjI2MjldLCBbNDguMzgxNywgMS45Njc2XSwgWzQ4LjQ1MjMsIDEuODM5Nl0sIFs0OC41NzUsIDEuNzU3Ml0sIFs0OC40NDU3LCAxLjkwNjZdLCBbNDguNzE2MSwgMS41OTQxXSwgWzQ5LjA5OTksIDMuMTUxOF0sIFs0OC42MTI3LCAxLjY5MDJdLCBbNDguNzA4NSwgMS41OTQxXSwgWzQ4LjQ1NywgMS45Mjk1XSwgWzQ4LjQ3ODEsIDEuNzkyM10sIFs0OS4xNTE0LCAxLjY1OTNdLCBbNDkuMDk3NCwgMi41NjIxXSwgWzQ4LjkxMTgsIDMuMzc1Nl0sIFs0OC44NjY4LCAzLjQxOTddLCBbNDguMzk5OSwgMy40MTY3XSwgWzQ4LjM1MywgMy4wNDMyXSwgWzQ5LjEyNzgsIDEuNjUyN10sIFs0OC4xMjg3LCAyLjQ4MTFdLCBbNDguMzgzOSwgMS45NjkzXSwgWzQ4LjQ1MjYsIDEuOTI5N10sIFs0OS4wOTA2LCAyLjk2NDRdLCBbNDkuMTU5MywgMi4zNzEzXSwgWzQ4LjM2NzMsIDMuMTI2Ml0sIFs0OC45NjI4LCAxLjQ5NTddLCBbNDkuMDI3MiwgMy4xNjZdLCBbNDkuMTY1NywgMi4yODY1XSwgWzQ5LjA5MDMsIDIuNTc5M10sIFs0OC44NjM2LCAzLjQwOF0sIFs0OC41ODYyLCAzLjQ5MDJdLCBbNDguNDYwNywgMy4zOTg4XSwgWzQ4Ljk4MzEsIDMuMjI3XSwgWzQ4Ljk4MTgsIDEuNTAzMl0sIFs0OS4wODQ0LCAyLjk5MjFdLCBbNDkuMDg1NSwgMi45OTUzXSwgWzQ4LjkzOCwgMy4zMTFdLCBbNDguODY3LCAzLjQyMzhdLCBbNDkuMTY0NCwgMi4xNzA2XSwgWzQ5LjE1NTYsIDIuMjU5XSwgWzQ4LjI5NDgsIDIuMDUyMl0sIFs0OC40NjU4LCAxLjgxNDhdLCBbNDguNzA4OCwgMS41OTIyXSwgWzQ5LjE3OTgsIDIuMjE5OF0sIFs0OC4yODk4LCAyLjA0OTRdLCBbNDguMTI1NSwgMi41MjJdLCBbNDguMjE2MSwgMi41MTQzXSwgWzQ4LjI1MDksIDIuNDc2Ml0sIFs0OC4zMjA2LCAyLjQwM10sIFs0OC4zMTIxLCAyLjM4OTNdLCBbNDkuMDg4NywgMy4wMDRdLCBbNDkuMTA4NSwgMy4xMDAxXSwgWzQ4LjE0MzYsIDIuNzk3OV0sIFs0OC4zMTY3LCAyLjM0ODJdLCBbNDkuMDkwOSwgMy4wMTYyXSwgWzQ5LjA4ODYsIDMuMDM0NF0sIFs0OS4xMTA0LCAzLjA5MzldLCBbNDkuMDI5MiwgMy4xNzAxXSwgWzQ5LjA4NjUsIDMuMDI4NF0sIFs0OS4wODY2LCAzLjA0NjZdLCBbNDguMTMxMywgMi41NzQ4XSwgWzQ4LjI4NTYsIDIuMDQyOV0sIFs0OC42MiwgMS42ODY1XSwgWzQ5LjE4ODcsIDIuMDMyMl0sIFs0OS4wNzMxLCAyLjk3OTddLCBbNDguODkyMiwgMy4zNzIzXSwgWzQ4Ljc1MjMsIDMuNDM2M10sIFs0OS4xNjQ4LCAxLjg5NDldLCBbNDguMzIxLCAyLjI0MTddLCBbNDguOTc1MiwgMS41MTE4XSwgWzQ4LjM3NiwgMy4yNjg0XSwgWzQ4Ljg1OTksIDMuNDM2Ml0sIFs0OC44NDg3LCAzLjQ0OTldLCBbNDguNzc5NSwgMy40M10sIFs0OC4yOTksIDIuMTU3NV0sIFs0OC45NDA3LCAxLjUwMjVdLCBbNDkuMTcxNywgMS44MzcxXSwgWzQ5LjA3MTEsIDIuOTg2OV0sIFs0OC40ODE3LCAzLjM5NF0sIFs0OC45ODIsIDEuNTA0NV0sIFs0OC41ODA1LCAzLjQ4NTNdLCBbNDguMzA0NiwgMi4xNjFdLCBbNDguNDEzOCwgMy40MjE5XSwgWzQ4LjYzMzUsIDMuNTE5MV0sIFs0OC44NzU4LCAzLjQwNDhdLCBbNDguODYzNSwgMy40MDc4XSwgWzQ4Ljg2NTYsIDMuNDI0NV0sIFs0OC44MDA3LCAzLjQyM10sIFs0OC43ODUxLCAzLjQzODJdLCBbNDguNTQ1MywgMy40ODFdLCBbNDkuMTAyNCwgMi42MjkxXSwgWzQ5LjEsIDIuNjQ2XSwgWzQ5LjA4OSwgMi43ODYyXSwgWzQ5LjA5MDgsIDIuNzkzOV0sIFs0OS4wNzYxLCAyLjg4MzhdLCBbNDkuMDgwOSwgMi45MTQyXSwgWzQ5LjA3MzgsIDIuNzg0N10sIFs0OS4wNzY5LCAyLjg1MDJdLCBbNDkuMDgzNiwgMi42ODExXSwgWzQ4LjE3MjMsIDIuNTEzN10sIFs0OC4zMzcxLCAyLjE5ODJdLCBbNDguNzM2MiwgMS42MTYyXSwgWzQ5LjExOCwgMi41MDNdLCBbNDguNjAwOSwgMy41MDddLCBbNDguNDcwNSwgMy4zOTEyXSwgWzQ4LjI3MzcsIDMuMDM0NF0sIFs0OC44NzQyLCAzLjM4MDVdLCBbNDguNjM3MywgMy40NzY2XSwgWzQ4LjM3ODksIDMuMjcyMl0sIFs0OS4yMzI2LCAxLjcxNzFdLCBbNDguMzE1NSwgMi4zMDE3XSwgWzQ4LjYxODcsIDMuNTU3OV0sIFs0OC43MTc1LCAxLjU5NTJdLCBbNDguMjk4NSwgMi4xMjg1XSwgWzQ4Ljc0MDIsIDEuNjIyN10sIFs0OS4xMDc1LCAxLjYyOTZdLCBbNDguODQyNSwgMy40NjYyXSwgWzQ4LjMwNDUsIDIuNDE0OF0sIFs0OC40ODYsIDMuNDAzNV0sIFs0OC4zMjk2LCAyLjMyNjRdLCBbNDkuMTM2MSwgMi40NDg0XSwgWzQ4Ljg3NTQsIDMuNDA1OF0sIFs0OC43MDE0LCAzLjQ3MTVdLCBbNDguMTYzMywgMi43NzM3XSwgWzQ4LjMyODMsIDIuMjMyNF0sIFs0OS4wNjk3LCAyLjcxMjddLCBbNDkuMDc1NiwgMi45NzQ5XSwgWzQ4Ljg2NTEsIDMuNDAyN10sIFs0OS4wMTg3LCAxLjQ3MTZdLCBbNDkuMDI3MSwgMS40NTc5XSwgWzQ5LjAyODUsIDEuNDU3OV0sIFs0OS4wNjY1LCAxLjUwOTddLCBbNDkuMDg0MSwgMS41MDY3XSwgWzQ5LjA3MjgsIDEuNTE4OV0sIFs0OS4wNjk2LCAxLjUyMDRdLCBbNDkuMDk5OCwgMy4xNTY2XSwgWzQ5LjA3MjIsIDEuNTQ3OF0sIFs0OC4xMjQxLCAyLjY5MTJdLCBbNDguMjI2NSwgMi41MDY3XSwgWzQ4LjMxMDQsIDIuMTUzMV0sIFs0OC4zOTcsIDMuMzkxMV0sIFs0OC41NjA2LCAxLjc2NjldLCBbNDguNzA5NSwgMS41OTMxXSwgWzQ4LjMxMzcsIDEuOTY5Nl0sIFs0OC40NDIsIDEuODY3NV0sIFs0OC42MTkzLCAxLjY4M10sIFs0OC42MDcyLCAxLjcxODFdLCBbNDguNDQzNiwgMS45MzQ1XSwgWzQ4LjMyNDEsIDIuMjQzNl0sIFs0OS4xMTA1LCAzLjA5NF0sIFs0OS4xMDk1LCAzLjFdLCBbNDkuMTA2MSwgMy4xMjc0XSwgWzQ4LjEyOTcsIDIuNzE0NV0sIFs0OC4xMjMzLCAyLjcwMzhdLCBbNDguOTU3NiwgMS40OTg1XSwgWzQ5LjE5OTksIDEuNzI0OF0sIFs0OS4wNjQ3LCAyLjc2NjNdLCBbNDguMzEyOCwgMS45NzkxXSwgWzQ4LjUzNiwgMS43Nzk0XSwgWzQ4LjE2NDUsIDIuNzkyMV0sIFs0OC4xMzg5LCAyLjYzOTddLCBbNDguODY2LCAxLjU1NDddLCBbNDkuMTc5NiwgMS44MjY4XSwgWzQ5LjE2NDUsIDEuODM2Ml0sIFs0OS4wNzY2LCAyLjcyMDRdLCBbNDkuMDc0MiwgMi43Mjk2XSwgWzQ5LjA3NzIsIDIuOTQxNV0sIFs0OC4xMjA2LCAyLjY2NjJdLCBbNDguNzc5OSwgMS41ODEyXSwgWzQ5LjA3MzcsIDIuODc5Nl0sIFs0OC40NzU1LCAzLjM4OTZdLCBbNDkuMTUxNiwgMi40MTU1XSwgWzQ4LjMwOTIsIDIuMzYxMV0sIFs0OC4zMzE3LCAyLjMyMTVdLCBbNDkuMDc4NywgMi45NzM5XSwgWzQ4Ljg2NDYsIDMuNDE0Nl0sIFs0OC44NDE4LCAzLjQ1MjddLCBbNDkuMDkyMSwgMy4wNTk3XSwgWzQ4LjMxNiwgMi4zOTk4XSwgWzQ4LjMxMjQsIDIuMjc0OF0sIFs0OS4xNzQyLCAyLjE2MDVdLCBbNDkuMTM0NiwgMi40NDI0XSwgWzQ4LjM1NzYsIDMuMDY1NF0sIFs0OS4wOTY0LCAzLjA1NTZdLCBbNDguMTIxOCwgMi42NzA5XSwgWzQ4LjE4NTgsIDIuNTE0XSwgWzQ5LjE0OTQsIDIuMzkyXSwgWzQ4LjY0MTUsIDMuNDUzMl0sIFs0OC43NDk4LCAxLjYyM10sIFs0OC4xNDk3LCAyLjc1NTRdLCBbNDguMjI2LCAyLjUwNjldLCBbNDguMjk4NiwgMi4xNjM4XSwgWzQ5LjA4MTQsIDIuOTMzN10sIFs0OC44ODk3LCAzLjM3ODJdLCBbNDguOTUzMywgMy4yNTk0XSwgWzQ4Ljg0MzIsIDMuNDQ1NF0sIFs0OC43NjA5LCAxLjU5NzddLCBbNDkuMjEyNiwgMS42NzY3XSwgWzQ4LjE0MDgsIDIuNTcwNl0sIFs0OC40OTE1LCAzLjQyMDRdLCBbNDguNDQwMSwgMS44OTQyXSwgWzQ5LjE4MDYsIDEuNzQxXSwgWzQ5LjE3NzIsIDIuMjE0XSwgWzQ5LjE1NiwgMi4zNjc5XSwgWzQ4Ljk3NDQsIDMuMjQ5M10sIFs0OC43Nzk3LCAzLjQyNzZdLCBbNDguNDg4NiwgMy40MDYyXSwgWzQ4Ljk0NzYsIDMuMjYxOF0sIFs0OC42OTQxLCAzLjQ3MDddLCBbNDkuMDYwNywgMi43NTI3XSwgWzQ5LjA4MTUsIDIuNTk3MV0sIFs0OC40NzczLCAzLjM4NjJdLCBbNDguMjA3NywgMy4wMDUyXSwgWzQ4Ljg4NDUsIDMuMzgzMl0sIFs0OC44NDIzLCAzLjQ1MDJdLCBbNDguMjUyOSwgMy4wNDYzXSwgWzQ4LjQ5LCAzLjQxOThdLCBbNDguNjQ0MSwgMy41MTA0XSwgWzQ5LjE3NTcsIDEuODE3NF0sIFs0OC4xNTk3LCAyLjc0MTldLCBbNDguMjg3NSwgMi40MjMyXSwgWzQ4LjMxNDIsIDIuMjk5N10sIFs0OS4wODMxLCAyLjc4OV0sIFs0OC43ODIxLCAzLjQ0MTZdLCBbNDguNTQ3MywgMy40ODU5XSwgWzQ4LjQyNDMsIDMuMzk0NV0sIFs0OC4zNzY2LCAzLjE3NjRdLCBbNDkuMTgzMSwgMS45NzM0XSwgWzQ4LjE1MzcsIDIuNzUzXSwgWzQ4LjMwOCwgMi40MTE2XSwgWzQ4LjU3MDEsIDEuNzY0MV0sIFs0OS4yMDUyLCAxLjY3MzRdLCBbNDkuMTUxOSwgMi40MDU0XSwgWzQ4LjUzMSwgMy40MjYzXSwgWzQ4LjkyMDYsIDMuMzE1XSwgWzQ4Ljg2NDQsIDMuNDE0MV0sIFs0OC44MTQxLCAzLjQ4NDFdLCBbNDguNDM5NCwgMy40MDQ5XSwgWzQ5LjE3NDEsIDEuODEzMl0sIFs0OS4xMTY0LCAyLjU0M10sIFs0OC42NDg2LCAzLjQ1NzNdLCBbNDguMzY2NywgMS45ODM5XSwgWzQ4LjM2NzYsIDEuOTgzOV0sIFs0OC42MzMsIDMuNTIxMV0sIFs0OS4xODQ2LCAyLjMwODNdLCBbNDkuMTg0OCwgMi4zMjA1XSwgWzQ4LjM1MTEsIDMuMTAwNF0sIFs0OC4yOTkzLCAyLjE0NTFdLCBbNDguNDE5NiwgMS45Mzk2XSwgWzQ5LjE2NjMsIDEuODM4Ml0sIFs0OS4wODA4LCAyLjkzNDddLCBbNDkuMDc5OSwgMi45MzQ3XSwgWzQ4LjQ0NzIsIDMuNDA1OF0sIFs0OS4xNTQsIDIuMzUzOF0sIFs0OS4wMDE3LCAzLjIwMzNdLCBbNDguMTM1NCwgMi44Mzc3XSwgWzQ5LjA3MDYsIDIuODYzNl0sIFs0OS4wMTc4LCAxLjQ3NDldLCBbNDkuMDY3MSwgMS41MV0sIFs0OS4wNjkxLCAxLjUyMzddLCBbNDkuMDcxOSwgMS41MzI5XSwgWzQ4LjgzNTIsIDEuNTk0Nl0sIFs0OS4wNzI2LCAxLjUzNzRdLCBbNDkuMDcyMiwgMS41NDUxXSwgWzQ5LjA3MDUsIDEuNTYxOF0sIFs0OS4xMDcsIDMuMTMwN10sIFs0OS4yMDQzLCAxLjY3NDZdLCBbNDguMTU2NSwgMi44NzFdLCBbNDguMTYwMSwgMi43NTUyXSwgWzQ5LjE4NTMsIDIuMzE3N10sIFs0OS4xNTIyLCAyLjQxMjFdLCBbNDguMzk5NCwgMy4zODM0XSwgWzQ4LjI5MzQsIDEuOTczNV0sIFs0OC4zNjU3LCAxLjk4NDJdLCBbNDguNDQ2NiwgMS44NDU1XSwgWzQ4LjQ1MywgMS45MjMyXSwgWzQ4LjU3MzYsIDEuNzI1XSwgWzQ4LjY4NTQsIDEuNjEwN10sIFs0OC4yODczLCAxLjk3NV0sIFs0OC4zNTUyLCAxLjk3MzVdLCBbNDguMzIzNywgMS45NzVdLCBbNDguMzA4MSwgMS45NTk4XSwgWzQ5LjE3MTEsIDEuOTM0OV0sIFs0OC45Mjc2LCAzLjMxMzFdLCBbNDguODA0NCwgMy40MzgxXSwgWzQ5LjIyOTgsIDEuNzAzXSwgWzQ4LjE4MjksIDIuOTRdLCBbNDguMTU2LCAyLjg2NjhdLCBbNDguMzMzOSwgMi4xOTE1XSwgWzQ4LjkyOTMsIDEuNTA3NF0sIFs0OS4xMTEzLCAyLjQ5MTZdLCBbNDguOTA3OSwgMy4zNzYyXSwgWzQ4LjY2MjMsIDMuNDQ0N10sIFs0OC42MDM1LCAzLjUwNDJdLCBbNDkuMTk0NywgMS43Mjk4XSwgWzQ5LjA3NzYsIDIuODkzM10sIFs0OS4xNTEyLCAyLjM4ODhdLCBbNDguMzU3OSwgMy4wOTddLCBbNDguMzUxMSwgMy4wNDIyXSwgWzQ4LjMwMzMsIDMuMDIxNF0sIFs0OC44NzQ5LCAzLjM5MzJdLCBbNDguMzcyMiwgMy4xNTcxXSwgWzQ4Ljg2MDgsIDEuNTc4NF0sIFs0OC4zMTUyLCAyLjE1MjFdLCBbNDguMjg2NSwgMi40MjE4XSwgWzQ4LjI5NiwgMi40MjE4XSwgWzQ4LjMyODIsIDIuMzI4OV0sIFs0OC4zMzA5LCAyLjMxOTddLCBbNDguMzI0LCAyLjI0MzVdLCBbNDguMjg4MywgMi4wNDY4XSwgWzQ4LjI4NDcsIDIuMDA3Ml0sIFs0OC4zMTY0LCAyLjI0NjVdLCBbNDguMjA2OCwgMi45OTY1XSwgWzQ5LjA4NjcsIDMuMDM5N10sIFs0OS4wOTEsIDMuMDU5NF0sIFs0OS4wNDY3LCAzLjE5MDZdLCBbNDkuMDMwNSwgMy4xNzY5XSwgWzQ5LjEwNjYsIDMuMTIzNF0sIFs0OS4wOTk5LCAzLjA1NjRdLCBbNDguMjk0LCAyLjA2NzNdLCBbNDguMjE4MywgMy4wMTAzXSwgWzQ4Ljg2NDcsIDEuNTcwN10sIFs0OC44OTMsIDMuMzY5M10sIFs0OC41NDU1LCAzLjQ3OTFdLCBbNDguODg3MiwgMS41NjJdLCBbNDkuMDkxMywgMy4wMTI3XSwgWzQ5LjE1NjEsIDIuMjU5OV0sIFs0OC4zNjcsIDMuMjEzNl0sIFs0OC43OTY0LCAxLjU3NzhdLCBbNDguOTk3NiwgMS40NzQyXSwgWzQ4LjYxMzEsIDEuNzE1OV0sIFs0OS4xNzA4LCAxLjk1MTRdLCBbNDguODEyMiwgMy40ODA5XSwgWzQ5LjE3NDQsIDIuMTgyNF0sIFs0OC4yMjcsIDIuNTEzNF0sIFs0OS4wNjk3LCAyLjcxMzFdLCBbNDkuMTIyMiwgMi41NDA4XSwgWzQ4Ljg5MjEsIDMuMzcxXSwgWzQ4Ljc0MDQsIDEuNjIyNF0sIFs0OC45Njg3LCAxLjQ5NTldLCBbNDkuMTA4OSwgMy4xMjE5XSwgWzQ4LjE1ODMsIDIuNTAyNF0sIFs0OC4yNjYzLCAyLjQyMDJdLCBbNDguMzc3MywgMy4yNzk1XSwgWzQ4Ljg2MDQsIDMuNDM4MV0sIFs0OC43ODUxLCAzLjQyNDRdLCBbNDguNzU0NSwgMy40MjU5XSwgWzQ4LjY1NjksIDMuNDUzM10sIFs0OC41NDMsIDMuNDgwN10sIFs0OS4wNzYsIDIuODgwNV0sIFs0OS4wNzc2LCAyLjkyMzNdLCBbNDkuMDg0MywgMi45NDQ1XSwgWzQ5LjA4NTQsIDIuOTU2N10sIFs0OS4wNzc2LCAyLjg1MDFdLCBbNDkuMDk0NywgMi42MTgzXSwgWzQ5LjA4MjksIDIuODM0N10sIFs0OS4wOTkxLCAyLjY0MTJdLCBbNDkuMDgwMywgMi45ODg4XSwgWzQ5LjA2NTcsIDIuNzA2N10sIFs0OS4wOTEsIDMuMDYwOF0sIFs0OS4xMDE1LCAzLjE0NjJdLCBbNDguNzU3NywgMS42MDk3XSwgWzQ5LjE2MzksIDIuMTY5M10sIFs0OS4xNTgzLCAyLjI2MjJdLCBbNDguODkwNywgMy4zNzZdLCBbNDguNzkxNiwgMy40NDNdLCBbNDkuMTI1NSwgMi40ODc4XSwgWzQ5LjEwODksIDMuMTIyNF0sIFs0OS4wOTYxLCAzLjE2MzVdLCBbNDkuMDM2OCwgMy4xNzg3XSwgWzQ4LjE2NDMsIDIuODAxN10sIFs0OC4xNjU0LCAyLjc5MjVdLCBbNDguMjU0NSwgMi40Mzg5XSwgWzQ4LjY1MTMsIDEuNjQyXSwgWzQ4Ljg2NTEsIDEuNTcwM10sIFs0OC4zNzQsIDMuMzA0OV0sIFs0OC4zMDMyLCAzLjAyMjhdLCBbNDguNjIxMywgMy41NTQ5XSwgWzQ4LjU0MTQsIDMuNDc1N10sIFs0OC4zMTUxLCAyLjM1MDldLCBbNDkuMTgwOCwgMS45NzFdLCBbNDkuMTUxNiwgMi4yMzM2XSwgWzQ5LjEwMSwgMi41MjQ3XSwgWzQ4LjY4NjQsIDMuNDY5NF0sIFs0OC44NDMyLCAxLjU4NjZdLCBbNDkuMjQsIDEuNzA5OV0sIFs0OC4xMjQzLCAyLjY3MjVdLCBbNDkuMDc5LCAyLjkzNjJdLCBbNDguNjQ1OCwgMy41MDE5XSwgWzQ4LjcwNDksIDMuNDY2OF0sIFs0OC44NjYyLCAzLjQwMTNdLCBbNDguMzc3MSwgMS45Nzk3XSwgWzQ4LjE1NjIsIDIuNDc5NF0sIFs0OS4yMzMyLCAxLjcxNTNdLCBbNDguOTQxOCwgMy4yNjRdLCBbNDguOTk2MywgMy4yMDldLCBbNDguNjA4MiwgMy41MjNdLCBbNDkuMDU1NiwgMS40NzM3XSwgWzQ5LjA1MTcsIDEuNDg3NF0sIFs0OS4wODQyLCAxLjUxMDNdLCBbNDkuMDY4NywgMS41MjFdLCBbNDkuMDgzLCAxLjU5NTddLCBbNDkuMDkzNCwgMS42MjMxXSwgWzQ5LjE1MjMsIDEuNjYxMl0sIFs0OC42MTk1LCAxLjY4MzldLCBbNDkuMTc4MiwgMS45NjY3XSwgWzQ5LjE1OTIsIDIuMzc0XSwgWzQ4Ljg5NzUsIDMuMzY5N10sIFs0OC41NjcxLCAxLjc2MzZdLCBbNDguNjE1LCAxLjY3MzddLCBbNDguMzQ3MywgMS45NzU1XSwgWzQ4LjY0OTIsIDEuNjM1Nl0sIFs0OC41ODE0LCAxLjcxMDNdLCBbNDguNjE3OCwgMS42NjE1XSwgWzQ4LjQ2MzYsIDEuODM1M10sIFs0OC42MTM5LCAxLjcxMDNdLCBbNDguNzEwMSwgMS41ODgzXSwgWzQ4LjYzNDYsIDEuNjQ5M10sIFs0OC4xNTU3LCAyLjgwMjldLCBbNDguMTY3MiwgMi43Nzg1XSwgWzQ4LjMxNTMsIDIuMzQ4N10sIFs0OC4zMDI4LCAxLjk2MTldLCBbNDkuMDkzLCAyLjY2NTddLCBbNDguNzgzOCwgMy40MTgyXSwgWzQ4LjYzMTUsIDMuNTM3Ml0sIFs0OC40ODc0LCAzLjRdLCBbNDguNDg2OSwgMS43OTE2XSwgWzQ4LjI3NzgsIDIuNDE4Nl0sIFs0OC43Nzc3LCAxLjU4MDVdLCBbNDkuMDc3NSwgMi44NTAxXSwgWzQ5LjA3NzMsIDIuODk1N10sIFs0OC44MDI4LCAzLjQzNF0sIFs0OC4zOTksIDMuMzgwN10sIFs0OC45ODE0LCAzLjIyOThdLCBbNDguODYsIDEuNTg0MV0sIFs0OC4xNjU3LCAyLjgwOTRdLCBbNDguMjc3MSwgMi40MTkyXSwgWzQ4LjQ0MjUsIDEuOTMzM10sIFs0OS4wOTIzLCAyLjYwOTddLCBbNDguNDg0MiwgMy40MDAzXSwgWzQ4LjE2NjksIDIuODAwMV0sIFs0OC4xMzIyLCAyLjU4ODJdLCBbNDguMTU0MSwgMi40NzM5XSwgWzQ4LjMxOTcsIDIuNDAwN10sIFs0OS4xOTkzLCAyLjA1NjNdLCBbNDguOTM5MSwgMy4yNjUyXSwgWzQ4Ljc4MzYsIDMuNDE0Nl0sIFs0OC42Nzc2LCAzLjQ0ODJdLCBbNDguNjA3NywgMS43MTcyXSwgWzQ4Ljc1NDIsIDMuNDAzOF0sIFs0OC42Mzc4LCAzLjUyMTFdLCBbNDguMzAwNCwgMy4wMjczXSwgWzQ4LjkwMjUsIDEuNTQyNF0sIFs0OC4xNjgxLCAyLjc5ODldLCBbNDguMTY2MywgMi43MzY0XSwgWzQ4LjMwNzcsIDIuMjY0XSwgWzQ4Ljg2MzgsIDEuNTcyMl0sIFs0OS4xNzY1LCAyLjIxMl0sIFs0OC45MjY5LCAzLjM2NzhdLCBbNDguODAzMiwgMy40MzQ4XSwgWzQ4Ljc4MzksIDMuNDA4OV0sIFs0OC43NTgsIDEuNjA5M10sIFs0OC45NTk5LCAxLjQ5ODFdLCBbNDkuMjIzNywgMS42OTI1XSwgWzQ5LjE2MjMsIDIuMjI0OF0sIFs0OC45MjcyLCAzLjM2OV0sIFs0OC45MzQzLCAzLjMxMjddLCBbNDguNzgyMywgMy40NDA3XSwgWzQ4Ljc2MzgsIDMuMzk4MV0sIFs0OC41OTk2LCAzLjUwNzldLCBbNDguOTUwOSwgMS41MDMxXSwgWzQ4LjEzMTUsIDIuNjAyN10sIFs0OC40MTYsIDMuNDA2N10sIFs0OC4xMzY1LCAyLjUzMjVdLCBbNDguMjU1MSwgMi40MzE5XSwgWzQ4LjMwOTUsIDIuMjk3OV0sIFs0OC44MDU1LCAxLjU4MDJdLCBbNDkuMTYzMiwgMi4yMjc3XSwgWzQ5LjE4MTUsIDEuNzg4Nl0sIFs0OC4yMDU0LCAyLjk5NV0sIFs0OC44Nzc1LCAxLjU1MzRdLCBbNDkuMTY4MiwgMS45MDQ3XSwgWzQ4Ljk4NzMsIDMuMjI5M10sIFs0OC4zNzQ5LCAzLjMxXSwgWzQ5LjE3NjEsIDEuOTk3Ml0sIFs0OC4xMzU2LCAyLjYxOTldLCBbNDkuMTgwNCwgMS42Njk4XSwgWzQ5LjE3OTgsIDIuMjE3NV0sIFs0OS4xODI1LCAyLjMxOTZdLCBbNDguODA3NiwgMy40MDY3XSwgWzQ4LjYxNiwgMy41NDk5XSwgWzQ4LjQ2MTIsIDMuMzk2XSwgWzQ5LjE3NiwgMS44MTk1XSwgWzQ4LjMwODQsIDIuMTUzOV0sIFs0OC42MTE1LCAxLjY4OTRdLCBbNDguODY3LCAxLjU1MzddLCBbNDguOTE5NCwgMS41NF0sIFs0OS4xNTI0LCAyLjQxMzFdLCBbNDguNjUzMSwgMy40NTk3XSwgWzQ4LjQzMzksIDMuMzk3Ml0sIFs0OC42NjUyLCAxLjYwMTVdLCBbNDkuMjIxMiwgMS42OTEyXSwgWzQ5LjA2MjIsIDMuMTgxN10sIFs0OC42NzE2LCAxLjYwNjldLCBbNDkuMTQwNiwgMi40NTcxXSwgWzQ4LjQxNzQsIDMuNDExNV0sIFs0OC40MTQ4LCAzLjQxMzJdLCBbNDguMzg4OSwgMS45NzMyXSwgWzQ4Ljg3MDQsIDEuNTQ2NF0sIFs0OC45Mjc2LCAzLjM2NzJdLCBbNDkuMDYyOCwgMy4xODE2XSwgWzQ4LjE2MiwgMi45MjQxXSwgWzQ4LjE0MTYsIDIuNTU4M10sIFs0OS4wODExLCAyLjY4NDhdLCBbNDkuMTUxNywgMi4yMzY2XSwgWzQ4Ljc4MTEsIDMuNDA4NF0sIFs0OC40OTA2LCAzLjQzMTNdLCBbNDguMTI4NSwgMi40NzEzXSwgWzQ4LjMwNDUsIDIuMTYwM10sIFs0OS4xOTg2LCAyLjA0NzVdLCBbNDguNjc3OSwgMy40NDg2XSwgWzQ4Ljk1OTEsIDMuMjU2NF0sIFs0OC4xNDUsIDIuNzUwOF0sIFs0OC4xMzYsIDIuNjIxMV0sIFs0OC44MDM5LCAzLjQzNzZdLCBbNDkuMDQ4MSwgMS40NTA0XSwgWzQ5LjA1OTQsIDEuNTAzN10sIFs0OS4wODExLCAxLjUxMjldLCBbNDguNDQxNCwgMS44NjldLCBbNDkuMDg0NiwgMS42MDI4XSwgWzQ5LjEyOTcsIDEuNjUzMV0sIFs0OS4xMzcsIDEuNjUzMV0sIFs0OS4xNDQ2LCAxLjY1MzFdLCBbNDkuMjMzMiwgMS43MTU2XSwgWzQ4Ljk4NSwgMS40NjI4XSwgWzQ5LjA3NDgsIDIuOTc0Nl0sIFs0OC42NTg2LCAzLjQ1MDRdLCBbNDguNDY2NSwgMy4zOTg2XSwgWzQ4LjY4ODUsIDEuNjExM10sIFs0OC4zMTAyLCAxLjk2MTldLCBbNDguNjEzOSwgMS43MTA0XSwgWzQ4LjQxOTksIDEuOTM5XSwgWzQ4LjU2NzYsIDEuNzYyMl0sIFs0OC4zNTgyLCAxLjk3NzFdLCBbNDguNjE0NiwgMS43MTQ5XSwgWzQ4LjQ1NjUsIDEuODM5OV0sIFs0OC41NTYzLCAxLjc3NDRdLCBbNDguNDkxNSwgMS43ODY2XSwgWzQ4LjI0MDYsIDIuNDgxNF0sIFs0OC4zMzA4LCAyLjI0MzZdLCBbNDkuMTcwMSwgMS45MzY3XSwgWzQ4LjI1MDksIDMuMDM1N10sIFs0OC44Njk2LCAzLjQwMTVdLCBbNDguMzY3NCwgMy4xNDddLCBbNDguNDgxMiwgMS43OTE2XSwgWzQ5LjE4MSwgMS44MDM2XSwgWzQ4Ljg4MjEsIDEuNTU5OF0sIFs0OS4wOTAxLCAyLjYwODJdLCBbNDguMzAyOCwgMi4yNTZdLCBbNDguMzkzNSwgMy4zNzM1XSwgWzQ4LjgxNTUsIDMuNDIyM10sIFs0OC43MzgsIDMuNDYwNF0sIFs0OC40ODE0LCAzLjM5MTddLCBbNDguMTI0NSwgMi40NTAxXSwgWzQ4LjE3ODEsIDIuNTA5Nl0sIFs0OC4zMzI0LCAyLjMyMzZdLCBbNDkuMTc0MywgMi4xOTcxXSwgWzQ5LjE1MzQsIDIuMjQ3NF0sIFs0OC4zMDQzLCAyLjE1NjVdLCBbNDguMTMxNSwgMi44MDEyXSwgWzQ4LjE2MjgsIDIuODEwNF0sIFs0OC4xNjMzLCAyLjc1ODZdLCBbNDguMTQ4MywgMi43NTU2XSwgWzQ4LjE3ODcsIDIuNTA4Nl0sIFs0OC4yMzk3LCAyLjQ4NTddLCBbNDguMjQ3NCwgMi40NzhdLCBbNDguMjY2OCwgMi40MjAyXSwgWzQ4LjMwOTcsIDIuMjY0Nl0sIFs0OS4wMDg2LCAzLjE5OF0sIFs0OS4wMzksIDMuMTgxM10sIFs0OS4wMDA4LCAzLjIwNF0sIFs0OS4wMDg4LCAzLjE5NjVdLCBbNDkuMDEyMywgMy4xNjk5XSwgWzQ5LjEsIDMuMTUzN10sIFs0OS4wODY1LCAzLjA1NDFdLCBbNDkuMDc1MSwgMi43ODY3XSwgWzQ4LjgzNDcsIDMuNDkxM10sIFs0OC41NDEyLCAzLjQ3NTldLCBbNDguNDkxNCwgMy40Mjg4XSwgWzQ4LjM2OTQsIDMuMTg3OF0sIFs0OC44MDcyLCAxLjU4MzRdLCBbNDkuMTg0MiwgMS43NzkxXSwgWzQ5LjEwODQsIDMuMTAxMV0sIFs0OS4xMDcyLCAzLjEzMTddLCBbNDkuMTczNSwgMS45NjA3XSwgWzQ4LjQ5MDMsIDMuNDI1NV0sIFs0OC42MzYzLCAzLjUxODRdLCBbNDguNDY5NywgMy4zOTY2XSwgWzQ4LjY0MjYsIDMuNTI3Nl0sIFs0OC43NjE3LCAxLjU4NTVdLCBbNDguODUzOSwgMy40NDkzXSwgWzQ4LjYxMzIsIDEuNzA2N10sIFs0OS4xOTA2LCAxLjczOTVdLCBbNDguMjk1MiwgMy4wMTldLCBbNDguOTExNCwgMy4zNzU4XSwgWzQ4LjQyMjgsIDMuNDA3N10sIFs0OC44Mzk4LCAzLjQ2MjddLCBbNDguNDAzNiwgMS45MzI5XSwgWzQ4Ljc2MSwgMS41OTQ1XSwgWzQ4Ljk3OSwgMS40NjhdLCBbNDkuMTI1OCwgMS42NTAyXSwgWzQ5LjE1NiwgMi4yNjk0XSwgWzQ4LjgxOCwgMy40NzQ2XSwgWzQ4LjE1ODgsIDIuODA4OV0sIFs0OC44Njc3LCAxLjU1OTNdLCBbNDguMzE0MSwgMy4wMjI0XSwgWzQ4Ljg0MjgsIDMuNDQ3N10sIFs0OC43NTQ4LCAzLjQzNF0sIFs0OC42NTYyLCAzLjQ1NTRdLCBbNDguNTMxLCAzLjQyOTVdLCBbNDguNDg3NCwgMy40MDgxXSwgWzQ4LjQ4MzYsIDMuMzk5MV0sIFs0OC4zNjc4LCAzLjIzODldLCBbNDguMzcyLCAzLjEzNjldLCBbNDguNjYyNiwgMy40NDE3XSwgWzQ5LjA3NzIsIDIuOTg3OV0sIFs0OS4wODI2LCAyLjc2OThdLCBbNDkuMTA0MiwgMi42MzU2XSwgWzQ4LjMzNTUsIDIuMjE5Nl0sIFs0OS4wOTg0LCAyLjY1NTVdLCBbNDkuMDc3OSwgMi43MjRdLCBbNDguMjA0OSwgMi45NzI2XSwgWzQ4LjI2NTYsIDIuNDIwNV0sIFs0OC40ODA2LCAzLjM4ODhdLCBbNDguMzA2OSwgMi40MTM0XSwgWzQ4Ljk3NTUsIDEuNTExNF0sIFs0OS4xNzIyLCAyLjI5NDZdLCBbNDguODg5OSwgMy4zNzkzXSwgWzQ4LjQxOTksIDEuOTM4N10sIFs0OS4xNjI2LCAxLjg4NTJdLCBbNDguMTM1NCwgMi42MTldLCBbNDguMTgyNSwgMi41MDk0XSwgWzQ4LjMxODMsIDIuMzAzNV0sIFs0OS4wOTcsIDIuODA4Ml0sIFs0OS4xNzE3LCAyLjMzNDFdLCBbNDguOTQ1NywgMy4yNjExXSwgWzQ5LjE1ODYsIDIuMzcwN10sIFs0OC42Mjg5LCAxLjY1NjVdLCBbNDguODE5NSwgMS41ODk1XSwgWzQ4LjE2NTIsIDIuNzM3MV0sIFs0OC4yNTQ4LCAyLjQzNTNdLCBbNDkuMDg5NSwgMi45NjI3XSwgWzQ4LjMwNTEsIDMuMDE1NV0sIFs0OC43Mzc5LCAzLjQ2OTddLCBbNDkuMDYyMywgMS40NjQ0XSwgWzQ5LjA2MTEsIDEuNDY0NF0sIFs0OS4wNiwgMS40Njg5XSwgWzQ5LjA4MDIsIDEuNTE2Ml0sIFs0OS4wNzExLCAxLjU1MjhdLCBbNDkuMTEwNiwgMS42MzA1XSwgWzQ5LjA0NjUsIDMuMTkwMl0sIFs0OS4xMzQ5LCAxLjY1MzRdLCBbNDguODA0MiwgMy40MTM4XSwgWzQ4LjYxMzksIDEuNzE1NF0sIFs0OC40MTU3LCAxLjkyNzNdLCBbNDguNDg2NywgMS43OTE2XSwgWzQ4LjU3MjMsIDEuNzM2OF0sIFs0OC42MzYyLCAxLjY0OTldLCBbNDkuMTA2MiwgMy4xMjc0XSwgWzQ4LjM2MjEsIDEuOTg2OF0sIFs0OC4yOTQ3LCAxLjk3NDZdLCBbNDguNDM4NSwgMS45MDE0XSwgWzQ4LjY1MzMsIDEuNjE0OF0sIFs0OS4wOTQsIDMuMDU3NF0sIFs0OS4wNTYxLCAzLjE4MDldLCBbNDguMjc0NiwgMi40MTg5XSwgWzQ5LjEwNDgsIDIuNjM1M10sIFs0OS4wODQ2LCAyLjgyNzNdLCBbNDguNjU2NCwgMy40NTQ4XSwgWzQ4LjI5NSwgMy4wMTg4XSwgWzQ4Ljg2MjUsIDEuNTc1Ml0sIFs0OS4wODQ0LCAxLjYwMDldLCBbNDkuMDgwNSwgMy4xNTg2XSwgWzQ4LjMxMDksIDIuMjk5OF0sIFs0OC40MjQ1LCAzLjM5NzVdLCBbNDkuMTg5OCwgMi4wOTY5XSwgWzQ5LjE1MTMsIDIuMjI5Nl0sIFs0OC45MzkxLCAzLjI2NDldLCBbNDguODc1MSwgMy4zOTc0XSwgWzQ4LjY5NCwgMy40NzA2XSwgWzQ4LjI1NTgsIDIuNDI5OV0sIFs0OC4yODYyLCAyLjAwMzFdLCBbNDguNDY3NSwgMS44MzEyXSwgWzQ5LjA4NzksIDIuOTYwM10sIFs0OC4yMTQyLCAzLjAwNzFdLCBbNDguNjg5NSwgMy40NzJdLCBbNDguMjQ4OSwgMy4wMzE1XSwgWzQ4LjkxNiwgMy4zNDU1XSwgWzQ4LjM4ODgsIDEuOTczNF0sIFs0OC45NTEzLCAxLjUwMzJdLCBbNDkuMTI3MiwgMS42NTAzXSwgWzQ5LjE3MzksIDIuMjIzOV0sIFs0OC44MDI1LCAzLjQzM10sIFs0OC43NDg3LCAzLjQzNzVdLCBbNDguNjI5NSwgMy41NDI2XSwgWzQ4LjEyOTksIDIuODE3NF0sIFs0OC41NTU1LCAxLjc3NjddLCBbNDguNjE4MiwgMS42Nzc2XSwgWzQ4LjY5OTQsIDMuNDc3XSwgWzQ4LjQzMTcsIDMuMzk0Nl0sIFs0OC4zMTM4LCAyLjQwNTddLCBbNDguMzIxMiwgMi4yNDExXSwgWzQ4LjMzMDcsIDIuMjMzNF0sIFs0OC4zMjgzLCAxLjk4MjNdLCBbNDguOTYyNywgMS40OTZdLCBbNDguNjE0NSwgMS43MTI5XSwgWzQ5LjE2MzYsIDEuODgyN10sIFs0OC4yNjU4LCAyLjQyXSwgWzQ4LjMwNDMsIDIuMDk5OF0sIFs0OS4xNTY4LCAyLjM2OTddLCBbNDguOTE2OSwgMy4zNDYzXSwgWzQ4LjcwMTgsIDMuNDcyOF0sIFs0OC4xNjIsIDIuODEwMV0sIFs0OC4zMzE4LCAyLjIzODRdLCBbNDkuMDkwMSwgMi43OTE3XSwgWzQ5LjA4MDcsIDIuOTczMl0sIFs0OC45MDM4LCAzLjM3MTFdLCBbNDguMTQzOCwgMi44NTMzXSwgWzQ4LjI1NDYsIDIuNDM4N10sIFs0OC40NjU3LCAxLjgyMDFdLCBbNDguNjI5NywgMS42NTddLCBbNDguMzcwNiwgMy4xNjY4XSwgWzQ4Ljg3OTksIDMuMzgxN10sIFs0OS4xMzAyLCAxLjY1NThdLCBbNDkuMTMxMSwgMS42NTU4XSwgWzQ4Ljg2NzMsIDMuNDIyXSwgWzQ4LjI5NzIsIDIuMTEzN10sIFs0OC43ODc0LCAxLjU3Nl0sIFs0OS4xOTUsIDEuNzM1M10sIFs0OS4wOTQ5LCAyLjU2OTZdLCBbNDguMjcyNSwgMy4wNDA3XSwgWzQ4LjM3MDYsIDMuMTQxM10sIFs0OS4wOTA1LCAzLjA2MjNdLCBbNDguMzkxNywgMy4zOTldLCBbNDkuMDgwNCwgMi45MTYxXSwgWzQ5LjE3NDMsIDIuMjA0Ml0sIFs0OC45MDQ2LCAzLjM3MTNdLCBbNDkuMTU3NywgMi4zNzA1XSwgWzQ4LjM5MTYsIDMuMzk3Nl0sIFs0OS4xMDc0LCAzLjEwN10sIFs0OS4wNzk2LCAzLjE2MDVdLCBbNDguMzc3LCAxLjk4MDRdLCBbNDguNDE2MywgMS45MzE2XSwgWzQ4Ljc3ODksIDEuNTgxXSwgWzQ4Ljg1NjUsIDEuNTgyNV0sIFs0OC45ODEzLCAxLjQ2NjddLCBbNDkuMjI0NCwgMS43NDAzXSwgWzQ5LjE2NDksIDEuODg5N10sIFs0OS4wNzM0LCAyLjY5MzRdLCBbNDkuMTAzMiwgMi41MTUxXSwgWzQ4Ljg4MzksIDMuMzgxMV0sIFs0OC44NTk1LCAzLjQzMjldLCBbNDguNjM2OSwgMy40NjhdLCBbNDguNDg3NywgMy40MDRdLCBbNDkuMDk3NCwgMi41NjA3XSwgWzQ4LjI1MDMsIDIuNDc1OV0sIFs0OS4wNzg5LCAyLjkyMTFdLCBbNDguODYyLCAzLjQyODFdLCBbNDguODU0OSwgMy40NTFdLCBbNDguNzk5NiwgMy40NDAzXSwgWzQ4LjYxNTEsIDMuNTQwOV0sIFs0OC4xNjYyLCAyLjgwODJdLCBbNDguOTA2NCwgMS41Mzg3XSwgWzQ4LjQ1NDIsIDEuOTI5NF0sIFs0OS4wMjY5LCAzLjE2NTJdLCBbNDguMTI0MiwgMi43MDM1XSwgWzQ4LjMzMDksIDIuMjMzOV0sIFs0OC40MDM4LCAxLjkzMV0sIFs0OC43Nzc2LCAxLjU4MDRdLCBbNDguNzgzMiwgMS41Nzc0XSwgWzQ5LjE1NTMsIDIuMjZdLCBbNDguOTI2MSwgMy4zNzA2XSwgWzQ5LjAzODMsIDEuNDU0XSwgWzQ5LjA2MDUsIDEuNDY0N10sIFs0OS4wNzE3LCAxLjU2NTNdLCBbNDguMzcyNCwgMS45ODAzXSwgWzQ5LjA4MTEsIDEuNTg5N10sIFs0OS4wODI3LCAxLjU5NDJdLCBbNDkuMDg0MSwgMS42MDY0XSwgWzQ5LjA4MzMsIDEuNjAzNF0sIFs0OS4xMTA4LCAxLjYzMjNdLCBbNDguNjg2MiwgMy40NzIyXSwgWzQ5LjE3MzMsIDEuOTM0Nl0sIFs0OC42NDU2LCAzLjUzMjhdLCBbNDguNDgwMiwgMy4zODc5XSwgWzQ4LjUyODgsIDMuNDM2N10sIFs0OC42MDI1LCAxLjcxNjNdLCBbNDguNjA3NCwgMS43MTc4XSwgWzQ4LjY3MjMsIDEuNjA4XSwgWzQ4LjcwMDMsIDEuNTgyMV0sIFs0OC42MTY3LCAxLjY2NzVdLCBbNDguNDA2LCAxLjk1MjZdLCBbNDguNDA1LCAxLjk0MDRdLCBbNDguNjQ5NywgMS42NDMxXSwgWzQ4LjQ0MDcsIDEuODc5NF0sIFs0OC40NjU4LCAxLjgwNzddLCBbNDguMTI4MiwgMi40NzIyXSwgWzQ4Ljk4NSwgMS40NjQ5XSwgWzQ4Ljg5MjEsIDMuMzcyNl0sIFs0OC40MDE4LCAxLjk3MDhdLCBbNDguNTUzNiwgMS43Nzg4XSwgWzQ4LjQ5MDMsIDMuNDI5NV0sIFs0OC44OTIxLCAzLjM3MTVdLCBbNDguOTI0NywgMy4zNzE1XSwgWzQ4LjYxNjIsIDMuNTU0NV0sIFs0OS4xNzg3LCAxLjY2N10sIFs0OS4wODc3LCAzLjAwNDRdLCBbNDguNjE2MiwgMS42ODQ4XSwgWzQ5LjE1OTEsIDIuMjgyXSwgWzQ4LjkxMTIsIDMuMzM3OF0sIFs0OC40MTYyLCAzLjQwMThdLCBbNDkuMDIxNSwgMy4xNjE5XSwgWzQ4LjI1NDYsIDIuNDQzNV0sIFs0OC4yOTQ3LCAyLjA4ODJdLCBbNDkuMTkyMywgMi4wOTQ0XSwgWzQ5LjE2ODYsIDIuMTczNl0sIFs0OC4zNzU4LCAzLjI4OTZdLCBbNDguODYzLCAzLjQwODZdLCBbNDguOTE1NSwgMS41NDE4XSwgWzQ5LjA4NjgsIDMuMDQyOF0sIFs0OC4zMDAyLCAyLjI1MzRdLCBbNDguNDE5OSwgMS45Mzk4XSwgWzQ5LjA3MTIsIDIuNzE1M10sIFs0OS4xNzg1LCAyLjE2NV0sIFs0OC4xNTAxLCAyLjg2MTNdLCBbNDguMzA5NSwgMi4yNjUyXSwgWzQ4LjEzNiwgMi42NDY0XSwgWzQ4LjEyOTEsIDIuNDY0OV0sIFs0OC4xMjU2LCAyLjQ1ODldLCBbNDguMzExMiwgMi40MDg2XSwgWzQ5LjAwNzcsIDMuMTk3MV0sIFs0OS4xMDY5LCAzLjEzMTRdLCBbNDkuMDEyNSwgMy4xODE3XSwgWzQ4LjI5MzksIDIuMDczMl0sIFs0OS4wNTQ3LCAzLjE4MTddLCBbNDkuMDAwOSwgMy4yMDMxXSwgWzQ5LjA4NjQsIDMuMDQ3N10sIFs0OS4xMTE3LCAzLjA5NDhdLCBbNDkuMTA2MiwgMy4xMjY5XSwgWzQ5LjA5MTIsIDMuMDE1Nl0sIFs0OC4zMTA5LCAyLjM3ODNdLCBbNDguNzYwOSwgMS41OTY2XSwgWzQ4LjgzNjEsIDEuNTk1MV0sIFs0OS4xNzU5LCAyLjAwMThdLCBbNDguNjQxNSwgMy40ODUxXSwgWzQ4LjQ3ODQsIDMuMzg0NV0sIFs0OC4zODEyLCAzLjI4MzldLCBbNDguMTQ0OCwgMi43OThdLCBbNDguMzMxLCAyLjI0XSwgWzQ5LjA4MzcsIDIuNzcwNl0sIFs0OS4wOTcxLCAyLjY1NzhdLCBbNDguMzcwMywgMy4xNTU2XSwgWzQ4LjQyMjEsIDMuNDAyNl0sIFs0OC4zOTAzLCAzLjQxNDhdLCBbNDguNjU5MSwgMy40NDk5XSwgWzQ4LjY0NTcsIDMuNTI5MV0sIFs0OC41Njc1LCAxLjc2MjNdLCBbNDguMzAxNiwgMi4xNjIyXSwgWzQ4LjgxMTksIDMuNDM1Nl0sIFs0OS4wODU0LCAyLjkwMTVdLCBbNDkuMDgxNywgMi41ODI4XSwgWzQ4LjQwMDYsIDMuNDE2OV0sIFs0OC45MDg1LCAxLjUzODRdLCBbNDguODMyMSwgMS41ODM3XSwgWzQ4LjMwNDMsIDIuMTU2Nl0sIFs0OS4wNzA0LCAxLjUyOTddLCBbNDkuMTgyMywgMi4zMTk3XSwgWzQ4LjgwMTgsIDMuNDMwNV0sIFs0OC41NDU0LCAzLjQ4MjNdLCBbNDguNDg3OCwgMy40MTUzXSwgWzQ4LjQxNTEsIDMuNDAzM10sIFs0OC4yODY1LCAzLjAyODNdLCBbNDguODg4OSwgMy4zODM2XSwgWzQ4Ljk0MDUsIDMuMjg0NV0sIFs0OC45MTg2LCAzLjM3MTRdLCBbNDguODE1MiwgMy40ODcyXSwgWzQ4LjQ4NTIsIDMuNDAwM10sIFs0OC4yNzUsIDMuMDI4M10sIFs0OS4wNjQ4LCAyLjY5NjVdLCBbNDkuMDk3NSwgMi44MDkzXSwgWzQ5LjA4MzMsIDIuODM4Ml0sIFs0OS4wODc5LCAyLjk0NjVdLCBbNDkuMDczOSwgMi43Mjk5XSwgWzQ5LjA3OTYsIDIuOTI5Nl0sIFs0OS4wNjk2LCAyLjcxMzJdLCBbNDkuMDc5OCwgMi45NDM1XSwgWzQ4LjE1NTcsIDIuNzVdLCBbNDguMzMzMSwgMi4zMjc3XSwgWzQ4LjQ5NTIsIDEuNzldLCBbNDkuMDY0NiwgMi42OTY3XSwgWzQ5LjA3NDQsIDIuOTc3MV0sIFs0OC45MTMsIDMuMzc0NV0sIFs0OC45MjI1LCAzLjM2NjhdLCBbNDguMzY1NiwgMy4yMDk3XSwgWzQ5LjE4MzgsIDIuMTUyNF0sIFs0OC44OTMyLCAxLjU1NTddLCBbNDkuMTgyNiwgMi4xNTcxXSwgWzQ5LjE2OTcsIDIuMTc2OF0sIFs0OS4xNDk1LCAyLjQxOTNdLCBbNDkuMDg2NSwgMy4wNjE0XSwgWzQ4LjYwMDYsIDMuNTA3M10sIFs0OS4yMDM4LCAxLjY3NjNdLCBbNDguMzcyOSwgMy4zMjc4XSwgWzQ4LjM3ODksIDMuMjk4N10sIFs0OC42MTQ3LCAxLjY3NDRdLCBbNDguMTY0NCwgMi40ODM2XSwgWzQ4LjIyNzksIDIuNTE3Ml0sIFs0OC4yNTM1LCAyLjQ0MjVdLCBbNDguMzM4LCAxLjk3MThdLCBbNDguMzU1NywgMS45NzMzXSwgWzQ4Ljk3OTQsIDEuNDg0XSwgWzQ5LjA5NjksIDIuNTYxM10sIFs0OS4wODI1LCAyLjU4MjddLCBbNDguNTc1NywgMS43NDgyXSwgWzQ4LjQzOTgsIDEuODcxN10sIFs0OC4xMzUzLCAyLjUzMDZdLCBbNDguOTE1NywgMS41NDE3XSwgWzQ5LjA4MjgsIDIuNzg2OF0sIFs0OC45NzY4LCAzLjIzMl0sIFs0OC4zNjgxLCAzLjE4NDldLCBbNDguMjM1MiwgMy4wMTg2XSwgWzQ4Ljg0NTUsIDEuNTc3M10sIFs0OC4xNjYxLCAyLjkzNTNdLCBbNDguMTY2MSwgMi44MTAzXSwgWzQ4LjMxNzcsIDIuMTgzNl0sIFs0OC45MDQ5LCAxLjUzOTNdLCBbNDguOTI4NiwgMS41MDcyXSwgWzQ5LjE4MDcsIDIuMjE4N10sIFs0OS4xODM4LCAyLjMwMTFdLCBbNDguODYzMywgMy40MDcyXSwgWzQ4Ljc4MDUsIDMuNDI3MV0sIFs0OC40NzgyLCAzLjM4NDNdLCBbNDkuMDE5NSwgMS40Njk1XSwgWzQ5LjA1ODcsIDEuNDcxXSwgWzQ5LjA3MjUsIDEuNTQyN10sIFs0OS4wODIzLCAxLjU5MTVdLCBbNDkuMDgxMSwgMS42MDUyXSwgWzQ5LjA4NTYsIDMuMDMxNl0sIFs0OS4xMDk5LCAxLjYyOTZdLCBbNDguMzMxMSwgMi4zMjY3XSwgWzQ4LjI1LCAyLjQ1MDJdLCBbNDkuMTc0MiwgMS45MzMxXSwgWzQ5LjA3NjYsIDIuOTc0Nl0sIFs0OC42MSwgMS43MTgzXSwgWzQ4LjQzOSwgMS44OTY2XSwgWzQ4LjU3MzgsIDEuNzU3OV0sIFs0OC42NDc5LCAxLjY0MzZdLCBbNDguNjQ4NSwgMS42MzE0XSwgWzQ5LjAyNDIsIDMuMTYxXSwgWzQ4LjU0NjcsIDEuNzgzOF0sIFs0OC42MTI2LCAxLjcwNDZdLCBbNDguNjE4MSwgMS42ODAyXSwgWzQ4LjU5NTMsIDEuNzA5MV0sIFs0OC43NTYzLCAxLjYxMjddLCBbNDkuMDMyNCwgMy4xNzY4XSwgWzQ4Ljc2MTksIDEuNTgyMV0sIFs0OC44NzU4LCAzLjM4MDddLCBbNDguOTkwNywgMS40NzEzXSwgWzQ4Ljc3NzMsIDEuNTg0Ml0sIFs0OS4wNjE1LCAyLjc1NjFdLCBbNDguODk3NywgMS41NDk2XSwgWzQ5LjIxMDMsIDEuNjc0NF0sIFs0OC45NTY5LCAxLjQ5ODddLCBbNDguOTE1MiwgMy4zNTM2XSwgWzQ4Ljc3MzYsIDEuNTg3Nl0sIFs0OS4yMDk3LCAxLjcyMjZdLCBbNDguODcwMiwgMS41NDU0XSwgWzQ5LjE3OTgsIDEuOTY5M10sIFs0OC40MzExLCAzLjM5NTJdLCBbNDkuMTgwNCwgMS43OTQzXSwgWzQ5LjE5NDksIDIuMDQzNV0sIFs0OS4xMDY2LCAzLjEyNzZdLCBbNDkuMDgzOCwgMi41OTk3XSwgWzQ5LjExODksIDIuNTAyMV0sIFs0OS4xMDY0LCAyLjQ4OTldLCBbNDkuMTg1NSwgMS43NDEzXSwgWzQ4LjkyNSwgMS41MjEzXSwgWzQ4LjM1NzgsIDMuMDY3N10sIFs0OC45NzkyLCAxLjQ5NjhdLCBbNDguODc2OCwgMS41NTIxXSwgWzQ5LjA3ODEsIDMuMTY1OV0sIFs0OS4xNjQ1LCAxLjg4ODNdLCBbNDguMzczLCAzLjMzNjRdLCBbNDkuMDkwOCwgMy4wNTk5XSwgWzQ5LjE3NiwgMS44MzJdLCBbNDkuMTE0OCwgMi41NTM1XSwgWzQ5LjIxMDksIDEuNjc0Ml0sIFs0OS4yMDEyLCAyLjA5MjJdLCBbNDkuMTU2NywgMi4yNjZdLCBbNDkuMDcxMSwgMS41MzQ2XSwgWzQ4Ljk3NjQsIDEuNTE1NV0sIFs0OS4wODI1LCAxLjU5NTZdLCBbNDkuMDg1MSwgMS42MjE1XSwgWzQ4Ljc0MjMsIDEuNjIyXSwgWzQ5LjA5ODUsIDEuNjIxNV0sIFs0OS4xMDAxLCAxLjYyMTVdLCBbNDkuMTIxMSwgMS42NDU5XSwgWzQ5LjE4MDksIDEuNjcxOF0sIFs0OS4yMDU1LCAxLjY3MzNdLCBbNDkuMTgwNywgMS43NDA4XSwgWzQ5LjE3MjUsIDEuODU1MV0sIFs0OS4xMTY0LCAyLjU0MDNdLCBbNDkuMTIzOCwgMi41NTddLCBbNDguNDE2NiwgMy40MjE1XSwgWzQ4LjQ3OTQsIDMuMzgzNF0sIFs0OC41MzkxLCAxLjc4MDldLCBbNDguNTQsIDEuNzgwOV0sIFs0OC4yOTM0LCAxLjk3MTRdLCBbNDguNzA5MywgMS41OTQ5XSwgWzQ4LjI5MzUsIDEuOTcxNF0sIFs0OC4zMDg3LCAxLjk1OTJdLCBbNDguMzU0MSwgMS45NzI5XSwgWzQ4LjQ0NjEsIDEuODQ0OV0sIFs0OC43MTU1LCAxLjU5MzRdLCBbNDguNjkyMywgMS41OTc5XSwgWzQ5LjE3MzYsIDEuODExN10sIFs0OS4xNjk5LCAxLjkzNTJdLCBbNDkuMTUyNSwgMi4zNjI0XSwgWzQ4LjMyNTMsIDMuMDM1N10sIFs0OC45NjA5LCAzLjI1NTddLCBbNDguODYzOSwgMS41NzJdLCBbNDkuMTc2OSwgMi4xNjMyXSwgWzQ4LjM3MjgsIDMuMzMwN10sIFs0OC4xMjYyLCAyLjUxNjZdLCBbNDguMTI2NSwgMi41MDc0XSwgWzQ4LjE1NjYsIDIuNTA1OV0sIFs0OC4xODM1LCAyLjUxMDRdLCBbNDguMjk4NCwgMi4yNDUyXSwgWzQ4LjMzMywgMi4yMjg1XSwgWzQ4LjM0MDQsIDIuMjA0MV0sIFs0OC4zMTU5LCAyLjE1MjNdLCBbNDkuMDg4NiwgMy4wMDAxXSwgWzQ5LjExMDcsIDMuMDkzMl0sIFs0OS4xMTMyLCAzLjA2ODhdLCBbNDkuMTEzMSwgMy4wNzhdLCBbNDkuMTExOCwgMy4wODFdLCBbNDkuMTA4LCAzLjEwMzldLCBbNDkuMTA4NCwgMy4xMTYxXSwgWzQ5LjA5OTMsIDMuMTYwMl0sIFs0OC4zMjQyLCAyLjMwODFdLCBbNDkuMTgwOSwgMS45ODNdLCBbNDguMjQ5NywgMy4wNDc2XSwgWzQ4LjM3MTQsIDMuMTU4OV0sIFs0OC44NzQyLCAxLjU0NjldLCBbNDkuMTc2NywgMS45OTQzXSwgWzQ4LjczNjIsIDEuNjE1OF0sIFs0OS4yMjc1LCAxLjcwMTddLCBbNDguODkyNCwgMS41NTY0XSwgWzQ4LjMxNDcsIDIuMTU2NV0sIFs0OC4yOTU1LCAyLjA1MjddLCBbNDkuMTcxMiwgMS45NDQyXSwgWzQ4LjM4MjYsIDMuMzYyOF0sIFs0OC45MTM1LCAzLjM0MTRdLCBbNDguODA4NCwgMy40MDU0XSwgWzQ4LjgwMjUsIDMuNDIwOF0sIFs0OC42OTE2LCAzLjQ3MjZdLCBbNDguNjM2OCwgMy40NzI2XSwgWzQ4LjU5OTksIDMuNTA3N10sIFs0OC41OTg1LCAzLjUwOTJdLCBbNDguNTQxNiwgMy40NzcxXSwgWzQ5LjA5NjYsIDIuNjYwNV0sIFs0OS4wNjQ3LCAyLjcwMzFdLCBbNDkuMDcyNywgMi45Nzc1XSwgWzQ4LjczNjUsIDMuNDQ2M10sIFs0OS4wODY0LCAyLjgyMjFdLCBbNDkuMDcyNywgMi45ODgyXSwgWzQ5LjA3ODMsIDIuODQ5NV0sIFs0OS4yMjEzLCAxLjczNDFdLCBbNDkuMTkwNCwgMi4xMDIxXSwgWzQ5LjE1MjQsIDIuMjMxOF0sIFs0OS4xNTQ0LCAyLjM1MzZdLCBbNDguOTcyNiwgMS41MDU0XSwgWzQ5LjE1NTcsIDIuMjY4MV0sIFs0OS4xNzUsIDIuMTk4NV0sIFs0OS4xNTU5LCAyLjM4M10sIFs0OC4yMjkyLCAzLjAyMTJdLCBbNDguNjU0NSwgMy40NTg1XSwgWzQ4LjcxMjUsIDEuNTg5NV0sIFs0OC44NjA2LCAxLjU4MThdLCBbNDkuMTY0MywgMS44ODczXSwgWzQ5LjIwODcsIDIuMDc1NV0sIFs0OS4wNDYxLCAxLjQ0NjVdLCBbNDkuMDQ2NCwgMS40NDY1XSwgWzQ5LjA1NDgsIDEuNDg5MV0sIFs0OS4wODAzLCAxLjU4NTJdLCBbNDkuMDc5MiwgMS42MTExXSwgWzQ5LjA5MTQsIDEuNjIzM10sIFs0OS4xNTM0LCAxLjY2NDRdLCBbNDkuMTU5MywgMS42NjI5XSwgWzQ5LjE2MDIsIDEuNjYyOV0sIFs0OS4yMDgxLCAxLjY3MzZdLCBbNDkuMTI0LCAxLjY0NjVdLCBbNDkuMTMzNywgMS42NTcyXSwgWzQ5LjE3NzIsIDEuODI5NV0sIFs0OS4xOTI0LCAyLjEyNTVdLCBbNDguNTkwMywgMy40OTMyXSwgWzQ4LjM1MywgMS45NzM0XSwgWzQ4LjM2ODMsIDEuOTg0MV0sIFs0OC40NDk3LCAxLjkyMTZdLCBbNDguMzk1OCwgMS45NzM0XSwgWzQ4LjQ2NjMsIDEuODI0XSwgWzQ4LjY1OTYsIDEuNjA3Nl0sIFs0OC44MTA3LCAxLjU4MzJdLCBbNDguODY0MiwgMS41NTg4XSwgWzQ4Ljg5MiwgMS41NTczXSwgWzQ4Ljk3OSwgMS40ODI2XSwgWzQ4Ljk1MzIsIDEuNTEwN10sIFs0OS4xNTg5LCAxLjY2MjNdLCBbNDkuMTk2LCAyLjA4OTVdLCBbNDkuMTczMywgMi4yOTU0XSwgWzQ4LjU3MDUsIDMuNDY1NV0sIFs0OC44NjEsIDEuNTgwNl0sIFs0OC4yMTA1LCAzLjAwNzJdLCBbNDguOTMwOCwgMS41MDk1XSwgWzQ5LjE1MzUsIDIuMjQ4NF0sIFs0OC4zNDMxLCAzLjAzNzVdLCBbNDguODcxOCwgMy4zODgxXSwgWzQ5LjEzNCwgMi40MzU4XSwgWzQ4Ljg1NDIsIDMuNDQ5N10sIFs0OC43NjU1LCAzLjM5OTRdLCBbNDguMjI2NiwgMy4wMTgyXSwgWzQ4LjYwODksIDMuNTI3M10sIFs0OC44NzY5LCAzLjM4MDldLCBbNDguOTc4MiwgMS40Njg2XSwgWzQ4Ljg2MDUsIDMuNDQ0XSwgWzQ4LjYxNjEsIDMuNTUyM10sIFs0OC4zNzY5LCAzLjMxNDVdLCBbNDkuMjA3OCwgMi4wODc2XSwgWzQ5LjEwMTgsIDIuNTMxM10sIFs0OC40NiwgMy4zOTk2XSwgWzQ4LjM2MDIsIDMuMDU1XSwgWzQ5LjExOTQsIDIuNTM0M10sIFs0OC40ODc1LCAzLjQxMTNdLCBbNDkuMTkyOCwgMS43MzY1XSwgWzQ5LjE1NDMsIDIuMzU0Ml0sIFs0OC44OTIxLCAxLjU1NjRdLCBbNDkuMTUxMiwgMi40MDIxXSwgWzQ4LjM1MywgMy4wOTk2XSwgWzQ4LjM2MTIsIDMuMDc4NF0sIFs0OS4xODUsIDEuNjY5NV0sIFs0OC44NzYsIDMuNDAwOF0sIFs0OC45NTM4LCAxLjUwOV0sIFs0OC45ODI4LCAxLjUwOV0sIFs0OS4yMDg1LCAyLjA3NzFdLCBbNDkuMTg5MSwgMi4xMDNdLCBbNDguNzgzNCwgMy40MTEyXSwgWzQ5LjE2OTksIDEuOTM1Nl0sIFs0OS4xODgxLCAyLjAzMzZdLCBbNDkuMjAzMSwgMS43MTU2XSwgWzQ4LjM0NDksIDIuMjA3MV0sIFs0OS4xNSwgMi4zNjE3XSwgWzQ5LjExNzMsIDIuNTM5NV0sIFs0OC44NzgxLCAzLjM4MTFdLCBbNDguOTIzMSwgMy4zNjU5XSwgWzQ4LjgxOTksIDMuNDcyNV0sIFs0OC40NTczLCAzLjQwMV0sIFs0OC4yMzAzLCAzLjAyMjhdLCBbNDguNDI0MiwgMy4zOTQ4XSwgWzQ4LjMxMywgMi4zNTQxXSwgWzQ4LjQzNTgsIDMuMzk2XSwgWzQ5LjE4NTcsIDIuMzE0OF0sIFs0OC4zNzIyLCAzLjMzMjJdLCBbNDguODkwNiwgMS41NjM3XSwgWzQ5LjIzODEsIDEuNzA5OV0sIFs0OS4yMjk2LCAxLjcyNjldLCBbNDkuMDk4NCwgMi41NTgyXSwgWzQ4Ljg3MzYsIDMuNDA1OF0sIFs0OC4zNzg2LCAzLjM1MV0sIFs0OS4xODQyLCAxLjc4NjddLCBbNDkuMTkwNywgMi4xMzE4XSwgWzQ5LjEyNCwgMi40OTMxXSwgWzQ5LjAxNSwgMS40NzcyXSwgWzQ5LjA0NzksIDEuNDQ5OF0sIFs0OS4wNTA1LCAxLjQ1MjhdLCBbNDkuMDUyMywgMS40ODc5XSwgWzQ5LjA3MDEsIDEuNTYxMV0sIFs0OS4yMDMyLCAxLjY3NjldLCBbNDkuMjExNywgMS42NzM5XSwgWzQ5LjIxMTUsIDEuNjc1NF0sIFs0OS4yMTE3LCAxLjY3NjldLCBbNDkuMjI0MSwgMS42OTgzXSwgWzQ5LjEzNDIsIDIuNDQxMl0sIFs0OC45ODczLCAzLjIyNDhdLCBbNDguOTM5NiwgMy4yNjQ0XSwgWzQ4LjQ4NzMsIDMuNDEyM10sIFs0OC40MzQzLCAxLjkzOTJdLCBbNDguNDUxLCAxLjkyODVdLCBbNDguNDU3MywgMS45MjU1XSwgWzQ4LjY0NDEsIDEuNjQwNF0sIFs0OC40Mzk4LCAxLjg5ODFdLCBbNDguNDY1NywgMS44MTU3XSwgWzQ4LjM4MDQsIDEuOTc0M10sIFs0OC4xNjIzLCAyLjc3MjVdLCBbNDguNjMyMywgMS42NDk2XSwgWzQ4LjQzOTUsIDEuODk4MV0sIFs0OS4xNzUsIDIuMTc0OV0sIFs0OS4xODQ5LCAyLjMxMDZdLCBbNDguOTY5MSwgMy4yNTM2XSwgWzQ4LjkyNiwgMy4zNjc5XSwgWzQ5LjA5NDIsIDIuNTY2Nl0sIFs0OC4zMDk2LCAyLjI2NDddLCBbNDkuMTY1OSwgMi4yODc2XSwgWzQ4LjQ4NDUsIDMuNDAwNl0sIFs0OC40MTU0LCAzLjQwNTFdLCBbNDguMzc5MSwgMy4yOTA4XSwgWzQ4LjMwMDEsIDIuMjQ1NF0sIFs0OC4yOTQsIDIuMDg1M10sIFs0OC42MTMsIDMuNTQwNV0sIFs0OC41MTI3LCAzLjQyNDddLCBbNDguOTU3MSwgMy4yNTcxXSwgWzQ5LjE3NjgsIDEuODM0NV0sIFs0OS4xNzU0LCAxLjk5OTFdLCBbNDguMjg1OSwgMi4wMDc1XSwgWzQ4LjgxODIsIDEuNTkwMV0sIFs0OC45MjE4LCAxLjUxMzldLCBbNDguOTQ1LCAzLjI2MDddLCBbNDguMzEwNiwgMi4yNDc0XSwgWzQ4LjMzMTgsIDIuMjQ0Ml0sIFs0OC45NTQ3LCAxLjUwNTNdLCBbNDguMjA2NiwgMi45OTg4XSwgWzQ4LjI1MDQsIDIuNDc1OV0sIFs0OC4yNjc2LCAyLjQyMTFdLCBbNDguMzE1OSwgMi4xNTQ0XSwgWzQ4LjI5MDEsIDIuMDUwNl0sIFs0OC4zNjAyLCAzLjExMV0sIFs0OC4zMzQxLCAyLjIxODRdLCBbNDkuMTA2NywgMy4xMjg5XSwgWzQ5LjA1MTEsIDMuMTg5N10sIFs0OC4xNDg3LCAyLjgwMDZdLCBbNDkuMDIwNywgMy4xNjIzXSwgWzQ5LjA4OTEsIDMuMDMyOF0sIFs0OS4wODc5LCAzLjA2NDddLCBbNDkuMTA4NSwgMy4wOTk4XSwgWzQ4LjE3NDcsIDIuNTE1NV0sIFs0OS4xMTc1LCAzLjA3MjRdLCBbNDguOTE3NywgMy4zNTldLCBbNDguNzQ2NiwgMy40Mzc4XSwgWzQ4LjYyMDEsIDMuNTU1M10sIFs0OC4zMTgzLCAyLjM5ODZdLCBbNDguMzEyNCwgMi4yNzk4XSwgWzQ4LjM0MjIsIDIuMjA1MV0sIFs0OS4xNzA0LCAyLjE4MjJdLCBbNDguNzU2MiwgMy4zOTgxXSwgWzQ4LjYzMTUsIDMuNTM4M10sIFs0OC4zNDAxLCAzLjAzNjhdLCBbNDguNDA1NCwgMS45NDA2XSwgWzQ4Ljg2NzMsIDEuNTYyNl0sIFs0OS4xNTk3LCAyLjM0ODJdLCBbNDguNDQxNiwgMy40MDQ3XSwgWzQ4Ljk4MDUsIDEuNDc4Nl0sIFs0OC4xMzIyLCAyLjgyMjddLCBbNDguMTI5OSwgMi44MjEyXSwgWzQ5LjExNjksIDEuNjQyNV0sIFs0OS4xNzU5LCAyLjIxMzFdLCBbNDkuMTE3NiwgMi41Mzc4XSwgWzQ4LjYyNTMsIDMuNTQ5M10sIFs0OC43NjQsIDEuNTg0M10sIFs0OC44NjcsIDEuNTU5OV0sIFs0OC4xNjQ0LCAyLjc2NzhdLCBbNDguMTI4NSwgMi40NjldLCBbNDguMTQ1LCAyLjQ2NThdLCBbNDguNTk0MSwgMy41MTM2XSwgWzQ4LjQxNTQsIDMuNDE3NV0sIFs0OC43MzY1LCAzLjQ0NzldLCBbNDguODY3NSwgMy40MjM1XSwgWzQ4Ljc4MjQsIDMuNDQxOV0sIFs0OC43NTY5LCAzLjQyNjddLCBbNDguNjU1NSwgMy40NTcxXSwgWzQ4LjQxMywgMy40MjJdLCBbNDkuMDc1LCAyLjg3OThdLCBbNDkuMDgsIDIuOTM0Nl0sIFs0OS4wODY5LCAyLjk0ODNdLCBbNDkuMDcxMywgMi43MzE5XSwgWzQ5LjA4MzgsIDIuODk5NV0sIFs0OS4wNzA2LCAyLjc3NDVdLCBbNDkuMDg3NCwgMi42MDU0XSwgWzQ5LjA2MywgMi43NjA4XSwgWzQ5LjA3MjEsIDIuOTgzN10sIFs0OC44MDIzLCAzLjQzMjNdLCBbNDguMTIzOSwgMi42OTE5XSwgWzQ5LjE5MSwgMi4wMzYzXSwgWzQ5LjE0ODUsIDIuNDI5N10sIFs0OC40ODYsIDMuNDA4NV0sIFs0OC4zNywgMy4yMjU3XSwgWzQ5LjExMjIsIDIuNTUxN10sIFs0OC44MTAzLCAxLjU4MTVdLCBbNDkuMDk3NCwgMS42MjA0XSwgWzQ5LjE3MTEsIDEuOTQ2Nl0sIFs0OS4xMzExLCAyLjQ3NzZdLCBbNDguOTE3OSwgMy4zNTk2XSwgWzQ5LjE3NjgsIDEuOTk2NV0sIFs0OC4xOTM3LCAyLjUxODRdLCBbNDguODU5NSwgMy40MzQxXSwgWzQ4LjM3NzIsIDMuMzEyMV0sIFs0OC4yNTIzLCAyLjQ3NDNdLCBbNDkuMTM0MywgMi40MzkyXSwgWzQ5LjEsIDIuNTU4Ml0sIFs0OC45MTQyLCAzLjM3MzldLCBbNDguOTQ2LCAzLjI2MTFdLCBbNDguMzUxMywgMy4xMDU1XSwgWzQ5LjE2OTUsIDEuODM1NV0sIFs0OC4xMjQsIDIuNjkyOF0sIFs0OC43OTc0LCAxLjU3ODldLCBbNDguNjc1MSwgMy40NDY4XSwgWzQ4LjUxNDQsIDMuNDIzOV0sIFs0OC4zNzAyLCAzLjMzNTVdLCBbNDkuMDEwMywgMS40NzQ1XSwgWzQ4Ljg1MDEsIDEuNTc5NF0sIFs0OS4wNDk0LCAxLjQ1MTZdLCBbNDkuMDU5MywgMS41MDM0XSwgWzQ5LjA4MDIsIDEuNTE0MV0sIFs0OS4wODI0LCAxLjUxNDFdLCBbNDkuMDcyMSwgMS41NjU5XSwgWzQ4LjE0NTcsIDIuNzU1Ml0sIFs0OS4xNzE1LCAxLjk0NTNdLCBbNDguMjA5OCwgMy4wMDY5XSwgWzQ4Ljc4MzYsIDMuNDI0NV0sIFs0OC42NTQ5LCAzLjQ1ODFdLCBbNDguNDgwOSwgMS43OTE4XSwgWzQ4LjQ5NzYsIDEuNzg4OF0sIFs0OC40MDM1LCAxLjk2NTZdLCBbNDguNDU4LCAxLjgzOTFdLCBbNDguNjUwMiwgMS42MjcyXSwgWzQ4LjM4MDMsIDEuOTc2M10sIFs0OC41NjQ3LCAxLjc2MjldLCBbNDguNTk4MSwgMS43MTQxXSwgWzQ4LjQxMjYsIDEuOTI2XSwgWzQ4LjMxMTMsIDEuOTY0MV0sIFs0OS4wNzUxLCAyLjcyMDddLCBbNDkuMTQ5NywgMi4zOTQ1XSwgWzQ4Ljg2NTUsIDMuNDAxNV0sIFs0OC44NDc4LCAzLjQ2ODVdLCBbNDguNzgxMywgMy40MjU5XSwgWzQ4Ljc1NTMsIDMuNF0sIFs0OC40OTYsIDMuNDM1MV0sIFs0OC40Nzk4LCAzLjM4NDhdLCBbNDkuMDcyNiwgMS41MzY5XSwgWzQ5LjE5NDMsIDEuNzI1OV0sIFs0OS4wODMxLCAyLjU4MTddLCBbNDguNDkwNCwgMy40MjAzXSwgWzQ4LjQ4ODUsIDMuNDA1MV0sIFs0OC4zMzI4LCAyLjMyOTNdLCBbNDguMzEyOCwgMi4yNzc1XSwgWzQ4LjkwMTIsIDEuNTQ2MV0sIFs0OS4xNzEyLCAxLjY2ODhdLCBbNDguNDg4NSwgMy40MDhdLCBbNDguNDcwNiwgMy4zOTU4XSwgWzQ5LjE3NTMsIDIuMjA4N10sIFs0OC45NDgsIDMuMjYyMl0sIFs0OC42MjU5LCAzLjU0ODhdLCBbNDguMjk5MywgMi4xMzYxXSwgWzQ5LjE3MDUsIDEuODQ5MV0sIFs0OC42OTA5LCAzLjQ3MjNdLCBbNDguMjA2OSwgMi45ODM0XSwgWzQ4Ljc2NzYsIDEuNTgyOV0sIFs0OC44Mjc0LCAxLjU4MjldLCBbNDguODM3LCAxLjU5NjZdLCBbNDguOTg2NCwgMS40NjA5XSwgWzQ5LjA3MjIsIDIuOTgzNF0sIFs0OC43MzY0LCAzLjQ0N10sIFs0OC4yNzIsIDMuMDQzMV0sIFs0OC45LCAxLjU0NjhdLCBbNDkuMTc1NywgMS42NjYzXSwgWzQ5LjE4NjksIDIuMDE5MV0sIFs0OC4yNjIsIDMuMDQyOF0sIFs0OC43NDkzLCAzLjQzNzddLCBbNDguNjYzNCwgMy40NDA3XSwgWzQ5LjA3MTgsIDEuNTUxN10sIFs0OS4yMjYzLCAxLjczNjJdLCBbNDkuMjI1NCwgMS43MzYyXSwgWzQ5LjEwNywgMy4xMzIzXSwgWzQ4LjE1MTIsIDIuNzk3OV0sIFs0OC4zMTU3LCAyLjRdLCBbNDguODQ4OSwgMy40NTA1XSwgWzQ4LjcwNDcsIDMuNDY3Ml0sIFs0OC41MzI1LCAzLjQ2MTJdLCBbNDguOTExNywgMy4zMzgzXSwgWzQ4LjE1MTQsIDIuODYyNV0sIFs0OC4yNTE2LCAyLjQ1ODRdLCBbNDguODA4LCAxLjU4MjNdLCBbNDkuMjEyNiwgMS42Nzc2XSwgWzQ5LjE2MzksIDIuMTY4OF0sIFs0OC44NjYsIDMuNDI0M10sIFs0OC43MzY1LCAzLjQ1MDJdLCBbNDguNjQ3MiwgMy40OTE1XSwgWzQ4Ljg4ODcsIDMuMzgwMl0sIFs0OS4xMzY3LCAxLjY1NzNdLCBbNDkuMDkwOSwgMi42NzMyXSwgWzQ5LjE3NjcsIDIuMjEyOF0sIFs0OC40ODY0LCAzLjQwODJdLCBbNDguNDgxNCwgMy4zOTNdLCBbNDkuMDgwNywgMi41ODMzXSwgWzQ4LjkyMzcsIDEuNTExXSwgWzQ4LjE0MDgsIDIuNTU0OF0sIFs0OC4xMjUsIDIuNDQ4Ml0sIFs0OS4xNTg3LCAyLjI3NTldLCBbNDkuMTY1NywgMi4yODUxXSwgWzQ4LjI1MDcsIDMuMDM3Nl0sIFs0OC4xOTAxLCAyLjUxODFdLCBbNDguMzE3NywgMi4xODQyXSwgWzQ5LjE3MTgsIDEuNjY4Nl0sIFs0OS4xODUyLCAxLjc3NjldLCBbNDkuMjA4NSwgMi4wODA2XSwgWzQ5LjE3MzIsIDIuMTg3NF0sIFs0OC41Mjk4LCAzLjQ0ODFdLCBbNDguNDE1MiwgMy40MDI1XSwgWzQ4LjMzMjUsIDMuMDQyN10sIFs0OS4xNzk4LCAxLjY2OTJdLCBbNDkuMTc1OSwgMS44MzIzXSwgWzQ5LjE2NSwgMi4xNzExXSwgWzQ4LjYzMjgsIDMuNTIxMl0sIFs0OC44MTY1LCAzLjQ3Nl0sIFs0OC40ODA0LCAzLjM4NzZdLCBbNDguMTU4OCwgMi43NDQ2XSwgWzQ4LjMzMzcsIDIuMTkxM10sIFs0OS4yMjMzLCAxLjczOTddLCBbNDkuMDA0NCwgMS40ODAxXSwgWzQ5LjAwNzQsIDEuNDgwMV0sIFs0OS4wNTksIDEuNDU3Ml0sIFs0OS4wNjM1LCAxLjUwNzVdLCBbNDkuMDc3NywgMS41MTgyXSwgWzQ5LjExNjUsIDEuNjQxN10sIFs0OS4xODY3LCAxLjY2OTFdLCBbNDkuMjMxMiwgMS43MjA5XSwgWzQ5LjIwOTYsIDEuNzMwMV0sIFs0OS4xNzE2LCAxLjg1NjZdLCBbNDguMTI3OCwgMi40Njg2XSwgWzQ5LjEwMzYsIDIuNTA1Ml0sIFs0OC45MjUzLCAzLjM3MTJdLCBbNDguNTEsIDMuNDI2XSwgWzQ4LjM5ODQsIDMuMzg3OV0sIFs0OC42MDc2LCAxLjcxNzJdLCBbNDguNDExNCwgMS45MzA2XSwgWzQ4LjI4NjQsIDEuOTkwMV0sIFs0OC40NTM3LCAxLjkzMDZdLCBbNDguNDA1NywgMS45NDI4XSwgWzQ4LjU1MjYsIDEuNzc4Ml0sIFs0OC41NzMxLCAxLjcyNjRdLCBbNDguMjA3LCAyLjk5NjZdLCBbNDguMTM5MywgMi44NDQyXSwgWzQ4LjE0MTcsIDIuNzk2OV0sIFs0OS4yMTU1LCAxLjY4MTldLCBbNDkuMDY2MSwgMi43MzI5XSwgWzQ5LjA2NTIsIDIuNzMyOV0sIFs0OC45MjEyLCAzLjMxMzFdLCBbNDguODQ5MywgMy40ODY5XSwgWzQ4Ljc1MzIsIDMuNDM2Nl0sIFs0OC40MzIzLCAzLjM5NTNdLCBbNDguOTE2LCAzLjM0ODJdLCBbNDkuMTc4LCAxLjgyOF0sIFs0OC4zMTYzLCAyLjI0MDNdLCBbNDguNzc3OSwgMS41ODA2XSwgWzQ4LjEzODQsIDIuODQxNV0sIFs0OC43ODA4LCAzLjQzMzldLCBbNDguNDU4NiwgMy40MDAzXSwgWzQ4LjMxMjEsIDIuMzY3MV0sIFs0OS4xODkyLCAxLjY3MDJdLCBbNDguODYwNCwgMy40MzldLCBbNDguNzU0NSwgMy40MzQ1XSwgWzQ4LjMwMjksIDMuMDI3NF0sIFs0OC44Nzc3LCAxLjU1MjVdLCBbNDguMTgyOSwgMi45Mzc5XSwgWzQ4LjI4NjgsIDIuMDM3XSwgWzQ5LjE0NTgsIDIuNDQwOV0sIFs0OC4xMjU4LCAyLjY3NF0sIFs0OC4xMzI5LCAyLjYxM10sIFs0OC4xMjQ3LCAyLjQ0MjJdLCBbNDguMzE0NywgMi4yNjY5XSwgWzQ4LjQwNTgsIDMuNDE5XSwgWzQ4LjE2NDUsIDIuODExMl0sIFs0OS4wODcyLCAzLjAyNjVdLCBbNDkuMDg1OSwgMy4wMjk1XSwgWzQ5LjExMjUsIDMuMDgyOF0sIFs0OC4xNjg3LCAyLjc5Nl0sIFs0OS4wODUyLCAzLjA2NjFdLCBbNDkuMDY3LCAzLjE3ODldLCBbNDkuMDAzMSwgMy4yMDE4XSwgWzQ5LjExMDIsIDMuMDk4NF0sIFs0OS4xMDE5LCAzLjE0NF0sIFs0OS4xMTExLCAzLjA5NjddLCBbNDguMzE3MywgMi40MDQyXSwgWzQ4LjMxNSwgMi4yNjkxXSwgWzQ4Ljk4NTcsIDEuNDYxNV0sIFs0OS4xNTYzLCAyLjM2OTddLCBbNDguOTg3OSwgMy4yMjQzXSwgWzQ4Ljc4MDgsIDMuNDI3XSwgWzQ4LjQzMDEsIDMuMzk1MV0sIFs0OC4xMjE2LCAyLjY2OTddLCBbNDguMzU4MiwgMy4wNDg0XSwgWzQ5LjA2NiwgMi42OTQxXSwgWzQ5LjE5MzIsIDIuMTI3MV0sIFs0OC4yMTI1LCAzLjAwODNdLCBbNDkuMTcyNCwgMS44Mzc0XSwgWzQ5LjE3ODksIDEuOTg4M10sIFs0OC4xNjQzLCAyLjc3NTZdLCBbNDkuMDgyOSwgMS41OTIyXSwgWzQ5LjIwMTYsIDIuMDkxMV0sIFs0OS4xNzQzLCAyLjIwMjRdLCBbNDguNjM5MiwgMy41MjM0XSwgWzQ4LjE0NDYsIDIuNzQ5NF0sIFs0OC4zMzU1LCAyLjE5NjFdLCBbNDkuMjM0MywgMS43MDY0XSwgWzQ4LjUzMTQsIDMuNDMwM10sIFs0OC44NzQ0LCAzLjQwNTldLCBbNDguODcxNywgMy40MDU5XSwgWzQ4Ljg2NTUsIDMuNDE1MV0sIFs0OC44NjY5LCAzLjQyNDFdLCBbNDguODEzOSwgMy40NzkxXSwgWzQ4LjgxODgsIDMuNDc0NF0sIFs0OC42MzkyLCAzLjQ1MzJdLCBbNDkuMDc5NSwgMi45ODg1XSwgWzQ4LjQ4NjcsIDMuNDA0NF0sIFs0OS4wNzczLCAyLjg0OThdLCBbNDkuMDc4LCAyLjkyNDVdLCBbNDkuMDg5MiwgMi45Njg4XSwgWzQ5LjA4MTcsIDIuODQ4M10sIFs0OS4wNzIyLCAyLjg3NDJdLCBbNDkuMDc0MywgMi44NzcyXSwgWzQ4LjIwNiwgMi45ODE4XSwgWzQ4LjMyOSwgMi4zMTI1XSwgWzQ5LjE3NzYsIDIuMDA0NV0sIFs0OC44NDExLCAzLjQ4ODhdLCBbNDguNzM0MSwgMy40Njc0XSwgWzQ4LjY5MDcsIDMuNDcxOV0sIFs0OC40NTgyLCAzLjQwMDRdLCBbNDguMjg1MywgMi40MjA1XSwgWzQ4LjkyNDEsIDEuNTE3XSwgWzQ4Ljk3OTEsIDEuNDgzNF0sIFs0OS4xNzcsIDEuODMwMl0sIFs0OS4xNzE3LCAxLjkxODZdLCBbNDkuMjA1NiwgMi4wOTEzXSwgWzQ5LjE0MTUsIDIuNDM4OV0sIFs0OC45MjAyLCAzLjMxNTZdLCBbNDguNzgzOCwgMy40MTQ3XSwgWzQ4LjIxOTYsIDMuMDEwNl0sIFs0OS4wOTc1LCAyLjU2MjRdLCBbNDguNzY1NSwgMS41ODE1XSwgWzQ4LjgyOCwgMS41ODE1XSwgWzQ4LjIyODEsIDIuNTE4N10sIFs0OC4yOTA0LCAyLjQyMjZdLCBbNDguMzAxOCwgMi4yNTVdLCBbNDguNzc2LCAxLjU4MzFdLCBbNDkuMTczMSwgMS44NTY3XSwgWzQ5LjEzNDEsIDIuNDM2M10sIFs0OC40NTkzLCAzLjQwMDddLCBbNDguMzU3OCwgMy4wOTg5XSwgWzQ4LjIxNTgsIDMuMDA5XSwgWzQ5LjE4MjgsIDIuMTU2NV0sIFs0OS4yMDIyLCAxLjcyMDZdLCBbNDkuMTIxNywgMi41Mzg2XSwgWzQ4LjEzNDYsIDIuODAwNV0sIFs0OC4xNjM3LCAyLjc1OTRdLCBbNDguMTI0OCwgMi40NDIyXSwgWzQ4LjI2MTgsIDIuNDIyNV0sIFs0OC4zMzM1LCAyLjIxODFdLCBbNDguOTA5NiwgMy4zMjk2XSwgWzQ5LjE4MzUsIDEuOTc0NV0sIFs0OS4xMDA2LCAyLjY1MDJdLCBbNDkuMTAyMiwgMi42MjczXSwgWzQ4LjQ2ODIsIDMuMzk5NV0sIFs0OC4zNzE0LCAzLjM1ODRdLCBbNDkuMDA1NiwgMS40ODA0XSwgWzQ5LjAzNzMsIDEuNDU2XSwgWzQ4LjkwODQsIDEuNTQxM10sIFs0OC45MTQ2LCAxLjU0MjhdLCBbNDkuMDM3OSwgMS40NTQ1XSwgWzQ5LjA1MTUsIDEuNDg0OV0sIFs0OS4wNzYsIDEuNTE3XSwgWzQ5LjA3NTYsIDEuNTE3XSwgWzQ4LjE4MiwgMi45MzY1XSwgWzQ4LjI1MTIsIDIuNDUwMl0sIFs0OC45NTY5LCAxLjQ5NzldLCBbNDkuMTc4LCAxLjgyMThdLCBbNDguOTUxLCAzLjI1ODRdLCBbNDguOTEwNywgMy4zMjg2XSwgWzQ4LjQxNjcsIDMuNDA0OF0sIFs0OC40ODQ3LCAxLjc5NTRdLCBbNDguNjE5MiwgMS42ODExXSwgWzQ4LjQ2OSwgMS44MDMxXSwgWzQ4LjYxNDcsIDEuNzE0N10sIFs0OC4zNTg4LCAxLjk3ODRdLCBbNDguNTM0NCwgMS43Nzg3XSwgWzQ4LjY0MjksIDEuNjQxNV0sIFs0OC4xODMxLCAyLjkzODZdLCBbNDguNjUyLCAxLjYxNzFdLCBbNDguMzgyNiwgMS45Njc3XSwgWzQ4LjksIDEuNTQ3Ml0sIFs0OS4wODIsIDIuOTExMl0sIFs0OC4zNzMxLCAzLjMzNzVdLCBbNDguNDY3MywgMy40XSwgWzQ4LjIyODksIDIuNTA3XSwgWzQ4LjMzMjUsIDIuMjQzM10sIFs0OS4xNzU1LCAyLjIwOTddLCBbNDkuMDgwNSwgMi41ODY0XSwgWzQ4Ljg5MTgsIDMuMzc0N10sIFs0OS4xODE4LCAxLjgwMTJdLCBbNDguMTUyNywgMi44NjQ0XSwgWzQ4LjEzMDIsIDIuODA5NF0sIFs0OC4zMTc3LCAyLjE4NDRdLCBbNDguMzY5LCAzLjIzNDJdLCBbNDguODA2NiwgMy40MDhdLCBbNDguNDkyMiwgMy40MjE3XSwgWzQ4LjE4NCwgMi45NDE4XSwgWzQ4LjE2ODMsIDIuNzk0MV0sIFs0OS4yMDU2LCAxLjY3MzJdLCBbNDkuMTk5MiwgMS43MjVdLCBbNDkuMTA0MiwgMi41MTA1XSwgWzQ4Ljg3NTIsIDEuNTUxXSwgWzQ4LjMyNDYsIDIuMzA4NF0sIFs0OC4zMjExLCAyLjE4NDldLCBbNDkuMTY3MiwgMi4zMzg4XSwgWzQ4Ljc4NDIsIDMuNDIwNV0sIFs0OC44MDI5LCAxLjU3OV0sIFs0OC40MDg2LCAzLjQyMDVdLCBbNDkuMTg0NCwgMi4zMjE4XSwgWzQ4LjY0NDksIDMuNTI5NF0sIFs0OC45MjQ4LCAxLjUyMjRdLCBbNDkuMTM0LCAxLjY1NzFdLCBbNDkuMjM1NSwgMS43MDg5XSwgWzQ4LjM0MDUsIDIuMjEyNl0sIFs0OS4wNzg2LCAyLjkzNTJdLCBbNDkuMDgzNSwgMi45NzE4XSwgWzQ4LjM1NzksIDMuMDQ3NV0sIFs0OC43MzksIDMuNDQwN10sIFs0OC42NDM5LCAzLjUyMDFdLCBbNDguNjMxNCwgMy41MzY4XSwgWzQ4LjQxMDQsIDMuNDIxXSwgWzQ4LjI1MzcsIDMuMDQ2XSwgWzQ4LjE0MjIsIDIuNDY0XSwgWzQ5LjIwMDcsIDEuNzI0M10sIFs0OS4xNzQ2LCAyLjIwNjNdLCBbNDguMzkyNCwgMy4zOTU1XSwgWzQ4Ljg0OTQsIDMuNDUwNV0sIFs0OC42MTg0LCAzLjU1ODVdLCBbNDguNDY1NiwgMy4zOTU0XSwgWzQ4LjEyMDYsIDIuNjY3Ml0sIFs0OC4zMTQzLCAyLjE3NDddLCBbNDkuMTUyNSwgMi4yNDE5XSwgWzQ5LjE1ODcsIDIuMzc3NF0sIFs0OC40ODU3LCAzLjQwOTddLCBbNDguODY3NywgMy40MDA1XSwgWzQ4Ljg2MDYsIDMuNDMxMV0sIFs0OC40NjU5LCAzLjM5Nl0sIFs0OS4xNDk3LCAyLjQxNzJdLCBbNDkuMDY5NiwgMy4xNzY2XSwgWzQ5LjE2OTgsIDIuMTYwOV0sIFs0OS4xNTkzLCAyLjIyMjZdLCBbNDkuMTY3NCwgMi4yODgxXSwgWzQ4Ljk0NzQsIDMuMjYxN10sIFs0OC44NzA0LCAzLjQwMTldLCBbNDguNzc4OCwgMy40MDc5XSwgWzQ4Ljc0NDcsIDMuNDM3XSwgWzQ4LjM1OCwgMy4wODQ3XSwgWzQ4Ljk3OTIsIDEuNDkxN10sIFs0OS4xOTk0LCAxLjY3Nl0sIFs0OC4yMDQ0LCAyLjk5MjJdLCBbNDkuMTc4NSwgMS42NjcxXSwgWzQ5LjA3OTQsIDIuOTI5N10sIFs0OS4xNzI3LCAyLjE3OTddLCBbNDguMjUwNCwgMy4wNDcyXSwgWzQ4Ljg2MzMsIDMuNDA3XSwgWzQ4LjE2NzUsIDIuNzc5NF0sIFs0OC42Mzc3LCAzLjUxOTddLCBbNDguNjI0NCwgMy41NTAxXSwgWzQ4LjYwNywgMy41MTY1XSwgWzQ5LjE3NTMsIDIuMTk5MV0sIFs0OC4xNTU1LCAyLjgwMzVdLCBbNDkuMTc5NSwgMS45ODU2XSwgWzQ5LjE3MDcsIDIuMjkwM10sIFs0OC42Mjk5LCAzLjU0MTVdLCBbNDkuMTE2MiwgMS42MzkxXSwgWzQ5LjA4NDcsIDIuODQ1Ml0sIFs0OS4xNzYsIDIuMTc2MV0sIFs0OC45MDU5LCAzLjM3MjFdLCBbNDkuMDE5MiwgMS40N10sIFs0OS4wMjYzLCAxLjQ1NzhdLCBbNDkuMDU5OCwgMS40NTc4XSwgWzQ4LjQ4NTIsIDEuNzk0M10sIFs0OS4wNjI3LCAxLjQ2MDhdLCBbNDguMzU3NCwgMy4xMDA1XSwgWzQ5LjA1ODMsIDEuNDk3NF0sIFs0OS4wODQ1LCAxLjUwOTZdLCBbNDkuMDY4NSwgMS41MjE4XSwgWzQ4LjEzMTUsIDIuNDQ1N10sIFs0OC4zMjksIDIuMjI5M10sIFs0OS4xODAyLCAxLjk4MzRdLCBbNDguMjEzOCwgMy4wMDY5XSwgWzQ4Ljk3ODEsIDMuMjMxXSwgWzQ4LjkyNjgsIDMuMzY5N10sIFs0OC42MjEzLCAxLjY1NzZdLCBbNDguNjQsIDEuNjQ1NF0sIFs0OC40Mzg5LCAxLjg5NjldLCBbNDguMzA4NSwgMS45NTk0XSwgWzQ4LjM4MDQsIDEuOTczMV0sIFs0OS4xMTQ4LCAzLjA3NzFdLCBbNDkuMDk5MywgMy4xNjFdLCBbNDkuMDc2MiwgMy4xNjg3XSwgWzQ4LjM5MzEsIDEuOTczMV0sIFs0OC42MjM4LCAxLjY1NjFdLCBbNDkuMDk5MiwgMS42MjEyXSwgWzQ5LjExMDYsIDEuNjMxOV0sIFs0OS4yMywgMS43MjQ4XSwgWzQ4LjQ0MTcsIDEuOTQwM10sIFs0OC43MzgxLCAzLjQ1NDhdLCBbNDguNjQ3NiwgMy40OTI5XSwgWzQ4LjQzNzcsIDMuNDAxNV0sIFs0OC40MzQ2LCAzLjM5N10sIFs0OS4xNzQ2LCAxLjgxMTNdLCBbNDguNTU3NSwgMy40NzddLCBbNDguMTkwMiwgMi45NTA3XSwgWzQ4LjM0NDYsIDIuMjAyMl0sIFs0OC41NzUsIDEuNzU3NF0sIFs0OS4xNzY0LCAyLjMyNzJdLCBbNDkuMTU2NSwgMi4zNjk4XSwgWzQ4Ljk1MjUsIDMuMjU3Ml0sIFs0OC44NjAxLCAzLjQ0NDddLCBbNDkuMjEzNSwgMS42Nzc3XSwgWzQ4LjI5NCwgMi4wNTE5XSwgWzQ4LjE1ODQsIDIuNzQzOF0sIFs0OC4xNDEzLCAyLjU2MjNdLCBbNDguOTQxMywgMS41MDE3XSwgWzQ4Ljk1NTcsIDMuMjU3N10sIFs0OC44MDMxLCAzLjQxNDZdLCBbNDguOTQ3LCAzLjMwMTddLCBbNDguMzU3MywgMy4wODc2XSwgWzQ5LjIyNjQsIDEuNzM0OF0sIFs0OS4xODM3LCAxLjc3NTldLCBbNDkuMTY3NywgMi4xNzEyXSwgWzQ5LjE1NDYsIDIuMzY2Ml0sIFs0OC4xMzQxLCAyLjgzNjJdLCBbNDguMTYyNSwgMi43NTIzXSwgWzQ4LjE0MzQsIDIuNzQ2MV0sIFs0OC4zMzE4LCAyLjMyNF0sIFs0OC4zMjcyLCAyLjE4NjhdLCBbNDguMTMwMiwgMi44MTAzXSwgWzQ5LjEwNzQsIDMuMTA3OF0sIFs0OS4xMDEyLCAzLjE0NzRdLCBbNDkuMDcxMSwgMy4xNzVdLCBbNDguMTYxLCAyLjgxMDNdLCBbNDkuMTAwNSwgMy4wNTZdLCBbNDguMTMxLCAyLjgwNjZdLCBbNDkuMDg1OCwgMy4wNTQ1XSwgWzQ5LjEwODYsIDMuMTAwM10sIFs0OS4xMDY3LCAzLjEzMzddLCBbNDkuMDgzNCwgMy4xNTM2XSwgWzQ5LjA5MDEsIDIuOTY4Ml0sIFs0OS4xODI1LCAyLjE1NTddLCBbNDguOTQ3OSwgMy4zMDUzXSwgWzQ4LjYxMjYsIDMuNTQwMV0sIFs0OC4yMDkxLCAzLjAwNjVdLCBbNDguMzkxMSwgMy40MDU5XSwgWzQ5LjExNzUsIDEuNjQzNF0sIFs0OS4xNjY5LCAxLjY2NjNdLCBbNDguNDYwNiwgMy4zOTc2XSwgWzQ4LjEzMjMsIDIuNDQ4OV0sIFs0OS4xNTM3LCAyLjM2NV0sIFs0OS4xMDM4LCAyLjUwMzldLCBbNDguNDg3NSwgMy4zOTk2XSwgWzQ4LjM2NDksIDMuMjUxN10sIFs0OC4zNTksIDMuMDcxOV0sIFs0OS4xNzM3LCAxLjgxNTddLCBbNDkuMTAwNSwgMi41MjhdLCBbNDguMzk0OCwgMy40MTU0XSwgWzQ4LjY4NTksIDMuNDY0Ml0sIFs0OC42ODU0LCAzLjQ2MjddLCBbNDguNjM3OSwgMy40NTJdLCBbNDguNjQ1LCAzLjUwNTNdLCBbNDguNjMyNSwgMy41MjM3XSwgWzQ4LjQ0MjQsIDMuNDA0N10sIFs0OC4zMTI3LCAyLjM4ODRdLCBbNDkuMTE1OSwgMi41NTQ0XSwgWzQ5LjE4MjEsIDIuMTU4MV0sIFs0OC42MTU5LCAzLjU1N10sIFs0OC40OTE4LCAzLjQyMjhdLCBbNDguMzMwMiwgMi4zMTgxXSwgWzQ4LjQzNjgsIDMuNDAxMV0sIFs0OC4yNDYzLCAzLjAyOTFdLCBbNDguMjk2NSwgMy4wMjAxXSwgWzQ4LjQ0MjgsIDMuNDA0MV0sIFs0OC43ODI1LCAzLjQzNDddLCBbNDguNjEwMSwgMy41MzUzXSwgWzQ4LjQ4MDksIDMuMzkwNF0sIFs0OC40MzY4LCAzLjM5NTFdLCBbNDguNDI0MSwgMy4zOTUxXSwgWzQ4LjM2ODMsIDMuMTg2Ml0sIFs0OS4xMDA1LCAyLjY1XSwgWzQ5LjA3NDUsIDIuODU0Ml0sIFs0OC40ODgyLCAzLjQwODJdLCBbNDkuMDg1OCwgMi43ODcyXSwgWzQ5LjA3MDcsIDIuNzMyMl0sIFs0OS4wNzk3LCAyLjU5MDVdLCBbNDguNjEzNywgMS42NjY0XSwgWzQ5LjA5MzEsIDIuNTcyNV0sIFs0OC45NTIyLCAxLjUwMzRdLCBbNDkuMTg4OSwgMi4xMDM2XSwgWzQ4Ljg2NjQsIDMuMzk4OV0sIFs0OC44NjAxLCAzLjQ0M10sIFs0OC44NTYzLCAzLjQ1MjJdLCBbNDguNjQ2OSwgMy40OTk1XSwgWzQ4LjQ4NTYsIDMuNDA5NF0sIFs0OC4zNjk0LCAzLjIyMDRdLCBbNDkuMTc5OCwgMS43NDNdLCBbNDguMTM0MywgMi44MzA2XSwgWzQ4LjE5NDEsIDIuNTE4MV0sIFs0OC43MzgsIDEuNjIyMV0sIFs0OS4wOTY3LCAyLjY2MTNdLCBbNDkuMTkwOSwgMi4wMzYzXSwgWzQ4Ljg2NDMsIDMuNDI1NF0sIFs0OC40ODcyLCAzLjQxNDddLCBbNDguNDQwNSwgMy40MDRdLCBbNDguMTYzNCwgMi45MzYzXSwgWzQ4LjMyOTYsIDIuMjI3Nl0sIFs0OC4xNjQ5LCAyLjc5MTNdLCBbNDguMTM3MSwgMi42NDUxXSwgWzQ4LjIzODUsIDIuNTA2Ml0sIFs0OS4xNDk3LCAyLjQxNzhdLCBbNDkuMTM1NSwgMi40NzEzXSwgWzQ4LjkwMDgsIDEuNTQzN10sIFs0OC45ODIxLCAxLjUwNDFdLCBbNDkuMjI2NSwgMS42OTk4XSwgWzQ4LjE1ODksIDIuNzQzMV0sIFs0OS4yMDY3LCAyLjA4M10sIFs0OS4wOTQ3LCAyLjU2OTNdLCBbNDguODg1MSwgMy4zODI4XSwgWzQ4Ljg0NjMsIDMuNDY4Ml0sIFs0OS4wMTg2LCAxLjQ3MThdLCBbNDkuMDQ1MiwgMS40NDc0XSwgWzQ5LjA1MzQsIDEuNDQ3NF0sIFs0OS4wNTQ0LCAxLjQ0ODldLCBbNDkuMDU4NCwgMS40NzE4XSwgWzQ5LjA1NjEsIDEuNDczM10sIFs0OS4wNjI3LCAxLjUwNjldLCBbNDkuMDcyNCwgMS41NDY1XSwgWzQ5LjE4ODksIDIuMDMyNl0sIFs0OS4xODU0LCAyLjMwODVdLCBbNDguNjk3NSwgMS41ODM0XSwgWzQ4LjQ2NjEsIDEuODEwNV0sIFs0OC42MTQxLCAxLjcxMTRdLCBbNDguNTk3MiwgMS43MTI5XSwgWzQ4LjY4NjUsIDEuNjEwOF0sIFs0OC4zODg4LCAxLjk3MzZdLCBbNDguNDI3OCwgMS45MzddLCBbNDguNTUwNSwgMS43ODYxXSwgWzQ4LjYxMzgsIDEuNzA5OV0sIFs0OC4zMDY5LCAyLjI0NjZdLCBbNDguNjExOCwgMy41Mzc3XSwgWzQ5LjA4NiwgMi45NDQ4XSwgWzQ5LjE1MDEsIDIuMzk3NV0sIFs0OC44NzYzLCAzLjM5ODVdLCBbNDguODUwMSwgMy40NTAzXSwgWzQ4LjgwMTksIDEuNTc4Ml0sIFs0OS4wNzQ3LCAxLjUxMjVdLCBbNDguMzI3NCwgMi4zMzQ3XSwgWzQ5LjE3NiwgMS44MTQ2XSwgWzQ5LjA5NjIsIDIuODA1OF0sIFs0OC44NjcxLCAzLjQyMDNdLCBbNDguODA2NSwgMy40MDgxXSwgWzQ4LjYzNzcsIDMuNTE3OV0sIFs0OC42Mjc1LCAzLjU0NjhdLCBbNDguNDkxMiwgMy40MjAzXSwgWzQ5LjE4NDMsIDEuNzc2OF0sIFs0OS4wNzYsIDIuNzIxXSwgWzQ5LjE5MDcsIDIuMTA5N10sIFs0OC43NTM4LCAzLjQzNTRdLCBbNDguNDQ1MywgMy40MDVdLCBbNDguNjUwNywgMS42MjI4XSwgWzQ4Ljc1MSwgMS42MjEzXSwgWzQ4LjMyLCAyLjMwNDZdLCBbNDguODEyMywgMy40NDY3XSwgWzQ4LjQyMzMsIDMuMzkxN10sIFs0OC4xMzU2LCAyLjQ1NDZdLCBbNDkuMTQ5NCwgMi40MTk1XSwgWzQ4LjQ1NjksIDEuOTI5Nl0sIFs0OC42MTIyLCAxLjcxNjJdLCBbNDguOTk5OCwgMS40Nzg0XSwgWzQ5LjIwNywgMS43MTldLCBbNDguMTMxNSwgMi41NzQ4XSwgWzQ4LjI3MzQsIDIuNDE3OV0sIFs0OS4xMzczLCAxLjY1NTNdLCBbNDkuMDgzOCwgMi44Mjk1XSwgWzQ5LjE1MTIsIDIuNDAyN10sIFs0OC44MDM1LCAzLjQzNjNdLCBbNDkuMTg0LCAxLjY3MDhdLCBbNDkuMDg5NCwgMi45Njg4XSwgWzQ4Ljg1OTYsIDMuNDQ2OV0sIFs0OC44MTUxLCAzLjQ2MDZdLCBbNDguMzczLCAzLjI2MDldLCBbNDkuMDcxMiwgMS41NjI0XSwgWzQ4LjEyNTMsIDIuNjk0MV0sIFs0OS4wNzU0LCAyLjcyNDddLCBbNDkuMDg4MiwgMi45NjFdLCBbNDkuMTU2NywgMi4yNTk4XSwgWzQ4LjMxMjEsIDIuMzY3XSwgWzQ4Ljc4NjIsIDMuNDQyOV0sIFs0OC41MDYzLCAxLjc4MDVdLCBbNDguOTgzMiwgMS40NjY1XSwgWzQ5LjExMjYsIDIuNTUxNV0sIFs0OC4zNjA5LCAzLjA3NjddLCBbNDguNzg0MywgMy40MjEzXSwgWzQ4LjQxNDMsIDMuNDEzNl0sIFs0OS4xMDQ3LCAzLjA2MDldLCBbNDguODksIDEuNTYzOF0sIFs0OS4xODM5LCAyLjMwMTJdLCBbNDguNzM3OSwgMy40NjQ1XSwgWzQ4LjM5ODQsIDMuMzg1M10sIFs0OC40MDY0LCAxLjk1MDFdLCBbNDkuMDg3NywgMi43ODUxXSwgWzQ5LjEwMDgsIDIuNTU4XSwgWzQ4Ljg5OCwgMy4zNjk4XSwgWzQ5LjE3MiwgMi4xODA5XSwgWzQ4LjI4NzcsIDEuOTkwMl0sIFs0OC44MTQ2LCAxLjU5MDhdLCBbNDkuMTcxOSwgMS44NjhdLCBbNDguMTkxNSwgMi45NjAxXSwgWzQ4LjEzMDEsIDIuODE2OV0sIFs0OC4yODY2LCAxLjk5NDFdLCBbNDkuMTc1MSwgMS43NTRdLCBbNDkuMDkwMSwgMi43OTFdLCBbNDkuMTcwMiwgMi4yMzE1XSwgWzQ5LjA4MDQsIDMuMTU4N10sIFs0OC43MzY1LCAzLjQ0OTVdLCBbNDguNjc1OCwgMy40NDk1XSwgWzQ4LjYxNjIsIDMuNTU3OF0sIFs0OS4xNjk2LCAxLjkzNTVdLCBbNDkuMDkzMywgMy4wNTg3XSwgWzQ4LjE1NDcsIDIuNzUwMl0sIFs0OS4yMzY5LCAxLjcxMzJdLCBbNDguOTE2OCwgMy4zNzI0XSwgWzQ4LjYxNDYsIDEuNjkxNl0sIFs0OC4xNDU3LCAyLjc5OTZdLCBbNDkuMDkwMiwgMi43OTE5XSwgWzQ5LjA4ODEsIDIuOTQ1OF0sIFs0OC4zNzM2LCAzLjI2N10sIFs0OC45NDg0LCAzLjI2MjNdLCBbNDguOTE1NSwgMy4zNDkyXSwgWzQ4LjgyMDEsIDMuNDcyN10sIFs0OC44MTMxLCAzLjQ1MTVdLCBbNDguNDQ1NSwgMy40MDU3XSwgWzQ5LjAxNDcsIDEuNDc3NF0sIFs0OS4wNDIyLCAxLjQ1XSwgWzQ5LjA4MzMsIDMuMTUzNl0sIFs0OS4wNTkxLCAxLjUwMzNdLCBbNDguMTI2NCwgMi41MjA0XSwgWzQ4LjMwOCwgMi4yNjI3XSwgWzQ5LjE3MTksIDEuODU2Nl0sIFs0OS4xNTUxLCAyLjI1OTddLCBbNDguNDkxNiwgMy40MjNdLCBbNDguNDM2MSwgMy4zOTU2XSwgWzQ4LjM1NDMsIDEuOTczN10sIFs0OC42MTU5LCAxLjY3MTldLCBbNDguNjQ1MSwgMS42MzgzXSwgWzQ4LjYxMTIsIDEuNjg3MV0sIFs0OC41NDc1LCAxLjc4NDddLCBbNDguNjE0MiwgMS42NzM0XSwgWzQ4LjU3MTYsIDEuNzYxOF0sIFs0OC40NiwgMS44MzhdLCBbNDguMjUzMiwgMi40NDAxXSwgWzQ4LjQ2NzUsIDEuODMzNV0sIFs0OS4wNjQ0LCAyLjY5NzhdLCBbNDguOTA2MiwgMy4zNzI2XSwgWzQ4LjE1OCwgMi43NDYzXSwgWzQ4LjMwNzMsIDIuMTA0Nl0sIFs0OC44ODEsIDEuNTU2Ml0sIFs0OS4wOTQ4LCAyLjU2OF0sIFs0OC4zMDMyLCAzLjAxOTRdLCBbNDguODc5NiwgMy4zODA3XSwgWzQ4Ljc3OTQsIDMuNDI5NV0sIFs0OS4xNjg1LCAxLjkwNjNdLCBbNDkuMTEwNiwgMy4wOTg4XSwgWzQ4LjMxNzMsIDIuMzQ2XSwgWzQ4Ljg3MTYsIDMuMzg1MV0sIFs0OC4zMTE1LCAyLjM2NTZdLCBbNDguMzA1NiwgMi4yNDY4XSwgWzQ5LjA5NjIsIDIuNjU4NF0sIFs0OS4xNTM0LCAyLjI0MTldLCBbNDguMTM1OCwgMi40NTYxXSwgWzQ4LjI4NTQsIDIuNDIxM10sIFs0OC4xNDA5LCAyLjg0NjZdLCBbNDguMzE2MywgMi4yNDNdLCBbNDguMjg0OCwgMi4wMTEyXSwgWzQ4LjMxMzksIDIuMjcxOV0sIFs0OC4xNDcxLCAyLjc5OTNdLCBbNDkuMDg3MSwgMy4wNTc0XSwgWzQ5LjExMTMsIDMuMDY0OV0sIFs0OS4xMTU5LCAzLjA3NDFdLCBbNDguMTU3MiwgMi43NDZdLCBbNDkuMDA5MiwgMy4xODg0XSwgWzQ5LjExMDUsIDMuMDY0OV0sIFs0OS4wOTc3LCAzLjA1NTldLCBbNDkuMTA5MSwgMy4xXSwgWzQ5LjEwNzYsIDMuMTIyOV0sIFs0OS4wNDQ2LCAzLjE4MDldLCBbNDkuMTA2LCAzLjEyNThdLCBbNDkuMjA2NywgMi4wODFdLCBbNDguMzc3NSwgMy4yODI0XSwgWzQ4LjM1MjEsIDMuMDk5NF0sIFs0OC4xNDExLCAyLjU0Ml0sIFs0OC43ODM4LCAzLjQxMDNdLCBbNDguNjYwOCwgMy40NDY5XSwgWzQ4LjYzMzYsIDEuNjQ5NV0sIFs0OC4zMzAxLCAyLjI0MjldLCBbNDguODA1MiwgMS41NzcyXSwgWzQ4LjYzNDgsIDMuNDU4XSwgWzQ5LjE3MTYsIDEuOTM0OV0sIFs0OC44NDU2LCAzLjQ0NTddLCBbNDkuMjM2OCwgMS43MDkxXSwgWzQ4LjMyNDIsIDIuMzA3NF0sIFs0OC4zNDEsIDMuMDM3NF0sIFs0OC42NDMyLCAzLjUyOTddLCBbNDguNjM0MSwgMy41MTldLCBbNDguNjIwMywgMy41NTU2XSwgWzQ4LjUzNTQsIDMuNDY3Ml0sIFs0OC40Nzk2LCAzLjM4MzNdLCBbNDguNDYzOCwgMy4zOTRdLCBbNDguNDU5NywgMy40MDAyXSwgWzQ4LjQ0OTQsIDMuNDA2Ml0sIFs0OC4zMjE1LCAzLjAyODJdLCBbNDkuMDc5NCwgMi43MjA2XSwgWzQ5LjA5NDgsIDIuNjJdLCBbNDguNzM3OSwgMy40NjNdLCBbNDkuMDk3NSwgMi44MDldLCBbNDkuMDYxLCAyLjczNDNdLCBbNDguMTgzMSwgMi45NDA1XSwgWzQ4LjMwMzUsIDIuMDk5MV0sIFs0OS4xMjQ2LCAyLjU1MzNdLCBbNDguODAzNCwgMy40MjAxXSwgWzQ4Ljc2MTYsIDMuMzk3Ml0sIFs0OC40MzA1LCAzLjM5NTddLCBbNDguMzY5NCwgMy4yMjUxXSwgWzQ4LjQ2NTksIDEuODAyN10sIFs0OC44MjEzLCAxLjU4ODNdLCBbNDguNzI2LCAxLjYwNTRdLCBbNDguODk5NSwgMS41NDU5XSwgWzQ5LjIwNiwgMi4wODUxXSwgWzQ5LjE5NjUsIDIuMDkyOF0sIFs0OC40MTI5LCAzLjQyMjJdLCBbNDguOTEwOCwgMS41NDQ5XSwgWzQ5LjIyMDYsIDEuNjkwM10sIFs0OS4xODQxLCAxLjc3ODddLCBbNDkuMDg4NywgMy4wNjQzXSwgWzQ4LjEyNDUsIDIuNzA2Ml0sIFs0OC4xMjA4LCAyLjY2ODFdLCBbNDkuMDkyOSwgMi42NjUxXSwgWzQ4Ljk5MzQsIDMuMjExN10sIFs0OC44NjExLCAzLjQyOTZdLCBbNDguODQxNCwgMy40NjQ3XSwgWzQ4LjM3NTYsIDMuMzJdLCBbNDguMzY1MywgMy4yMDg3XSwgWzQ4LjU3MjIsIDEuNzYwNF0sIFs0OC4xNDE3LCAyLjczOTVdLCBbNDguMjQ5MiwgMi40Nzg4XSwgWzQ4LjI4NDgsIDIuMDA0N10sIFs0OC40MjU3LCAxLjkzOTZdLCBbNDguOTg4MiwgMy4yMjc1XSwgWzQ4Ljg3MTYsIDMuMzgxNF0sIFs0OC43NTY5LCAzLjQzMDJdLCBbNDguMzI5NywgMy4wNDE1XSwgWzQ4Ljg4MSwgMS41NTU5XSwgWzQ5LjExNDEsIDMuMDc4M10sIFs0OC4zMzMsIDIuMjQzMV0sIFs0OC4zNDIxLCAyLjIwNV0sIFs0OS4wNzc4LCAyLjcyMDJdLCBbNDkuMTc0MSwgMi4xODIxXSwgWzQ4Ljg2NCwgMy40MDQyXSwgWzQ5LjA2MDYsIDEuNTA1MV0sIFs0OS4wNjg5LCAxLjUyNV0sIFs0OS4wODI4LCAxLjU5Ml0sIFs0OS4wODQ4LCAxLjYwNDJdLCBbNDkuMTAyNSwgMS42MjcxXSwgWzQ5LjEyNTQsIDEuNjVdLCBbNDkuMTM4MiwgMS42NTNdLCBbNDkuMTM4MSwgMS42NTE1XSwgWzQ5LjE0MDQsIDEuNjUzXSwgWzQ4LjMwNzQsIDIuNDEyMV0sIFs0OC4zMTE0LCAyLjQwNzZdLCBbNDguMzE4NiwgMi4zOTg0XSwgWzQ4LjkyMjgsIDEuNTMzXSwgWzQ4Ljk3OTUsIDEuNDc1XSwgWzQ5LjIwMjQsIDEuNzIxMl0sIFs0OS4wNzkxLCAyLjc3NjRdLCBbNDkuMTUxNiwgMi4yMjQ2XSwgWzQ4Ljk0NjMsIDMuMjYxNF0sIFs0OC44NTEyLCAzLjQ0ODldLCBbNDguNTg1OSwgMy40OV0sIFs0OC4yODgyLCAxLjk3MjddLCBbNDguNjE3NCwgMS42OTA2XSwgWzQ4LjQ0NjYsIDEuODUyMl0sIFs0OC4zODg4LCAxLjk3MjddLCBbNDguNjEyNiwgMS43MDEzXSwgWzQ4LjQxOTcsIDEuOTM5MV0sIFs0OC4zOTkyLCAxLjk3NzJdLCBbNDguNTQ4MywgMS43ODUyXSwgWzQ4LjY1NDMsIDEuNjEyOV0sIFs0OC40MjYzLCAxLjkzNzZdLCBbNDkuMDk2MywgMy4wNTU5XSwgWzQ4Ljk3OTYsIDEuNDg5M10sIFs0OS4wOTgzLCAyLjY1NTJdLCBbNDguNzU0MSwgMy40MzUxXSwgWzQ4LjczNjYsIDMuNDQ0MV0sIFs0OC4zMzIyLCAzLjA0MzJdLCBbNDguNzk4OCwgMS41NzgyXSwgWzQ5LjE3NTgsIDEuODE0M10sIFs0OC4yMzg4LCAyLjQ5NDhdLCBbNDkuMTkyMSwgMS43Mzk5XSwgWzQ5LjEwMzEsIDIuNjMwNV0sIFs0OS4wOTk5LCAyLjY0NTddLCBbNDguMzU3NCwgMy4wNjA1XSwgWzQ4Ljg2MzEsIDMuNDI2NV0sIFs0OC4xNjg5LCAyLjc5NDJdLCBbNDguMTM1LCAyLjYxNzRdLCBbNDguMjE3OCwgMi41MTUzXSwgWzQ4LjMxMjksIDIuMjY1M10sIFs0OS4wODg1LCAyLjgxODZdLCBbNDguMzc4NiwgMy4zNTNdLCBbNDguODM5OCwgMy40NjI4XSwgWzQ4Ljc4MzMsIDMuNDE0XSwgWzQ4LjcwMjgsIDMuNDY5XSwgWzQ4LjQ4MzksIDMuMzk1OF0sIFs0OC4xMjIzLCAyLjY2MjldLCBbNDkuMDg5LCAxLjYxOTldLCBbNDguMzY3NywgMy4yMTQ5XSwgWzQ4LjgwMzksIDMuNDEzMV0sIFs0OC42MjIsIDMuNTU0OF0sIFs0OC4yMDEsIDIuOTcxNV0sIFs0OC4xNzksIDIuOTM0OV0sIFs0OC4xNTYzLCAyLjg2NzddLCBbNDguMzIzLCAyLjMwNjddLCBbNDkuMTgwNCwgMS44MDAzXSwgWzQ4LjQxNjQsIDMuNDIyXSwgWzQ4Ljc4MzgsIDMuNDE3NV0sIFs0OC43OTk0LCAxLjU3OV0sIFs0OS4xMDkxLCAzLjA2MzNdLCBbNDkuMTc2NywgMS45OTA0XSwgWzQ5LjEwMjQsIDIuNjI4M10sIFs0OS4wNzMyLCAyLjcxODJdLCBbNDkuMDY4MSwgMi43MzE5XSwgWzQ5LjA2MjMsIDIuNzMzNF0sIFs0OC40ODY1LCAzLjQwNDRdLCBbNDkuMTUxOCwgMi40MDQyXSwgWzQ4Ljg3MjIsIDEuNTQ2OF0sIFs0OC44NzQsIDEuNTQ2OF0sIFs0OC44ODM0LCAxLjU2MDVdLCBbNDguOTEwOSwgMS41NDUzXSwgWzQ5LjIzMjIsIDEuNzA0NF0sIFs0OS4wODMsIDIuODM2MV0sIFs0OC45MTU3LCAzLjMyMTldLCBbNDguNzE2OSwgMy40NjgxXSwgWzQ5LjA5NDUsIDIuNjE5NF0sIFs0OS4wNzg3LCAyLjkyODldLCBbNDguOTE2NSwgMy4zNDk5XSwgWzQ4Ljg0NDIsIDEuNTgyMl0sIFs0OS4wMzg3LCAzLjE4MDhdLCBbNDguMjYzOCwgMi40MjE4XSwgWzQ4LjMzMTMsIDIuMjQyXSwgWzQ4LjM0MDQsIDEuOTY5NV0sIFs0OC45MTcxLCAzLjM1NzNdLCBbNDguNzUyMywgMy40MDkxXSwgWzQ4LjYzNDUsIDMuNDUzNF0sIFs0OC40NTE4LCAxLjkyMjddLCBbNDguNDQxLCAxLjkzNDldLCBbNDguMTI4MiwgMi40NzJdLCBbNDguOTM0NSwgMS41MTJdLCBbNDkuMTY3MiwgMi4xNjI1XSwgWzQ4Ljg2NTYsIDMuNDE4OV0sIFs0OS4xMSwgMy4wNjM4XSwgWzQ4LjI1MzEsIDIuNDY3OV0sIFs0OC4yOTkzLCAyLjQyMDhdLCBbNDguNDgxMSwgMS43OTE1XSwgWzQ4LjYxMTYsIDEuNjg2NF0sIFs0OS4xNjMyLCAxLjg4NjhdLCBbNDguNzc5OSwgMy40MzA4XSwgWzQ4LjYxMTIsIDMuNTM2MV0sIFs0OC42MDI3LCAxLjcxNThdLCBbNDguODYxMiwgMS41NzcxXSwgWzQ4LjEyMSwgMi42NjldLCBbNDguNDQ1NiwgMS44NTk5XSwgWzQ5LjE4ODMsIDEuNzQwM10sIFs0OS4wOTk5LCAyLjYyNDldLCBbNDguODAyOSwgMy40MTc3XSwgWzQ5LjA1MzcsIDMuMTgxNl0sIFs0OC4xNjE3LCAyLjc3MTddLCBbNDguMTU2MywgMi43NDg4XSwgWzQ4LjI3NDgsIDIuNDE5Nl0sIFs0OC4zMjE4LCAyLjE4MThdLCBbNDkuMTc3OSwgMS42Njc3XSwgWzQ5LjE4NzgsIDEuNjY5N10sIFs0OC40MzU0LCAzLjM5NjJdLCBbNDguMTcwNywgMi41MTI0XSwgWzQ4LjY2MzEsIDEuNjAyN10sIFs0OC4zNTgsIDMuMDQ2Ml0sIFs0OC40Mzk2LCAxLjg5NDNdLCBbNDguNzc4NCwgMS41ODAzXSwgWzQ5LjA5MDYsIDMuMDYzMV0sIFs0OS4wOTk3LCAzLjE2NTJdLCBbNDguMTMzNiwgMi44Mjg1XSwgWzQ4LjE0NjEsIDIuNzk5Nl0sIFs0OC4xNjg1LCAyLjUxNDVdLCBbNDkuMTA4NCwgMi42MzMzXSwgWzQ5LjA5MiwgMi44MTQ4XSwgWzQ4Ljg5MjIsIDMuMzcyMV0sIFs0OC41Mjg5LCAzLjQ0NjhdLCBbNDguNDI2MSwgMy4zOTJdLCBbNDkuMDc0NCwgMS41MTc2XSwgWzQ4LjQ4NTMsIDEuNzk0M10sIFs0OS4wNzE0LCAxLjU1MjddLCBbNDkuMTM2NywgMS42NTQ4XSwgWzQ5LjIzMjMsIDEuNzE0M10sIFs0OS4wODkxLCAzLjAzMzFdLCBbNDkuMDkyNiwgMy4wNTldLCBbNDguMTIzMSwgMi42NjIxXSwgWzQ4LjI4NDEsIDMuMDI4NV0sIFs0OS4wNzQ4LCAyLjcyOTNdLCBbNDkuMTA0MSwgMi41MTEyXSwgWzQ4Ljk0NjEsIDMuMjYxNF0sIFs0OC42NjAzLCAzLjQ0NzRdLCBbNDguMzY0OSwgMy4yNTM5XSwgWzQ4LjQwNDMsIDEuOTMwOF0sIFs0OC40MjY1LCAxLjkzODVdLCBbNDguNDk4OSwgMS43ODkxXSwgWzQ4LjcwMjEsIDEuNTc4N10sIFs0OC40NDA2LCAxLjg3NzVdLCBbNDguNTAwMiwgMS43ODkxXSwgWzQ4LjU4NywgMS43MDM3XSwgWzQ4LjYxNTgsIDEuNjY3MV0sIFs0OC40Mjg3LCAxLjkzODVdLCBbNDguNDk3NCwgMS43OTA2XSwgWzQ4LjE2MjksIDIuNzY4XSwgWzQ4LjE1NjksIDIuNzQ2Nl0sIFs0OS4wODczLCAyLjk5ODFdLCBbNDguMzUxNiwgMy4wOTk3XSwgWzQ4LjkxNTIsIDMuMzQzNV0sIFs0OC44MjAxLCAzLjQ2ODVdLCBbNDguODA0NiwgMy40MTgyXSwgWzQ4LjMwNzIsIDIuNDEyNl0sIFs0OC42MTQzLCAxLjY2NzVdLCBbNDguNTAxMiwgMy40MzFdLCBbNDguMjg3NSwgMy4wMjcxXSwgWzQ4LjE3NjQsIDIuNTEyMV0sIFs0OC45MTU5LCAzLjM3MzFdLCBbNDguMjU2NiwgMi40Mjg0XSwgWzQ5LjE5MzIsIDIuMDM5N10sIFs0OC4yNTIsIDMuMDQ2N10sIFs0OC45MTY2LCAzLjM1NjVdLCBbNDguMTI1LCAyLjY3MzZdLCBbNDguMTI4MiwgMi41MjI3XSwgWzQ4Ljk3ODYsIDEuNTEyNF0sIFs0OS4xNjc0LCAyLjE2MjldLCBbNDguNTMwOSwgMy40MjgzXSwgWzQ4LjQ5MjEsIDMuNDIwOF0sIFs0OC40ODY2LCAzLjQxMDFdLCBbNDguNDIsIDMuNDExNl0sIFs0OS4xMDc4LCAzLjExNl0sIFs0OC4xMzE0LCAyLjQ0NzFdLCBbNDguMTM5NCwgMi40NjIzXSwgWzQ4LjI1OTIsIDIuNDI3Ml0sIFs0OC4zMDM2LCAyLjI0NTldLCBbNDkuMDg4NiwgMi43ODRdLCBbNDkuMDkxNSwgMi45NjgzXSwgWzQ4LjIwOCwgMi45ODU5XSwgWzQ4LjEzMDMsIDIuODA3Nl0sIFs0OC4xNTkyLCAyLjQ5OTZdLCBbNDguMzMzLCAyLjIyODJdLCBbNDguMzEzOCwgMi4xNjI3XSwgWzQ4LjE5MDgsIDIuOTUyM10sIFs0OC4xMzIyLCAyLjUyN10sIFs0OS4wOTk2LCAzLjE2MzFdLCBbNDguMTI1OSwgMi41MjFdLCBbNDguMTI0MiwgMi40NDQ4XSwgWzQ5LjA4NTQsIDMuMDY1NV0sIFs0OS4wOTEzLCAzLjA1OTVdLCBbNDkuMTEwOSwgMy4wODg0XSwgWzQ5LjEwNzgsIDMuMTA1MV0sIFs0OS4xMDcyLCAzLjEzMjddLCBbNDkuMDg3NywgMy4xNTg2XSwgWzQ4LjE0NjksIDIuODU4NF0sIFs0OC43NTk4LCAxLjYwODhdLCBbNDkuMDcyLCAyLjg3MjFdLCBbNDkuMDc3MywgMi45NDA4XSwgWzQ4Ljg3NiwgMy40MDI5XSwgWzQ4Ljg0NTEsIDMuNDQ1NV0sIFs0OC44NDU5LCAzLjQ4NjZdLCBbNDguNzc3OCwgMy40MDc0XSwgWzQ4Ljk3NTksIDEuNDc1MV0sIFs0OS4xNzk2LCAxLjY2NzhdLCBbNDkuMTYzMiwgMi4yODUyXSwgWzQ5LjE4MDksIDIuMzIxOF0sIFs0OC4xNTQsIDIuNzUyMl0sIFs0OC4zMTMzLCAyLjI5OTVdLCBbNDguODU4MSwgMS41ODM1XSwgWzQ5LjE3MjYsIDIuMTU3OF0sIFs0OS4xNzI1LCAyLjIyNjNdLCBbNDguOTA5NywgMy4zMzcxXSwgWzQ4LjY5NDksIDMuNDcxM10sIFs0OC40MzUsIDMuMzk2Nl0sIFs0OC4zMjgzLCAzLjAzODNdLCBbNDkuMTcwNywgMi4yODg4XSwgWzQ5LjE1MjksIDIuMzY1XSwgWzQ4LjMxNjIsIDIuMzQyXSwgWzQ5LjE3MzIsIDIuMTg5Nl0sIFs0OS4wODk5LCAyLjU3OThdLCBbNDguODAwOSwgMy40NDEzXSwgWzQ4LjczODQsIDMuNDQxM10sIFs0OC40NTkzLCAzLjQwMDJdLCBbNDguMzY2OSwgMy4yMTI3XSwgWzQ4LjczNiwgMS42MjAzXSwgWzQ5LjEyNzYsIDEuNjUxNF0sIFs0OC4xNDA4LCAyLjU1M10sIFs0OC4zMTQxLCAyLjM5NzRdLCBbNDguMzMxNSwgMi4yNDJdLCBbNDguNjAyNSwgMy41MDUyXSwgWzQ4Ljk4OTcsIDEuNDcxNV0sIFs0OC4zMTQ2LCAyLjI0OTRdLCBbNDguMzU0NywgMy4xMDExXSwgWzQ4LjkyMTksIDMuMzEzXSwgWzQ4Ljg4ODYsIDMuMzgxN10sIFs0OC44NjYzLCAzLjQyNDNdLCBbNDguNzg4OCwgMy40NDI3XSwgWzQ4LjYzNDcsIDMuNTE4OV0sIFs0OC40MjI3LCAzLjQwNDZdLCBbNDguMzY1MywgMy4yNTA1XSwgWzQ4LjkxNjMsIDMuMzQ1N10sIFs0OC40NTcxLCAzLjQwMTRdLCBbNDkuMDkyNiwgMi43OTY3XSwgWzQ5LjA4NDgsIDIuODQ0XSwgWzQ5LjA4MjgsIDIuNzgzXSwgWzQ5LjA2NzMsIDIuNzA4M10sIFs0OS4wOTM5LCAyLjYxNjldLCBbNDkuMDcwMiwgMi43NzM4XSwgWzQ5LjA2NTIsIDIuNzY2N10sIFs0OS4xMzQzLCAyLjQzNzVdLCBbNDkuMDcwMiwgMi44NTQ3XSwgWzQ4LjY0MTgsIDMuNTI2OV0sIFs0OC4zMDYyLCAzLjAxNDhdLCBbNDguNjE0NywgMS42OTIzXSwgWzQ5LjEwMzYsIDIuNTA4OV0sIFs0OS4wODY3LCAyLjU4MDZdLCBbNDguNDA5MywgMy40MjA3XSwgWzQ4LjMyMjcsIDMuMDMyXSwgWzQ4Ljg3MjQsIDMuMzkzM10sIFs0OC43Mzc5LCAzLjQ2NV0sIFs0OC40NDIyLCAzLjQwNF0sIFs0OC4zMTEzLCAyLjI4NTRdLCBbNDkuMTE5MywgMS42NDQ4XSwgWzQ5LjE0MDEsIDIuNDYwN10sIFs0OS4xMzQ1LCAyLjQ2OTldLCBbNDguOTQ0OSwgMy4yNjA1XSwgWzQ5LjEwNCwgMy4xNDExXSwgWzQ4LjMzODksIDIuMjAyOV0sIFs0OC41NTM3LCAxLjc4NzJdLCBbNDguOTMzNiwgMy4zMTI5XSwgWzQ4LjgxOTUsIDMuNDY2OF0sIFs0OC43NTQzLCAzLjQzNDldLCBbNDguNzExOSwgMy40NjUzXSwgWzQ4LjEyNDgsIDIuNzA2NV0sIFs0OC42NDg3LCAxLjYzMDddLCBbNDguOTgyLCAxLjUwNDJdLCBbNDkuMTY2MSwgMi4xNjM5XSwgWzQ5LjE1MjQsIDIuMzY1MV0sIFs0OC45MTIsIDMuMzM4N10sIFs0OS4wNTc5LCAxLjQ1NjldLCBbNDkuMDcwNCwgMS41MzAxXSwgWzQ5LjA3MzIsIDEuNTM5M10sIFs0OS4wNzM2LCAxLjU0MjNdLCBbNDkuMDgyOSwgMS41OTI2XSwgWzQ5LjA5NTksIDEuNjE4NV0sIFs0OS4xNzk2LCAxLjY2ODhdLCBbNDkuMjMxNywgMS43MDM5XSwgWzQ5LjIyNDQsIDEuNzQwNV0sIFs0OC4xNTk1LCAyLjQ5NzVdLCBbNDkuMTcyNSwgMi4yOTQ4XSwgWzQ4Ljg2NTgsIDMuNDI0NV0sIFs0OC44Mzg5LCAzLjQ2MjZdLCBbNDguNTM5MSwgMS43ODA0XSwgWzQ4LjQ3NzgsIDEuNzkyNl0sIFs0OC41MDkxLCAxLjc4MDRdLCBbNDguNDAzMiwgMS45NjY0XSwgWzQ4LjY5NDgsIDEuNTk0NF0sIFs0OC40NDk3LCAxLjkzMjhdLCBbNDguNDg4MywgMS43OTExXSwgWzQ4LjMxNDIsIDEuOTY5NF0sIFs0OC42MTE3LCAxLjcxNjRdLCBbNDguNjE0OCwgMS42Njc2XSwgWzQ4LjIwNzgsIDIuOTkwNF0sIFs0OC4xNjAzLCAyLjQ5NTFdLCBbNDguMTc5NywgMi41MDczXSwgWzQ4Ljg2MzUsIDMuNDI1OV0sIFs0OC4zNywgMy4yNjEzXSwgWzQ4LjI3MTYsIDMuMDQ0N10sIFs0OC4xNjM4LCAyLjc0NjNdLCBbNDguMTY5MywgMi41MTQ3XSwgWzQ4LjI5NTMsIDIuMDg5NF0sIFs0OS4xNTI5LCAyLjI1MjVdLCBbNDguNjM2NywgMy41MTc5XSwgWzQ4LjMzMTUsIDMuMDQyM10sIFs0OC4xOTI5LCAyLjUxMzhdLCBbNDguNjEyNywgMS42OTddLCBbNDguODM5MSwgMS41OTc5XSwgWzQ5LjE4NjQsIDIuMzEwOV0sIFs0OS4xNTI1LCAyLjM1NTJdLCBbNDguOTE4MSwgMy4zNzE0XSwgWzQ4LjgxMDYsIDEuNTgzMl0sIFs0OS4wNzc4LCAzLjE2NjZdLCBbNDguNjUwNCwgMS42MjM3XSwgWzQ4LjY2NSwgMS42MDIzXSwgWzQ4Ljg4ODcsIDMuMzgyN10sIFs0OC44NjY4LCAzLjM5OTRdLCBbNDguODM3OCwgMy40NjE5XSwgWzQ4LjgxMTIsIDMuNDQ4Ml0sIFs0OC42NTUyLCAzLjQ1NzRdLCBbNDguNjQ3NCwgMy40NTU3XSwgWzQ4LjM3MDMsIDMuMTU1NF0sIFs0OC4xNjEzLCAyLjgwOTldLCBbNDguMzMyMSwgMi4xODc5XSwgWzQ5LjE3OTMsIDIuMzIzNl0sIFs0OS4wOTc1LCAyLjU2MjldLCBbNDguODkyLCAzLjM3MzJdLCBbNDguNDc5OCwgMy4zODU0XSwgWzQ5LjE3NjgsIDEuOTY0NV0sIFs0OC4yODY3LCAyLjAwNDhdLCBbNDguMjA5OCwgMi41MTddLCBbNDguMjQ5NSwgMi40Nzg5XSwgWzQ4LjI4MjUsIDIuNDE5NF0sIFs0OC4zMTgsIDIuNDAyN10sIFs0OC4zMjA3LCAyLjQwMjddLCBbNDguOTIzMiwgMy4zNzIzXSwgWzQ4Ljg3MTYsIDMuMzg0NV0sIFs0OC40MzYyLCAzLjM5NTJdLCBbNDguMzExNCwgMi4zODM0XSwgWzQ4LjM4MDQsIDEuOTcwN10sIFs0OC45NjIzLCAxLjQ5NjZdLCBbNDguMzc0MiwgMy4zMjE5XSwgWzQ5LjAwNjcsIDMuMTk2M10sIFs0OC4zMDk1LCAyLjI5MDJdLCBbNDguMjk2NiwgMS45NjQ0XSwgWzQ5LjEyOTUsIDIuNDc2Ml0sIFs0OC43MzY2LCAzLjQ0OV0sIFs0OC42NDYxLCAzLjUwMDhdLCBbNDguMzIxNiwgMy4wMjgyXSwgWzQ4Ljc5NjMsIDEuNTc5Ml0sIFs0OC4xOTMsIDIuNTEzNF0sIFs0OC4yNTUzLCAyLjQ2OTFdLCBbNDguMzA5NywgMi40MDk2XSwgWzQ4LjMxMDEsIDIuMjg5M10sIFs0OC4zNzAyLCAxLjk4MDJdLCBbNDguNDQ0OCwgMS45MzE0XSwgWzQ4Ljc5NjQsIDEuNTc5M10sIFs0OC44MTgsIDMuNDU5NF0sIFs0OC41OSwgMy40OTc1XSwgWzQ4LjMwNzIsIDIuMTEzN10sIFs0OC4xMjMsIDIuNzA1M10sIFs0OC4zMDg5LCAyLjM1NzddLCBbNDguMzI3NCwgMi4zMzQ4XSwgWzQ5LjE2OTksIDEuODU4OF0sIFs0OS4xMTk0LCAyLjUzM10sIFs0OC40MzYyLCAxLjkzNzldLCBbNDguOTA2NywgMS41Mzg1XSwgWzQ5LjA2MDgsIDIuNzM5M10sIFs0OS4xODU4LCAyLjMxMzNdLCBbNDguMjM5NCwgMi40ODc3XSwgWzQ4LjI2MDgsIDIuNDIzNV0sIFs0OC4zMTQ0LCAyLjM1MzVdLCBbNDkuMDc2MywgMi45ODc3XSwgWzQ5LjA4NDIsIDIuOTkyMl0sIFs0OC4yMjM1LCAzLjAxMzhdLCBbNDguMjE4OSwgMy4wMTA2XSwgWzQ4LjU0MTUsIDMuNDgxN10sIFs0OC44Mzk3LCAxLjU5NTJdLCBbNDkuMTc1NywgMS45OTkzXSwgWzQ5LjE5MTYsIDIuMTNdLCBbNDkuMTczNywgMi4yMjQ0XSwgWzQ4LjQ0ODIsIDMuNDA2OV0sIFs0OC45MTU0LCAzLjM3MzNdLCBbNDkuMTUyNSwgMi4yNTM1XSwgWzQ5LjE1MzksIDIuMzY2M10sIFs0OC45MjQ3LCAxLjUyNDFdLCBbNDguMTY4NSwgMi43OTldLCBbNDguMzE2NSwgMi4yNTAyXSwgWzQ4LjY1MzQsIDMuNDU5M10sIFs0OC40Njg2LCAzLjM5NjhdLCBbNDguMzcyMywgMy4zMjk2XSwgWzQ4Ljk2NDgsIDMuMjU0OV0sIFs0OC45MjIzLCAzLjMxMjldLCBbNDguOTA2NywgMy4zNzM5XSwgWzQ4LjY4MjEsIDMuNDU0Nl0sIFs0OS4yMDI1LCAxLjY3NjldLCBbNDkuMDgyOSwgMi43ODg5XSwgWzQ5LjA5MTUsIDIuOTY4N10sIFs0OC45MTc0LCAzLjM1ODRdLCBbNDguNDgzOCwgMy4zOTY1XSwgWzQ5LjAzNDMsIDEuNDU4XSwgWzQ5LjA1MzUsIDEuNDQ3M10sIFs0OS4wNTkyLCAxLjQ3MDJdLCBbNDkuMDg0MSwgMS41OTgyXSwgWzQ5LjA4NTIsIDEuNjA1MV0sIFs0OS4xNDg1LCAxLjY1NjJdLCBbNDkuMTA5MywgMy4xMjE1XSwgWzQ5LjE1MTIsIDEuNjU5Ml0sIFs0OC4yMDY2LCAyLjk5Nl0sIFs0OC4yMDQ0LCAyLjk5M10sIFs0OC4xNTQyLCAyLjQ3MzFdLCBbNDkuMTEwOCwgMS42MzI4XSwgWzQ5LjE2NDUsIDEuODkyXSwgWzQ5LjA3NjIsIDIuNjkyN10sIFs0OS4xNzIsIDIuMjI3OF0sIFs0OC40NjQ1LCAzLjM5NDFdLCBbNDguNDUwMiwgMy40MDYzXSwgWzQ4LjM3MjEsIDEuOTgwMl0sIFs0OC40NDc4LCAxLjkyMDddLCBbNDguNDA1LCAxLjk1ODhdLCBbNDguNDA2MiwgMS45Mjg0XSwgWzQ4LjI4NjUsIDEuOTk1NF0sIFs0OC4zMDY2LCAxLjk1ODhdLCBbNDguNjA2LCAxLjcxOF0sIFs0OC42MTg5LCAxLjY4MTRdLCBbNDguMzEzOSwgMS45Nzg3XSwgWzQ4LjQ0NzUsIDEuODQ2XSwgWzQ4LjEyMjksIDIuNjcxOV0sIFs0OC4zMTYsIDIuMjUxMV0sIFs0OC4yODY2LCAyLjAwMjZdLCBbNDkuMDc4MiwgMi44OTEzXSwgWzQ5LjE2NTUsIDIuMjMyOV0sIFs0OC42ODMsIDMuNDU2M10sIFs0OS4yMTIxLCAxLjY3NzFdLCBbNDguMTI1NSwgMi40NDkyXSwgWzQ4LjE2MzksIDIuNDgyNl0sIFs0OC4zMzEsIDIuMjQwM10sIFs0OC4zMjg4LCAyLjE4ODVdLCBbNDguNjg5NCwgMS42MDY1XSwgWzQ4LjY4OTksIDEuNjAzNV0sIFs0OC44ODA5LCAxLjU1NjJdLCBbNDguOTUyMiwgMS41MDI5XSwgWzQ5LjE3MzksIDEuODE2MV0sIFs0OC4zOTA0LCAzLjQwOTZdLCBbNDguNzg0MSwgMy40NDAyXSwgWzQ4Ljc1NTUsIDMuNDAwNl0sIFs0OC42NDQsIDMuNTEzNF0sIFs0OC40NjgyLCAzLjM5NzRdLCBbNDkuMTAyMiwgMy4wNTc3XSwgWzQ4LjU5NTgsIDEuNzEwN10sIFs0OC42MTM0LCAxLjcwNzddLCBbNDkuMTU2NCwgMi4zODI2XSwgWzQ5LjE0NzIsIDIuNDM1OV0sIFs0OC42MjMsIDMuNTUyN10sIFs0OS4wODgsIDIuNTc3OF0sIFs0OS4wODU1LCAzLjA2NDVdLCBbNDkuMTY5NSwgMS42NzAyXSwgWzQ4Ljk0NTUsIDMuMjYwN10sIFs0OC44NjU1LCAzLjQxNzZdLCBbNDguNjc3MywgMS42MDU5XSwgWzQ5LjE3NTgsIDIuMjEyM10sIFs0OS4wOTg4LCAyLjU1ODRdLCBbNDguMTQxMSwgMi44NDY5XSwgWzQ4LjE2MTEsIDIuNzQwM10sIFs0OC4xMzM4LCAyLjcxODldLCBbNDguMTQ0NiwgMi40NjQ0XSwgWzQ4LjIzMDEsIDIuNTA3XSwgWzQ4LjIzOTksIDIuNDgyNl0sIFs0OC4xMjY2LCAyLjQ5MDNdLCBbNDguMjU1MiwgMi40NDZdLCBbNDguMjg4LCAyLjA0NjZdLCBbNDguMjA0NywgMi45OTE4XSwgWzQ4LjI4NDQsIDIuMDQxNF0sIFs0OS4xMDYsIDMuMTQwMV0sIFs0OS4wODg0LCAzLjAzNDhdLCBbNDkuMTEzOCwgMy4wNjg0XSwgWzQ5LjExNTksIDMuMDY5OV0sIFs0OS4xMDc5LCAzLjEwOTVdLCBbNDguNTc0OCwgMS43NTY3XSwgWzQ4Ljk4OTksIDEuNDcxNl0sIFs0OS4xODE3LCAyLjE1ODddLCBbNDkuMTc5MSwgMi4zMjQ4XSwgWzQ5LjAyOTYsIDMuMTcxM10sIFs0OS4xMTE3LCAzLjA5NTFdLCBbNDkuMDg4NCwgMy4xNTkxXSwgWzQ5LjA3ODIsIDEuNjEwMV0sIFs0OC42MDI5LCAzLjUwNDddLCBbNDguODkzNywgMy4zNjldLCBbNDguMTI1OSwgMi42Nzc0XSwgWzQ4LjQ0MDEsIDEuOTA2NF0sIFs0OC42MTE5LCAxLjcwMzddLCBbNDkuMTg0MSwgMS43Nzc2XSwgWzQ5LjA5OSwgMi42NTQ1XSwgWzQ5LjA3ODksIDIuOTM2Nl0sIFs0OC4zODA3LCAzLjI4MjddLCBbNDguOTEwOSwgMy4zMzc3XSwgWzQ4LjgxNDEsIDMuNDc3OV0sIFs0OS4yMDg2LCAxLjY3NDNdLCBbNDkuMDkxNSwgMy4wMDg1XSwgWzQ4LjE1NjEsIDIuNDc1M10sIFs0OC4yMTcxLCAyLjUxNDldLCBbNDkuMDgzNSwgMS42MTgxXSwgWzQ5LjE1MDcsIDIuNDAwNl0sIFs0OC4zNzMyLCAzLjMyNTJdLCBbNDguMzk5MywgMy4zODQ3XSwgWzQ4LjI5MTYsIDMuMDIzNF0sIFs0OC4zMDc5LCAzLjAxNTldLCBbNDguOTI2NCwgMy4zNjhdLCBbNDguOTM3NCwgMy4zMTE1XSwgWzQ4Ljc1MjcsIDMuNDA3Nl0sIFs0OC42OTc5LCAzLjQ3NzhdLCBbNDguMzA5OSwgMi40MDk1XSwgWzQ4Ljg3NTMsIDMuMzk0NV0sIFs0OC43NTM5LCAzLjQyMzRdLCBbNDguOTA5MiwgMy4zMzY1XSwgWzQ4LjM3MjIsIDMuMzU5NF0sIFs0OC40ODQ4LCAzLjQwMDVdLCBbNDguODAxNSwgMy40NDE2XSwgWzQ4LjkxNDUsIDMuMzQyN10sIFs0OC40ODEyLCAzLjM5MTNdLCBbNDguOTA3NywgMy4zNzYxXSwgWzQ5LjA3MjYsIDIuNzgyMV0sIFs0OS4xMDEsIDIuNjI2NV0sIFs0OS4wNzA5LCAyLjcxNDldLCBbNDkuMDc3NywgMi43ODIxXSwgWzQ5LjA4NTQsIDIuOTY5Nl0sIFs0OC4zMTUyLCAyLjI1XSwgWzQ5LjA3ODksIDIuOTM0NV0sIFs0OC40NDE2LCAxLjk0MDldLCBbNDkuMTczMiwgMi4xNzk4XSwgWzQ4LjQ5MDMsIDMuNDE3MV0sIFs0OC4zNjk2LCAzLjE5NDVdLCBbNDguODcwMiwgMS41NDU5XSwgWzQ5LjA4ODcsIDIuNjA2NV0sIFs0OS4xNTg4LCAyLjM3MDJdLCBbNDguNjMzMiwgMy41MzJdLCBbNDguMjA2OCwgMy4wMDQ2XSwgWzQ4LjQ1MDYsIDEuOTIyOV0sIFs0OS4wNDUzLCAzLjE4NDZdLCBbNDkuMDAwOCwgMy4yMDZdLCBbNDguMTMxMiwgMi44MDUzXSwgWzQ4LjI3MzYsIDMuMDMxN10sIFs0OC4zMTQyLCAyLjE4MThdLCBbNDguMzEzMiwgMi4xNjk2XSwgWzQ4LjkyMzQsIDEuNTExNF0sIFs0OS4wNzk4LCAyLjcyNDRdLCBbNDguMzcwOSwgMy4xOTAzXSwgWzQ4LjYxMzcsIDEuNjczNV0sIFs0OC4xNDg4LCAyLjg2XSwgWzQ5LjE4MDEsIDEuNjcxMl0sIFs0OS4wNjA5LCAyLjc0NF0sIFs0OS4xMiwgMi41MzY4XSwgWzQ4LjkzMTQsIDMuMzEyOV0sIFs0OC44MDM5LCAzLjQxMDVdLCBbNDguNjYzMSwgMy40NDA5XSwgWzQ4LjUwNTQsIDMuNDI4N10sIFs0OC42NDQ2LCAxLjYzOThdLCBbNDkuMTcwMywgMS45NDk4XSwgWzQ5LjExMywgMy4wNzk4XSwgWzQ5LjExMjEsIDMuMDc5OF0sIFs0OC4xNDExLCAyLjg0OTldLCBbNDguMTQ5NiwgMi44MDExXSwgWzQ4LjEyNDIsIDIuNDQ0M10sIFs0OC4yNTM2LCAyLjQ0MjhdLCBbNDguOTA5OCwgMS41NDM4XSwgWzQ5LjA1MTQsIDEuNDg1N10sIFs0OS4wNzI1LCAxLjU0OTddLCBbNDkuMDY5MiwgMS41NTc0XSwgWzQ5LjA3NywgMS41NzI2XSwgWzQ5LjA4OTksIDEuNjIxNF0sIFs0OS4xMTQyLCAxLjYzNTFdLCBbNDkuMTE0MywgMS42MzUxXSwgWzQ5LjEyNjYsIDEuNjUwM10sIFs0OS4xMzQ2LCAxLjY1OF0sIFs0OS4xNTI0LCAxLjY2MjVdLCBbNDguMjE4NiwgMi41MTQyXSwgWzQ4LjMyMTcsIDIuMTg1XSwgWzQ4LjQ0NTYsIDEuODYwN10sIFs0OS4xMTc4LCAyLjU1NTVdLCBbNDguNTY5MSwgMy40NjczXSwgWzQ4LjgzMTMsIDMuNDg4NV0sIFs0OC44MTk0LCAzLjQ3NDhdLCBbNDguNDE2MywgMS45MzE5XSwgWzQ4LjM4LCAxLjk3M10sIFs0OC40NTM0LCAxLjkzMDRdLCBbNDguNDAxNiwgMS45NzE1XSwgWzQ4LjMzOTcsIDEuOTddLCBbNDguMzE4OCwgMS45ODA3XSwgWzQ4LjU3NjEsIDEuNzQ1OV0sIFs0OC4xNDEsIDIuNTQzOV0sIFs0OC4zMDQ4LCAyLjI0NjZdLCBbNDguMjg3MSwgMS45ODA3XSwgWzQ5LjEyLCAxLjY0NTNdLCBbNDkuMTAyOSwgMi42MzA4XSwgWzQ5LjA3OTEsIDIuOTM0MV0sIFs0OC40ODg1LCAzLjQxNTJdLCBbNDguNDE1NiwgMy40MDc1XSwgWzQ4LjM0MDcsIDMuMDM4OF0sIFs0OS4xNzM0LCAyLjIyNTJdLCBbNDkuMTA3MiwgMy4xMzU3XSwgWzQ4LjE0OTQsIDIuNzU1NV0sIFs0OC41NjE5LCAxLjc2NTFdLCBbNDkuMDc4MiwgMi44ODY3XSwgWzQ4LjU4ODYsIDMuNDkyXSwgWzQ4LjI5NTgsIDMuMDE5NF0sIFs0OC42NTgsIDMuNDUwOV0sIFs0OS4wODY4LCAzLjA2MDddLCBbNDguMzk0MiwgMS45NzI5XSwgWzQ4LjQ3NjgsIDEuNzk2MV0sIFs0OS4yMjM2LCAxLjc0MDVdLCBbNDguODM5OSwgMy40NjI4XSwgWzQ4LjE4ODIsIDIuNTE2NV0sIFs0OC4zMTQ3LCAyLjM5NzddLCBbNDguMjg3OCwgMi4wMjEyXSwgWzQ4LjQyNTUsIDEuOTQwN10sIFs0OS4wNzg2LCAyLjg4NTVdLCBbNDguOTg1MiwgMy4yMjcxXSwgWzQ4LjkxNjUsIDMuMzQ3Nl0sIFs0OC42MzY2LCAzLjQ3MjZdLCBbNDkuMjEyNCwgMS42NzY1XSwgWzQ4LjMwNTYsIDIuMTAxXSwgWzQ5LjE4ODcsIDIuMDIxOF0sIFs0OC4zNzU5LCAzLjM2NTddLCBbNDguNjg2MSwgMy40NzA4XSwgWzQ4LjYyMTcsIDMuNTU0N10sIFs0OC40MTQ5LCAzLjQwMzhdLCBbNDguNTU5LCAxLjc2OF0sIFs0OC4zNzIxLCAxLjk3OTldLCBbNDguOTUzOSwgMS41MDU4XSwgWzQ4LjEzMiwgMi41ODddLCBbNDguMTQ2MiwgMi40NjY3XSwgWzQ4LjU0NTMsIDEuNzg0MV0sIFs0OS4wOTIzLCAyLjc5NTldLCBbNDguMzc3MiwgMy4yNzMyXSwgWzQ4Ljc4MzIsIDMuNDM0OF0sIFs0OC42NDMxLCAzLjQ4NjZdLCBbNDguNDg0NCwgMy4zOTM3XSwgWzQ5LjAyOTUsIDMuMTc1OF0sIFs0OC4yMDAzLCAyLjk3MThdLCBbNDguNDI5NywgMS45MzcxXSwgWzQ5LjA3MTUsIDIuODU0NV0sIFs0OS4xNTI0LCAyLjM2MzVdLCBbNDguODY0LCAzLjQxMzNdLCBbNDkuMDcyNSwgMS41NDg3XSwgWzQ5LjA5MDIsIDEuNjIxOV0sIFs0OS4yMDEsIDEuNzIyNV0sIFs0OC4yNTgsIDIuNDI3NF0sIFs0OC44ODk3LCAzLjM3OTFdLCBbNDguMzEzLCAyLjM5MDhdLCBbNDkuMTczMiwgMi4xOTQxXSwgWzQ5LjE2NywgMi4yMzU0XSwgWzQ4LjU1MjEsIDMuNDc2NF0sIFs0OC40NDc1LCAzLjQwNjJdLCBbNDguNTM3MywgMS43ODA0XSwgWzQ4Ljg5OTYsIDEuNTQ1Nl0sIFs0OS4wNTY3LCAzLjE4MDhdLCBbNDguMTQwMywgMi40NjMxXSwgWzQ4LjYzMjUsIDMuNTMzMl0sIFs0OC4zMTE1LCAyLjM4NTJdLCBbNDguMjg2NCwgMi4wNDM4XSwgWzQ4Ljg2NTksIDEuNTY4Nl0sIFs0OC4zNjg2LCAzLjEyMjVdLCBbNDguNDg3NCwgMy40MTIxXSwgWzQ4Ljg2MzksIDMuNDA0Nl0sIFs0OC42NzI1LCAzLjQ0MjddLCBbNDkuMTczMSwgMS45MzQ3XSwgWzQ5LjExMjUsIDMuMDY3MV0sIFs0OS4xMDYzLCAzLjEyODFdLCBbNDguMTM2NywgMi44MzkzXSwgWzQ4LjMxNSwgMi4xODI0XSwgWzQ4LjM2NTEsIDEuOTg0Nl0sIFs0OS4xNzg4LCAyLjMyNTZdLCBbNDkuMTM0NiwgMi40NjldLCBbNDguODAyOSwgMy40MzQxXSwgWzQ5LjA5NzEsIDIuNTYzNF0sIFs0OC40ODkzLCAxLjc4ODRdLCBbNDkuMDEyNCwgMy4xNjc0XSwgWzQ4LjkwODUsIDEuNTRdLCBbNDkuMTc1NywgMi4xNjE2XSwgWzQ5LjE1NDQsIDIuMjE2NF0sIFs0OC4zNzUzLCAzLjMwMTNdLCBbNDguNzg0OCwgMy40MjE2XSwgWzQ4LjYwNDgsIDMuNTA0XSwgWzQ4LjEyNjksIDIuNDYwMV0sIFs0OC40NDAzLCAxLjg2OTFdLCBbNDkuMTA1OSwgMi40OTIyXSwgWzQ4LjM3NTksIDMuMjY2OF0sIFs0OC40ODMsIDMuMzkzM10sIFs0OC40MjQxLCAzLjM5MzNdLCBbNDguMzMwOCwgMi4zMTc1XSwgWzQ4LjgzODgsIDEuNTk4M10sIFs0OS4yMzU1LCAxLjcwNzNdLCBbNDkuMDcwMiwgMi43Nzc5XSwgWzQ5LjE3NDIsIDIuMTc3M10sIFs0OC4zNzA5LCAzLjM1NjZdLCBbNDguODY3MywgMy40MjA2XSwgWzQ4LjgzODIsIDMuNDYxN10sIFs0OC44MDEzLCAzLjQyNjZdLCBbNDkuMTUyNywgMi4yMzM2XSwgWzQ5LjE3NjEsIDIuMzI4Ml0sIFs0OS4xMTk4LCAyLjU0NzZdLCBbNDguMzI2NywgMi4zMzA5XSwgWzQ4LjkxMDcsIDMuMzM0M10sIFs0OC42Mjg3LCAxLjY1NjVdLCBbNDguOTc5NCwgMS40Njc1XSwgWzQ5LjA5MTQsIDMuMTYwN10sIFs0OC40OCwgMy4zODM5XSwgWzQ5LjEwMDIsIDIuNjI0M10sIFs0OC44MDU4LCAzLjQwODddLCBbNDguNDMyNywgMy4zOTY1XSwgWzQ5LjAyMzUsIDEuNDYxNl0sIFs0OS4wNzQzLCAxLjUxMTldLCBbNDkuMDcyNiwgMS41NDddLCBbNDkuMDc4NSwgMS41NzQ0XSwgWzQ5LjA5MDksIDEuNjIzMl0sIFs0OS4xMTI4LCAxLjYzMzldLCBbNDkuMTE1OCwgMy4wNzQ0XSwgWzQ5LjEwMDMsIDMuMTUwNl0sIFs0OS4wODMyLCAxLjYxNzZdLCBbNDkuMTg4OCwgMi4wMjQ5XSwgWzQ5LjE4NzgsIDIuMTEwM10sIFs0OC4zNjc0LCAzLjI0MTddLCBbNDguMzYsIDMuMDQ5NV0sIFs0OC44MTgxLCAzLjQ1OTZdLCBbNDguMjk2MSwgMS45NzU0XSwgWzQ4LjYxNTIsIDEuNjc1MV0sIFs0OC42NDk4LCAxLjYzN10sIFs0OC40NTc2LCAxLjkyMjFdLCBbNDguNjEzMywgMS42ODQzXSwgWzQ4LjM0NDksIDEuOTc1NF0sIFs0OC40Mjc1LCAxLjkzNzNdLCBbNDguNDU3MiwgMS45MjIxXSwgWzQ4LjM0NDgsIDEuOTc1NF0sIFs0OC40NDQ1LCAxLjg2MTFdLCBbNDguNjM1NCwgMS42NDkzXSwgWzQ4LjE1NzQsIDIuNTA3M10sIFs0OC4yNTMsIDIuNDY3N10sIFs0OS4yMjM1LCAxLjY5MTZdLCBbNDkuMTUyLCAxLjY2MDhdLCBbNDguMzk1NywgMy40MTUyXSwgWzQ4LjQwMzksIDMuNDE4Ml0sIFs0OS4wOCwgMS42MTMxXSwgWzQ5LjE4ODQsIDEuNzQxMV0sIFs0OC44ODIyLCAxLjU1NjJdLCBbNDkuMTA1MSwgMi40OTc0XSwgWzQ5LjA5NCwgMi42NjI2XSwgWzQ5LjE3NzMsIDIuMjk5OF0sIFs0OC40MTMzLCAzLjQyMThdLCBbNDguODc5LCAzLjM4MDddLCBbNDguODg1NywgMy4zODIyXSwgWzQ4Ljg4ODksIDMuMzgzN10sIFs0OS4wNDMsIDMuMTc5N10sIFs0OC4zMzI2LCAyLjE5MDZdLCBbNDguMzg5LCAxLjk3MjldLCBbNDguNDg1OSwgMS43OTQ2XSwgWzQ5LjA3NzEsIDIuOTQwNl0sIFs0OS4xNzczLCAxLjgzMTVdLCBbNDguNzUzMSwgMy40MTEzXSwgWzQ4LjI5OTMsIDIuNDIwNl0sIFs0OS4wODMyLCAyLjU5ODldLCBbNDkuMTkzNiwgMi4wODk3XSwgWzQ4Ljg3MTYsIDMuMzkzMl0sIFs0OC44MTYzLCAzLjQ2MDRdLCBbNDkuMTU4MSwgMi4yNjJdLCBbNDkuMTU1OCwgMi4zNjcxXSwgWzQ5LjAwODYsIDMuMTkyMl0sIFs0OC4xNDUsIDIuNzk5Ml0sIFs0OC4xMzE1LCAyLjU5OTVdLCBbNDguMTM3NCwgMi42NDMzXSwgWzQ4LjE5NDIsIDIuOTcxXSwgWzQ4LjE4NjMsIDIuOTQ1MV0sIFs0OC4xMjkyLCAyLjQ2OTVdLCBbNDguMTU2MSwgMi40NzU3XSwgWzQ4LjI1OTcsIDIuNDI2OV0sIFs0OC4zMzA5LCAyLjIzNjJdLCBbNDkuMDg2MywgMy4wNjZdLCBbNDguMTUyNCwgMi43OTg3XSwgWzQ4LjE1OTYsIDIuODA5NF0sIFs0OS4xMDc1LCAzLjEwNTZdLCBbNDkuMTA3MywgMy4xMzc1XSwgWzQ5LjA2MjEsIDMuMTgxOF0sIFs0OS4wOTMyLCAzLjE2MTldLCBbNDkuMDA3NSwgMy4xOTddLCBbNDkuMDk1OCwgMy4wNTY4XSwgWzQ4Ljg3MzgsIDEuNTQ3Ml0sIFs0OC4zMTEzLCAyLjQwNzhdLCBbNDguMzAxNiwgMi4wOTY4XSwgWzQ4Ljc1ODQsIDMuNDI4NV0sIFs0OC41NDUyLCAzLjQ4NV0sIFs0OC45ODExLCAxLjUwMDFdLCBbNDguMzc1OCwgMS45Nzk2XSwgWzQ4LjUwOTYsIDEuNzc5OV0sIFs0OC41NjExLCAxLjc2NjJdLCBbNDguODY3NSwgMy40MjE0XSwgWzQ4Ljc4MiwgMy40NDEzXSwgWzQ5LjE4OCwgMi4wMjgyXSwgWzQ4LjMxNDcsIDIuMTU2Nl0sIFs0OS4xODE2LCAyLjNdLCBbNDkuMDc5OCwgMi41ODY2XSwgWzQ4Ljc1MzYsIDMuNDA0Nl0sIFs0OC44MzI1LCAxLjU4NDNdLCBbNDguNzY3MywgMy40MDA4XSwgWzQ4LjMzNDIsIDIuMjE1OF0sIFs0OC4yODQ4LCAyLjAxMTZdLCBbNDguMzIzNCwgMy4wMzQ0XSwgWzQ4LjkwNzQsIDMuMzc2XSwgWzQ4Ljc2ODgsIDMuNDAxOV0sIFs0OC42MzEyLCAzLjUzOTFdLCBbNDguNTM0MiwgMy40NjQ0XSwgWzQ4LjQ2NjksIDMuNDAwNF0sIFs0OC4zODk4LCAzLjQwNjRdLCBbNDguMzY4MywgMy4yNjE3XSwgWzQ4LjM2MDUsIDMuMDU0M10sIFs0OS4wODQ0LCAyLjYwMDVdLCBbNDkuMDY3NywgMi43Njk2XSwgWzQ5LjA3NTEsIDIuNjk0OV0sIFs0OS4xMDI4LCAyLjYzMDldLCBbNDkuMTAzNywgMi42MzA5XSwgWzQ5LjA4MjgsIDIuNzc4OF0sIFs0OS4wOTg4LCAyLjYyNDldLCBbNDguMTI3NywgMi40NjE5XSwgWzQ4LjI5MjksIDEuOTc0NV0sIFs0OS4xODM3LCAxLjk3NTJdLCBbNDguNzk4OCwgMy40NF0sIFs0OC4xMjMyLCAyLjcwNDFdLCBbNDguMTM2OSwgMi40NjAxXSwgWzQ4LjMwMDYsIDIuMjQ1Ml0sIFs0OS4yMDIyLCAxLjcxODldLCBbNDkuMTUxMiwgMi4zNTM1XSwgWzQ4LjMxOTgsIDMuMDI5XSwgWzQ4LjkxMTQsIDMuMzI3OF0sIFs0OC40MjY2LCAzLjM5MThdLCBbNDguODM3MiwgMS41OTY3XSwgWzQ5LjAzODEsIDMuMTc4Nl0sIFs0OS4xMzY2LCAxLjY1NF0sIFs0OC4zNzc0LCAzLjE3M10sIFs0OC4xMzEzLCAyLjUyNjFdLCBbNDguMTI3MywgMi40NjA2XSwgWzQ4LjI5NzIsIDEuOTY0XSwgWzQ4Ljg5LCAxLjU2MzFdLCBbNDkuMjAxNSwgMS43MjI0XSwgWzQ5LjE5MDUsIDIuMTA4NV0sIFs0OC44OTIxLCAzLjM3MjRdLCBbNDguOTExMiwgMy4zMjgxXSwgWzQ4LjYzMDcsIDMuNTRdLCBbNDguMTM2MywgMi41NzI1XSwgWzQ4LjI5NjksIDIuMTEwNl0sIFs0OC4yOTQ2LCAyLjA1ODZdLCBbNDguNDQ5OCwgMS45MzI1XSwgWzQ4LjQ1NDQsIDEuOTI4MV0sIFs0OS4wOTQ5LCAyLjY2MjRdLCBbNDguOTEyNiwgMy4zNDAyXSwgWzQ4LjQ5MDcsIDMuNDI4Nl0sIFs0OC40ODc1LCAzLjQxMTddLCBbNDkuMDE2NywgMS40NzcxXSwgWzQ5LjA1NDcsIDEuNDc0MV0sIFs0OS4wNjkyLCAxLjUyNDRdLCBbNDkuMDcyNywgMS41NDczXSwgWzQ5LjA5MjUsIDEuNjIzNV0sIFs0OS4yMTgsIDEuNjg2XSwgWzQ5LjIzMTIsIDEuNzAyN10sIFs0OC45MTMsIDEuNTQ1Ml0sIFs0OS4yMTY0LCAxLjY4NDZdLCBbNDguMjk1MiwgMS45NjUyXSwgWzQ4LjQ3NTQsIDEuNzk5MV0sIFs0OC42NDM5LCAxLjY0MDVdLCBbNDguNDMxMywgMS45Mzc4XSwgWzQ4LjY1MTEsIDEuNjQwNV0sIFs0OC4zMzE2LCAxLjk3ODldLCBbNDguNDM5OCwgMS44ODldLCBbNDguNDA0MywgMS45NjIyXSwgWzQ4LjMwNTUsIDEuOTYyMl0sIFs0OC40MzQ2LCAxLjkzNjNdLCBbNDkuMjMxLCAxLjcyMTVdLCBbNDkuMTU2OCwgMS42NjA4XSwgWzQ4LjgwNTIsIDEuNTc5MV0sIFs0OS4wOTIsIDIuNTc4N10sIFs0OS4wOTExLCAyLjU3ODddLCBbNDguOTgzNywgMS41MDhdLCBbNDkuMjI4NiwgMS43MDM5XSwgWzQ5LjE4MzEsIDEuOTc2OF0sIFs0OS4xNjM3LCAyLjM0M10sIFs0OS4xMTYyLCAyLjU0NzJdLCBbNDguMzY3NCwgMy4yNDQ5XSwgWzQ4LjkxNzIsIDMuMzU3N10sIFs0OC43MjA1LCAxLjYwMDhdLCBbNDkuMDgwMSwgMi41OTEyXSwgWzQ5LjE5MzQsIDIuMDM5NF0sIFs0OS4wOTk3LCAyLjU1NzhdLCBbNDkuMTg1MiwgMS43OTddLCBbNDkuMTMwOCwgMi40Nzc1XSwgWzQ4LjkwOTIsIDMuMzc2NF0sIFs0OC43NDc1LCAzLjQzNzRdLCBbNDkuMTA5MSwgMi41NTUxXSwgWzQ4LjQyNDEsIDMuMzkzN10sIFs0OC45OTI3LCAzLjIxNTRdLCBbNDkuMTAxLCAxLjYyMl0sIFs0OS4xNzg3LCAyLjIyMDVdLCBbNDkuMjE4MywgMS42ODg5XSwgWzQ4Ljk5ODgsIDMuMjA4NV0sIFs0OS4yMDk1LCAxLjY3NF0sIFs0OS4yMzMsIDEuNzEyMV0sIFs0OS4xOTEyLCAyLjEzNTJdLCBbNDkuMTc1OCwgMi4yMTMxXSwgWzQ4LjM0NzYsIDMuMDQwM10sIFs0OS4xODAzLCAxLjY2OTVdLCBbNDkuMTc1MywgMS44MTc0XSwgWzQ5LjE5MDYsIDEuNjcxM10sIFs0OS4xNTIzLCAyLjM2MjJdLCBbNDkuMTUyOSwgMi4zODY2XSwgWzQ5LjE0NjIsIDIuNDM5OV0sIFs0OS4wOTc2LCAyLjU1OTVdLCBbNDguOTAzNywgMS41NDJdLCBbNDkuMTE4LCAyLjUzOF0sIFs0OC4zNzY1LCAzLjMxNzFdLCBbNDkuMTgwMSwgMS44MDY0XSwgWzQ5LjE1OTcsIDIuMjgzOV0sIFs0OC44MDE3LCAxLjU3ODNdLCBbNDguOTU2OCwgMS40OTVdLCBbNDkuMTAzNiwgMi41MV0sIFs0OS4xMTYyLCAyLjU0NDldLCBbNDkuMDIwNiwgMS40Njc1XSwgWzQ5LjAyMjMsIDEuNDY0NV0sIFs0OS4wNzA4LCAxLjU1MjldLCBbNDkuMDc4OSwgMS41ODAzXSwgWzQ4LjQ0MDMsIDEuODkxOV0sIFs0OS4wODM2LCAxLjYwNDddLCBbNDkuMTM5MiwgMS42NTJdLCBbNDkuMTY3MiwgMS42NjcyXSwgWzQ5LjIzMDQsIDEuNzAzOF0sIFs0OS4yMjkyLCAxLjcyOTddLCBbNDkuMjA2MSwgMi4wOTA2XSwgWzQ5LjE3MDgsIDIuMjMwOF0sIFs0OC40NTI4LCAzLjQwNjNdLCBbNDguNTI4MywgMy40MzgyXSwgWzQ4LjQzODYsIDEuOTA0M10sIFs0OC40NDA0LCAxLjg3NTRdLCBbNDguNTE1MiwgMS43NzYzXSwgWzQ4LjM3OTYsIDEuOTc3NV0sIFs0OC41ODQ2LCAxLjcwMzFdLCBbNDguNjEwMywgMS43MTY4XSwgWzQ4LjYzMDcsIDEuNjU0M10sIFs0OC4zNDcsIDEuOTc0NV0sIFs0OC40OTIsIDEuNzg3XSwgWzQ4LjI5MjUsIDEuOTc3NV0sIFs0OS4yMjQ1LCAxLjY5ODZdLCBbNDguMzU2NSwgMy4xMDEyXSwgWzQ4LjUwNjUsIDMuNDI3NF0sIFs0OS4xNTEzLCAyLjIzMl0sIFs0OS4xNDg3LCAyLjM2MDhdLCBbNDkuMjM0MywgMS43MDUxXSwgWzQ5LjE3MzIsIDIuMTg4M10sIFs0OS4xNDk4LCAyLjQxNjJdLCBbNDkuMTM1NiwgMS42NTc3XSwgWzQ5LjExOTIsIDIuNTMzXSwgWzQ4Ljk5NzIsIDEuNDc1OF0sIFs0OC4zNzE0LCAzLjE1MjRdLCBbNDguOTA1MywgMS41NDAzXSwgWzQ5LjE1OTQsIDIuMzcyNF0sIFs0OC4xOTM3LCAyLjUxNjVdLCBbNDguMzAxNCwgMi40MTkxXSwgWzQ4LjE1ODEsIDIuNTAyOF0sIFs0OC4xODIsIDIuNTA5XSwgWzQ4LjMzMDEsIDIuMTg4OF0sIFs0OC4xNDEzLCAyLjczNzZdLCBbNDkuMDk2MSwgMy4wNTY1XSwgWzQ5LjExNzYsIDMuMDcxOV0sIFs0OS4xMDcxLCAzLjExNDVdLCBbNDkuMTAxNiwgMy4xNDUxXSwgWzQ5LjAyMDQsIDMuMTY0OF0sIFs0OS4xMTU2LCAzLjA2ODddLCBbNDkuMDEyNSwgMy4xNzFdLCBbNDkuMDEwOCwgMy4xODQ3XSwgWzQ5LjA0NiwgMy4xODkyXSwgWzQ5LjA0MzYsIDMuMThdLCBbNDguMzMxMSwgMi4yMzk2XSwgWzQ4LjYzNzgsIDMuNTIwNl0sIFs0OC45MDEzLCAxLjU0NDhdLCBbNDkuMTc5NSwgMS42Njc1XSwgWzQ5LjE4ODcsIDIuMTIyMV0sIFs0OC4zNzYsIDMuMzYzMV0sIFs0OC44NzIsIDEuNTQ2OF0sIFs0OS4xOTA1LCAyLjAzNThdLCBbNDguNjMxNSwgMy41MzYzXSwgWzQ5LjE1OCwgMi4zNV0sIFs0OC4zNTkyLCAzLjA4M10sIFs0OC41MDUxLCAxLjc4MTldLCBbNDkuMjIwOSwgMS42OTEzXSwgWzQ5LjE3MDQsIDEuODQ0OF0sIFs0OC4zMTE3LCAyLjE4MDldLCBbNDguOTQ5OSwgMy4yNjA2XSwgWzQ4Ljg5MjQsIDMuMzcwNF0sIFs0OC45NTk5LCAzLjI1NjFdLCBbNDguOTQ0OCwgMy4yOTU3XSwgWzQ4LjgwMzYsIDMuNDQyMV0sIFs0OC43MDMzLCAzLjQ2OTVdLCBbNDguNjQ5OSwgMy40NTg4XSwgWzQ4LjYzNDksIDMuNDYxOF0sIFs0OC45NDkyLCAzLjI2MjFdLCBbNDguOTg1NSwgMy4yMjcyXSwgWzQ5LjA2NzksIDIuNzcwMl0sIFs0OS4wNzA3LCAyLjg2NjNdLCBbNDkuMTAxLCAyLjY0MDddLCBbNDkuMDY2NiwgMi42OTFdLCBbNDkuMDg5NSwgMi44MTc1XSwgWzQ5LjA3ODYsIDIuNzc3OV0sIFs0OS4yMjQxLCAxLjczODVdLCBbNDkuMTgsIDEuNzkyMV0sIFs0OS4xMTk3LCAyLjU0MzddLCBbNDguODY1NywgMS41Njk0XSwgWzQ5LjE3NDEsIDIuMjAyOV0sIFs0OC43ODIzLCAzLjQwODJdLCBbNDkuMTczNCwgMi4yOTQ5XSwgWzQ4LjI0MiwgMy4wMjYyXSwgWzQ5LjAwNzUsIDEuNDhdLCBbNDkuMDM4NiwgMS40NTQxXSwgWzQ5LjA1MjUsIDEuNDgzXSwgWzQ5LjA4NDIsIDEuNTA3NF0sIFs0OS4wNzA5LCAxLjUzMThdLCBbNDkuMDc4MywgMS41NzkxXSwgWzQ5LjA3ODYsIDEuNjA4XSwgWzQ5LjEzNTIsIDEuNjU4M10sIFs0OS4xNDg5LCAxLjY1ODNdLCBbNDkuMTY3MywgMS44ODFdLCBbNDguNjE2MSwgMy41NTU3XSwgWzQ4LjM0MTUsIDEuOTY4OF0sIFs0OC42MTI5LCAxLjcwNTFdLCBbNDguNDQxLCAxLjk0MjldLCBbNDguNTg4OCwgMS43MDUxXSwgWzQ4LjU3NTEsIDEuNzUwOV0sIFs0OC41NzA2LCAxLjc2MzFdLCBbNDguNTc0NSwgMS43NTU0XSwgWzQ4LjM2ODksIDEuOTc4XSwgWzQ4LjQwNDgsIDEuOTM4NF0sIFs0OC40NDE1LCAxLjkzODRdLCBbNDkuMTc2MiwgMS44MzU4XSwgWzQ5LjE3OTQsIDEuODA4N10sIFs0OS4xNTU2LCAyLjIxNzddLCBbNDguNjYyMywgMy40NDI2XSwgWzQ4Ljc1NDcsIDMuNDAyMV0sIFs0OC40NDcxLCAzLjQwNjZdLCBbNDguNTI5NiwgMy40NTY5XSwgWzQ5LjE3OTUsIDEuNzQzNV0sIFs0OS4xNzY5LCAxLjk5NV0sIFs0OS4xNzk2LCAyLjE2MTVdLCBbNDkuMTU2MywgMi4zNjg5XSwgWzQ4LjcxMzYsIDMuNDY1OF0sIFs0OS4xNjk5LCAxLjg0NTVdLCBbNDguODY0OSwgMy40MjUzXSwgWzQ4Ljc5MjYsIDMuNDQyXSwgWzQ4Ljg3OTcsIDEuNTU1Nl0sIFs0OC45NTE1LCAxLjUwMjNdLCBbNDguOTgyMSwgMS41MDM4XSwgWzQ5LjEwNjIsIDIuNjM2MV0sIFs0OC44MDMzLCAzLjQxNl0sIFs0OS4xNDg1LCAyLjM1NzddLCBbNDguODY0MiwgMy40MjU2XSwgWzQ4LjYyODgsIDMuNTQ0Nl0sIFs0OC45MDk0LCAzLjM3NjRdLCBbNDguMTYzMiwgMi43Mzg1XSwgWzQ4Ljg2NzMsIDMuNDIyNV0sIFs0OC42MDQ2LCAzLjUwMzJdLCBbNDguNDU4OSwgMy40MDExXSwgWzQ4LjM3NjgsIDMuMjg5OF0sIFs0OC42MTE4LCAxLjcwMjhdLCBbNDguMzE2NCwgMi4yNTIxXSwgWzQ5LjE3ODQsIDEuODEyN10sIFs0OS4xNzU3LCAyLjAwMDZdLCBbNDkuMTM4MywgMi40NTMzXSwgWzQ4LjQ3OTgsIDMuMzgzM10sIFs0OC45MDk0LCAxLjU0MjZdLCBbNDkuMTYzNywgMi4yMjk4XSwgWzQ5LjExNzYsIDIuNTU2XSwgWzQ4Ljg3NjIsIDMuMzk5OV0sIFs0OC44NDg0LCAzLjQ4NjhdLCBbNDguNjYyOSwgMy40NDEyXSwgWzQ4LjY0MDgsIDMuNDgzOF0sIFs0OC40MTU2LCAzLjQwNzZdLCBbNDguOTEyNiwgMy4zNzQ5XSwgWzQ4Ljk2MDIsIDEuNDk4M10sIFs0OS4xODU1LCAxLjc4NDFdLCBbNDkuMTUzNywgMi4yMTc1XSwgWzQ5LjE2NDUsIDEuODM2NV0sIFs0OS4xOTk4LCAyLjA5MTRdLCBbNDkuMTU5MiwgMi4zNzVdLCBbNDguODE1NywgMy40MjE2XSwgWzQ4LjU0NTIsIDMuNDg1OF0sIFs0OC4zMjExLCAzLjAyODRdLCBbNDguOTAwOSwgMS41NDM1XSwgWzQ4LjkxODUsIDEuNTQwNV0sIFs0OS4yNDEyLCAxLjcxMjZdLCBbNDguMjk5MiwgMi4xMzU0XSwgWzQ5LjEzMTIsIDIuNDc1NV0sIFs0OC41MTczLCAzLjQyMDddLCBbNDguNDE0NiwgMy40MDddLCBbNDguMzY0OSwgMy4yMDU4XSwgWzQ4LjM3NzQsIDMuMTc1NF0sIFs0OC4zNzU4LCAzLjI2NjhdLCBbNDguMjA3LCAzLjAwMTZdLCBbNDguMzI4NSwgMi4xODc4XSwgWzQ5LjE2MjUsIDEuODgyNl0sIFs0OC40MTU2LCAzLjQwMjJdLCBbNDguODM0MiwgMS41OTQyXSwgWzQ5LjE1NTcsIDIuMzY3NV0sIFs0OC45MjI0LCAzLjM3MjRdLCBbNDguODAxNSwgMy40MjcyXSwgWzQ4LjYzODEsIDMuNDc2XSwgWzQ5LjE2NDcsIDEuODk0M10sIFs0OS4xNTI2LCAyLjI1MzhdLCBbNDkuMTAzNiwgMi41MTNdLCBbNDguODgwNiwgMy4zODI4XSwgWzQ4Ljc1MzksIDMuNDA0Ml0sIFs0OC42NDEyLCAzLjUyNjJdLCBbNDguNTM4NSwgMy40Njk3XSwgWzQ5LjA4NDYsIDEuNTA5Ml0sIFs0OS4wNzI0LCAxLjU0NThdLCBbNDkuMDgyMywgMS41OTMxXSwgWzQ5LjA4NTIsIDEuNjIyXSwgWzQ5LjA5NCwgMS42MTc1XSwgWzQ5LjA5NDMsIDEuNjE3NV0sIFs0OS4xNzEzLCAxLjk0NV0sIFs0OS4xNjc3LCAxLjg4Ml0sIFs0OS4xODE0LCAyLjMyMDddLCBbNDguNDg3MiwgMy40MDAxXSwgWzQ4LjM2MzMsIDMuMTEzNV0sIFs0OC4zODQsIDEuOTY4Ml0sIFs0OC42MTM3LCAxLjY5NTNdLCBbNDguNjE3MSwgMS42Njc5XSwgWzQ4LjM4MDQsIDEuOTY2N10sIFs0OC42MzAxLCAxLjY1NTddLCBbNDguNDI0LCAzLjM5NjFdLCBbNDguNTQ2MywgMS43ODM3XSwgWzQ4LjMwODcsIDIuMjkzOV0sIFs0OC42NDc2LCAxLjY0Ml0sIFs0OC43MDMzLCAxLjU3OTVdLCBbNDguMzk2NSwgMS45NzRdLCBbNDkuMTcwMSwgMS42N10sIFs0OS4xNTQxLCAyLjM2NTRdLCBbNDguOTg4NCwgMy4yMjkyXSwgWzQ4Ljg2MDMsIDMuNDQ1Nl0sIFs0OS4xOTksIDEuNjc1Nl0sIFs0OC4xNTQ1LCAyLjQ3MTldLCBbNDguMzE3NywgMi4zMDI4XSwgWzQ5LjE3ODMsIDEuNzQ2M10sIFs0OS4xODgxLCAyLjE0NzJdLCBbNDguNjI5NywgMy41NDIzXSwgWzQ4Ljc3ODgsIDEuNTgxMV0sIFs0OS4xMzAxLCAxLjY1NDhdLCBbNDkuMTcyMSwgMS42Njg1XSwgWzQ4LjE2NjYsIDIuNTE2OF0sIFs0OC4zMzQzLCAyLjIyNTddLCBbNDkuMTU1OCwgMi4yMThdLCBbNDguMzUyNSwgMy4xMDYyXSwgWzQ5LjE3MjEsIDEuOTM1MV0sIFs0OC42OTc5LCAzLjQ3MjZdLCBbNDguNDE2NywgMy40MjA4XSwgWzQ4LjMxMzEsIDIuMzkyMV0sIFs0OC4zMDE0LCAyLjI1NDldLCBbNDguNzg4OCwgMS41NzddLCBbNDkuMTg1NywgMi4xNDA2XSwgWzQ4LjE2NTksIDIuNzkzXSwgWzQ4LjE2NTUsIDIuNzc2M10sIFs0OC4xMjUxLCAyLjY5MzldLCBbNDguMTUyOCwgMi43OTkyXSwgWzQ4LjEzMjIsIDIuNDUxNl0sIFs0OC4yNjc5LCAyLjQyMTJdLCBbNDguMzM3OSwgMi4yMDAxXSwgWzQ4LjI4NjcsIDIuMDA0OV0sIFs0OC45MTU3LCAzLjM0ODhdLCBbNDguODY0NSwgMy40MDM4XSwgWzQ5LjEwOTYsIDMuMDYzM10sIFs0OS4xMTczLCAzLjA2OTNdLCBbNDkuMTA2OSwgMy4xMjQzXSwgWzQ5LjA1NTYsIDMuMTgwNl0sIFs0OS4wMjg4LCAzLjE3MzFdLCBbNDkuMDA1OCwgMy4xOTldLCBbNDguOTMxOSwgMS41MTEyXSwgWzQ5LjEwMzgsIDIuNTU4MV0sIFs0OC43OTE0LCAzLjQ0NF0sIFs0OS4wODM4LCAxLjUwOF0sIFs0OS4xODQzLCAxLjc4MDldLCBbNDkuMTUwNywgMi4zODk0XSwgWzQ5LjEyMjIsIDIuNTQyXSwgWzQ4LjQzNTYsIDMuNDAxMV0sIFs0OC4yNTY1LCAzLjA0Nl0sIFs0OC4yNDE1LCAzLjAyNzZdLCBbNDkuMTYyNCwgMi4zNDU1XSwgWzQ5LjA5MzQsIDIuNTczOF0sIFs0OC41MzczLCAzLjQ2ODddLCBbNDguNDg3LCAzLjM5ODddLCBbNDguNjEyLCAxLjcwNDJdLCBbNDguNjA2OSwgMS43MTc5XSwgWzQ5LjIzMjYsIDEuNzA0N10sIFs0OC4xNjI0LCAyLjc1MjddLCBbNDguMTUyLCAyLjc1NDJdLCBbNDguMzMwNCwgMi4xODg3XSwgWzQ4LjYzMzksIDMuNDU3OV0sIFs0OC45MjI0LCAxLjUzNTVdLCBbNDguNzgsIDMuNDA4M10sIFs0OC4zMDE2LCAyLjI0NDldLCBbNDguMzA3NiwgMi4xMDYyXSwgWzQ5LjI0MTMsIDEuNzA5NF0sIFs0OC44ODk4LCAzLjM3NzhdLCBbNDguODY2MSwgMy40MDA3XSwgWzQ4Ljc4MTksIDMuNDM0M10sIFs0OC43NjI5LCAzLjM5NzddLCBbNDguNDM4MywgMy40MDM3XSwgWzQ4LjM3ODUsIDMuMzU2Nl0sIFs0OC4zNzcsIDMuMzA5M10sIFs0OS4xMDQxLCAyLjYzMTJdLCBbNDkuMDg1NSwgMi42Nzg1XSwgWzQ5LjA3MTYsIDIuOTg1XSwgWzQ5LjA4MjksIDIuNzgzOF0sIFs0OS4wODAxLCAyLjcyMjhdLCBbNDguNTI4MiwgMy40NDAxXSwgWzQ5LjA2MDUsIDIuNzM1XSwgWzQ5LjA5NSwgMi42MjIyXSwgWzQ5LjA3MjEsIDIuNjkyMl0sIFs0OC45Nzg0LCAxLjUxNF0sIFs0OC45NTExLCAxLjUwMTldLCBbNDkuMDgyNywgMS41OTVdLCBbNDkuMTQxNywgMi40MzldLCBbNDguNzAxNSwgMy40NzE5XSwgWzQ4LjUyODcsIDMuNDUwN10sIFs0OC43NzgxLCAxLjU4MDFdLCBbNDguMTQwNiwgMi41NDg1XSwgWzQ5LjE4MjcsIDEuOTc4MV0sIFs0OC44NzI3LCAzLjQwNTVdLCBbNDguMzcxOSwgMy4xNjc3XSwgWzQ4LjkzMjQsIDEuNTExNF0sIFs0OS4xODcyLCAxLjY2OTJdLCBbNDkuMTcwMywgMS45NDIxXSwgWzQ5LjE3NzIsIDIuMTYzNF0sIFs0OS4xNTUzLCAyLjI1OF0sIFs0OC43MTQ1LCAzLjQ2NjJdLCBbNDguNDE1NSwgMy40MTU5XSwgWzQ4LjQ5MjIsIDMuNDIxNV0sIFs0OS4yMzQ0LCAxLjcxMjldLCBbNDkuMTQwNywgMi40NTc2XSwgWzQ4LjY0NzQsIDMuNDk0Ml0sIFs0OC43MTU3LCAxLjU5NF0sIFs0OS4xMjQxLCAyLjU1MjZdLCBbNDguOTAxMiwgMy4zNzA2XSwgWzQ4Ljg4NzUsIDMuMzg0M10sIFs0OC42NDY4LCAzLjQ4OTZdLCBbNDguNTUwNSwgMy40Nzg5XSwgWzQ4LjQ3OTksIDMuMzg0M10sIFs0OC42NDcyLCAzLjQ5ODZdLCBbNDkuMDM2OSwgMS40NTYyXSwgWzQ5LjA1MjMsIDEuNDgzNl0sIFs0OS4wNjg3LCAxLjUwOTVdLCBbNDkuMDcwNCwgMS41MDk1XSwgWzQ5LjA3MjEsIDIuOTgwOF0sIFs0OS4xOTAzLCAyLjAzNTZdLCBbNDguNzgzNywgMy40MTA4XSwgWzQ4LjQyMzQsIDMuMzkyNl0sIFs0OC4zNjc4LCAzLjEyODldLCBbNDguNDE5OSwgMS45MzIxXSwgWzQ4LjYxNCwgMS42ODM2XSwgWzQ4LjM2ODUsIDEuOTgzOV0sIFs0OC41MDU3LCAzLjQyODJdLCBbNDguMzgwNSwgMS45NzAyXSwgWzQ4LjY5MzMsIDEuNTk2N10sIFs0OC40NTIzLCAxLjkyMjldLCBbNDguMjg1OCwgMi4wMTE4XSwgWzQ4LjQ0OTksIDEuOTMyMV0sIFs0OC42MTM4LCAxLjcwOTVdLCBbNDguNTY1NCwgMy40NzA4XSwgWzQ4LjkyMDksIDMuMzE0Nl0sIFs0OC40MzIxLCAzLjM5NTNdLCBbNDguMjU0MSwgMi40NjU5XSwgWzQ4LjMwODcsIDIuMzY5OF0sIFs0OS4xNjY1LCAyLjIzMzhdLCBbNDguODQzNSwgMy40ODc1XSwgWzQ4LjczODEsIDMuNDU2OV0sIFs0OC4xMjczLCAyLjQ2OF0sIFs0OC4zMDUyLCAyLjQxNDddLCBbNDguNzI4OSwgMS42MTAxXSwgWzQ5LjE4MzEsIDEuODAzXSwgWzQ5LjE0NjMsIDIuNDM5MV0sIFs0OC4yNjI1LCAyLjQyMjFdLCBbNDguMzI4MywgMi4zMTA4XSwgWzQ5LjEyMDksIDIuNTM3OV0sIFs0OC41ODM2LCAzLjQ4NzhdLCBbNDguNDU4MywgMy40MDA5XSwgWzQ4LjEzMjIsIDIuNDQ4Nl0sIFs0OC4zMTQ5LCAyLjQwNDNdLCBbNDguOTEsIDMuMzc2NF0sIFs0OC44MTY5LCAzLjQ3NTVdLCBbNDguNzgxLCAzLjQyNjddLCBbNDguOTE2OCwgMS41NDA5XSwgWzQ5LjEyMDMsIDIuNTQ3NF0sIFs0OC42OTIyLCAzLjQ3MTRdLCBbNDguNTI5MSwgMy40MzMzXSwgWzQ4LjM5MTUsIDMuNDE1MV0sIFs0OC4zODEsIDMuMzYzMV0sIFs0OC4yMjcyLCAzLjAxODddLCBbNDguNjUxNywgMS42MjNdLCBbNDguNzM3NSwgMS42MjE1XSwgWzQ5LjE4ODMsIDIuMTM1MV0sIFs0OC4yODczLCAyLjQyM10sIFs0OC4yODgyLCAyLjQyM10sIFs0OC4zMzAyLCAyLjMyODZdLCBbNDkuMTQ4NSwgMi4zNTc1XSwgWzQ5LjE5NTQsIDEuNzI1OF0sIFs0OC44MzkxLCAzLjQ2MTJdLCBbNDguMTQxNiwgMi41NjA1XSwgWzQ4LjI5OTIsIDIuMjQ4XSwgWzQ4Ljk0OSwgMS41MDc2XSwgWzQ5LjA3MTMsIDIuOTgyOF0sIFs0OC45NDk1LCAzLjI2MTJdLCBbNDguOTQwNSwgMy4yNjQyXSwgWzQ4LjI4MTksIDMuMDI2NF0sIFs0OC4yODY3LCAyLjAwMjRdLCBbNDguNzUwNiwgMS42MjE4XSwgWzQ5LjE1NTMsIDIuMzY2OV0sIFs0OS4xNTYxLCAyLjM2ODRdLCBbNDguOTEyNCwgMy4zMzk1XSwgWzQ4LjkyNCwgMy4zNzE2XSwgWzQ5LjExMTksIDMuMDg2N10sIFs0OC40OTIzLCAzLjQzMzhdLCBbNDguMzY4OSwgMy4yMTg5XSwgWzQ5LjE3OTYsIDEuODI2OV0sIFs0OC4xNTQ1LCAyLjQ3MjNdLCBbNDguMzA3MiwgMi4yNTg5XSwgWzQ4LjMyMTYsIDIuMTgyN10sIFs0OC44ODcxLCAzLjM4MjZdLCBbNDguMzU3LCAzLjEwOTddLCBbNDguMzEwMiwgMi4zNzUzXSwgWzQ4LjMyNjUsIDIuMzI4Ml0sIFs0OC4zMjk1LCAyLjIyNzZdLCBbNDguOTUzOSwgMS41MDg0XSwgWzQ4LjQ4NjIsIDMuNDA5OV0sIFs0OC4xNDUzLCAyLjQ2NTFdLCBbNDguOTMyNSwgMy4zMTI5XSwgWzQ4LjU1MDIsIDMuNDgzN10sIFs0OC4zNTUxLCAzLjA0NDVdLCBbNDguOTk3MiwgMS40NzY3XSwgWzQ5LjExMDEsIDMuMDY0Nl0sIFs0OC45ODM5LCAxLjQ2NjFdLCBbNDkuMDc4NCwgMS41NzUxXSwgWzQ4LjQ4OTksIDMuNDE5NF0sIFs0OS4wNTE5LCAxLjQ4NzddLCBbNDkuMDUzLCAxLjQ4NzddLCBbNDkuMDUzNSwgMS40ODc3XSwgWzQ4LjkxMDMsIDEuNTQ0M10sIFs0OS4wNzc2LCAxLjUxMzZdLCBbNDkuMDY4NSwgMS41MjI4XSwgWzQ5LjA2OSwgMS41MjU4XSwgWzQ5LjA2OTgsIDEuNTI1OF0sIFs0OS4wNzE3LCAxLjUzNV0sIFs0OS4wODc4LCAxLjYxOTFdLCBbNDkuMjE1NiwgMS43MzIyXSwgWzQ5LjE3NDksIDIuMzI5OV0sIFs0OC44NTI0LCAzLjQ0ODldLCBbNDguNTI5LCAzLjQzMzddLCBbNDguMzA0OCwgMS45NjExXSwgWzQ4LjYxOTcsIDEuNjg1Ml0sIFs0OC4yOSwgMS45NzMzXSwgWzQ4LjM2NDQsIDEuOTg1NV0sIFs0OC42ODk0LCAxLjYwOV0sIFs0OC40NzY2LCAxLjc5NjVdLCBbNDguNjE5MSwgMS42ODY3XSwgWzQ4LjMyMDEsIDIuNDAzNV0sIFs0OC42NTcxLCAxLjYxMDVdLCBbNDguODA4MSwgMS41ODE2XSwgWzQ5LjE0ODUsIDEuNjU3OF0sIFs0OS4wODYxLCAyLjY3NzldLCBbNDguODk1OCwgMy4zNjk0XSwgWzQ4LjQzMzMsIDMuMzk3XSwgWzQ4LjMwMjIsIDIuNDE3MV0sIFs0OC4zNDI2LCAyLjIwMzddLCBbNDkuMjExNywgMS42NzU5XSwgWzQ4LjQ4NywgMy40MTI4XSwgWzQ5LjE4NDEsIDEuNzc2OF0sIFs0OC4xNjQ1LCAyLjQ4MzJdLCBbNDguMjM5MiwgMi40OTI0XSwgWzQ5LjE2NCwgMi4xNjkyXSwgWzQ4Ljk0NjcsIDMuMjYxNl0sIFs0OS4xOTI0LCAyLjEzMDZdLCBbNDguNDI3MiwgMy4zOTNdLCBbNDkuMTUyNCwgMi4zNjQxXSwgWzQ4LjkwOTcsIDMuMzMyNF0sIFs0OC41MzM5LCAzLjQ2MzRdLCBbNDguMTkyMSwgMi45NjIzXSwgWzQ4LjE1NzYsIDIuNzQ1OV0sIFs0OS4wODE4LCAyLjY4MzRdLCBbNDkuMTM1NiwgMi40NDcxXSwgWzQ4LjE1NDcsIDIuODY2MV0sIFs0OC4yNTI1LCAyLjQ3NDJdLCBbNDguMzAzNSwgMi40MTY0XSwgWzQ4LjIwNjIsIDIuOTgwNF0sIFs0OC4xNzI0LCAyLjkzNDZdLCBbNDguMTU4OCwgMi43NDU2XSwgWzQ4LjEyNTksIDIuNzA3NV0sIFs0OC4xMjczLCAyLjUyMTVdLCBbNDguMzE5MywgMi40MDI3XSwgWzQ4LjMyMDIsIDIuMzQwMl0sIFs0OS4wOTM4LCAzLjE2MjFdLCBbNDkuMDg2MiwgMy4wNjNdLCBbNDkuMTE3NiwgMy4wNzA3XSwgWzQ5LjAyOTgsIDMuMTcxM10sIFs0OC4yMjY2LCAyLjUxN10sIFs0OS4wNDQ1LCAzLjE4MDVdLCBbNDkuMjMxLCAxLjcwMjZdLCBbNDkuMTI2MSwgMi40ODQ5XSwgWzQ4Ljc2MDUsIDEuNjAwMV0sIFs0OC4yNTMsIDIuNDY3M10sIFs0OC4zMTQ2LCAyLjQwNDhdLCBbNDguODU5NiwgMy40MzQ3XSwgWzQ5LjA2NDIsIDIuNzY0M10sIFs0OC44OTU1LCAxLjU1MzNdLCBbNDkuMTgwOCwgMS44MDIzXSwgWzQ5LjExMTgsIDMuMDgwMl0sIFs0OC4zMDE2LCAyLjQxODhdLCBbNDguODYwOSwgMS41NzkzXSwgWzQ5LjE2NiwgMi4xNjQzXSwgWzQ4LjgwMjEsIDMuNDMyXSwgWzQ4LjM2NjUsIDMuMjU2N10sIFs0OC42MzAxLCAzLjU0MV0sIFs0OC4zMDA5LCAyLjE2MjVdLCBbNDguMjk4NiwgMi4wOTA4XSwgWzQ4LjM3NTYsIDMuMTc4N10sIFs0OC40OTIyLCAzLjQyMTJdLCBbNDguMzcyOSwgMy4zMDUyXSwgWzQ4LjkyOTcsIDMuMzEyOV0sIFs0OC44ODg2LCAzLjM4MTRdLCBbNDguNzgxNSwgMy40MjU3XSwgWzQ4LjQ4NTYsIDMuNDA5XSwgWzQ4LjQ4NywgMy40MDQzXSwgWzQ4LjQ4NiwgMy4zOTgzXSwgWzQ4LjQ2MDIsIDMuMzk5OF0sIFs0OS4wNjc5LCAyLjY4OThdLCBbNDkuMDk5NSwgMi42NDFdLCBbNDkuMDg1NCwgMi45NTY1XSwgWzQ5LjA2OTMsIDIuNzMyNF0sIFs0OS4wNzgxLCAyLjcyMDJdLCBbNDkuMTAzNiwgMi42MzY1XSwgWzQ4LjI5ODQsIDIuMTYxNl0sIFs0OS4xNzk1LCAyLjE2MzFdLCBbNDguMzczMSwgMy4zNDA5XSwgWzQ4LjE2NTgsIDIuNzM3N10sIFs0OC4zMDg4LCAyLjE1MzhdLCBbNDkuMTc5MiwgMS42NjcxXSwgWzQ5LjE5NDgsIDEuNzMxMV0sIFs0OS4wODY3LCAzLjA0NDRdLCBbNDkuMDA4NywgMy4xOTA4XSwgWzQ5LjIwNTcsIDIuMDc5N10sIFs0OS4xNTI4LCAyLjIxOTldLCBbNDguNDkwNCwgMy40MjM2XSwgWzQ5LjE4MDgsIDIuMzIyXSwgWzQ5LjEwMzksIDIuNTAzNV0sIFs0OS4yMDI1LCAxLjcyMjFdLCBbNDguMTcxLCAyLjUxMjRdLCBbNDkuMTQ3LCAyLjQzNjJdLCBbNDguOTAyMSwgMy4zNzA5XSwgWzQ4LjQ2OTEsIDMuMzk2OF0sIFs0OC4zMTMzLCAzLjAyMThdLCBbNDguMTgwNCwgMi41MDgzXSwgWzQ4LjY0NywgMy40NTddLCBbNDkuMTkzNiwgMi4wOTA3XSwgWzQ4LjQ3MDMsIDMuMzk2NV0sIFs0OC40MDksIDMuNDIwOV0sIFs0OS4wNDQsIDEuNDQ4NF0sIFs0OS4wNDcsIDEuNDQ4NF0sIFs0OC45ODA0LCAxLjQ3ODhdLCBbNDkuMDkyMiwgMS42MjM3XSwgWzQ5LjE1ODcsIDEuNjYxOF0sIFs0OS4yMTE4LCAxLjY3NF0sIFs0OS4yMzIzLCAxLjcxMzZdLCBbNDkuMTk1NywgMS43MjU4XSwgWzQ4LjEzOCwgMi43OTkzXSwgWzQ4LjI1NDYsIDIuNDY3MV0sIFs0OC44MDcsIDEuNTgzM10sIFs0OC45NjAyLCAxLjQ5OTRdLCBbNDkuMSwgMi41Mjk2XSwgWzQ4LjQyMzUsIDMuNDA0OF0sIFs0OC4yMzQyLCAzLjAyMDZdLCBbNDguMzYzNiwgMS45ODldLCBbNDguNDkzLCAxLjc4NzhdLCBbNDguNzA1NiwgMS41ODY2XSwgWzQ4LjcwOTgsIDEuNTg4MV0sIFs0OC4yODY2LCAxLjk5NjddLCBbNDguNDI1OSwgMS45Mzg3XSwgWzQ4LjY0OTgsIDEuNjI2Ml0sIFs0OC40NjYyLCAxLjgxMDddLCBbNDguNjU2OCwgMS42MTFdLCBbNDguNDA2MywgMS45NDY0XSwgWzQ4Ljc0ODEsIDEuNjI2NF0sIFs0OS4xNzQyLCAyLjIwMzhdLCBbNDguODYwNywgMy40MzA0XSwgWzQ4Ljg1MDgsIDMuNDQ4OF0sIFs0OC44MTc4LCAzLjQ3NDhdLCBbNDguMTM0NCwgMi44MzY0XSwgWzQ4LjQxNDIsIDMuNDExMl0sIFs0OS4xNTgsIDIuMzgwNV0sIFs0OC4yODI5LCAzLjAyNzFdLCBbNDguMzMxOSwgMi4zMjQ2XSwgWzQ4LjMyMjcsIDIuMTg0NF0sIFs0OC44MTA2LCAxLjU4MjddLCBbNDguNDMyNiwgMy4zOTU4XSwgWzQ5LjE3NjksIDEuOTk2MV0sIFs0OC4yOTc0LCAyLjExNzFdLCBbNDkuMjEsIDEuNzIyXSwgWzQ4LjU5MSwgMy41MTUyXSwgWzQ4Ljc5MDksIDEuNTc1NF0sIFs0OC4yMDU2LCAyLjk3NDVdLCBbNDkuMTUxOSwgMi4yMjNdLCBbNDguNzk3NywgMy40NDA0XSwgWzQ5LjAwMzYsIDMuMjAwNV0sIFs0OC4zMTcsIDIuMzQ0N10sIFs0OS4yMjkzLCAxLjcwNDFdLCBbNDkuMDgxLCAyLjkzMzFdLCBbNDguODczOCwgMy40MDU5XSwgWzQ4LjEyMjcsIDIuNDUzNl0sIFs0OS4wNzg2LCAyLjkyNzVdLCBbNDkuMTc4MywgMi4yOTk1XSwgWzQ4Ljk3NzUsIDMuMjM2NV0sIFs0OC44NDE0LCAzLjQ1OTFdLCBbNDguMjE0NiwgMy4wMDY5XSwgWzQ5LjE3NDcsIDIuMzMwMV0sIFs0OC40MzIsIDEuOTM5MV0sIFs0OC40OTc1LCAxLjc4OTddLCBbNDkuMTc2OSwgMS44MTM5XSwgWzQ4LjI3MTgsIDIuNDE4Ml0sIFs0OC4zMTE4LCAyLjM4NjNdLCBbNDkuMTgwMSwgMi4xNjA3XSwgWzQ4LjUzMTMsIDMuNDI2MV0sIFs0OC4yNSwgMy4wNDA0XSwgWzQ4LjIxNTQsIDMuMDA4M10sIFs0OC4zMjM1LCAyLjMzODFdLCBbNDkuMjM0NCwgMS43MTI3XSwgWzQ4LjM3ODIsIDMuMjcwNF0sIFs0OC45Mzc1LCAzLjI3MTldLCBbNDguODkxOSwgMy4zNzRdLCBbNDguNTg5OCwgMy41MTU5XSwgWzQ4LjQ5NywgMy40MzVdLCBbNDkuMTcyNCwgMS45MzQ3XSwgWzQ5LjA4MjMsIDEuNTkzNl0sIFs0OS4xNDc1LCAxLjY1NjFdLCBbNDguNjMxNiwgMy41Mzc3XSwgWzQ4LjQyMjUsIDMuNDAwNV0sIFs0OC40ODY4LCAzLjQwMDVdLCBbNDkuMTQ3NSwgMi40MzU0XSwgWzQ5LjA0MjcsIDMuMTc5Nl0sIFs0OC4xMzIzLCAyLjcxNzldLCBbNDguMzEsIDIuMjYzN10sIFs0OS4xODA4LCAxLjc2OTNdLCBbNDkuMjM1OSwgMS43MTNdLCBbNDkuMDkzMiwgMi41NzQ3XSwgWzQ4LjYxNTksIDMuNTU3M10sIFs0OC4zNTEyLCAzLjEwMDFdLCBbNDguNTQxNywgMS43ODIyXSwgWzQ5LjE0NjcsIDEuNjU0OV0sIFs0OS4wNjM0LCAyLjczM10sIFs0OS4wODE1LCAyLjc3MjZdLCBbNDguNzg0NSwgMy40MTQ3XSwgWzQ4LjQ4NzksIDMuNDA0XSwgWzQ4LjQ4NzQsIDMuMzk5M10sIFs0OS4xNzIsIDEuODY3MV0sIFs0OC44Njk3LCAxLjU0OTVdLCBbNDguODk3OCwgMS41NDk1XSwgWzQ5LjIwNDEsIDIuMDcyXSwgWzQ4Ljc4NDEsIDMuNDA4NF0sIFs0OC42MjIyLCAzLjU1MzFdLCBbNDguODY1MSwgMy40MTVdLCBbNDguOTk5NiwgMS40NzgyXSwgWzQ5LjA5NDgsIDIuNjEyMV0sIFs0OS4xNjc5LCAyLjE3MTRdLCBbNDguODYwMiwgMy40MzMxXSwgWzQ4LjY4NjEsIDMuNDY1Ml0sIFs0OS4wNTQ4LCAxLjQ4OThdLCBbNDkuMDcyNiwgMS41NTA4XSwgWzQ5LjA3MTUsIDEuNTUyM10sIFs0OS4xMDM5LCAxLjYyN10sIFs0OS4xMDUxLCAxLjYyN10sIFs0OS4yMDg4LCAxLjY3NDNdLCBbNDkuMjEzOCwgMS42Nzg4XSwgWzQ5LjIzODksIDEuNzEyNF0sIFs0OC4xNDA3LCAyLjc5NzhdLCBbNDguMjk4MSwgMi4wOTA2XSwgWzQ5LjA3MTQsIDEuNTMyMl0sIFs0OC44OCwgMy4zODE5XSwgWzQ4LjM5NTcsIDMuMzkyNl0sIFs0OC4zMTgzLCAxLjk3OTJdLCBbNDguNDY2NiwgMS44MjUzXSwgWzQ4LjcwMjYsIDEuNTc2OF0sIFs0OC40NCwgMS45MDQ1XSwgWzQ4LjUyOTYsIDEuNzc2NV0sIFs0OC42MTI0LCAxLjcwMThdLCBbNDguNDY3MSwgMS44MjgzXSwgWzQ4LjE2MDMsIDIuNTEwM10sIFs0OC4yODY0LCAyLjAwMTFdLCBbNDguNDI1OSwgMS45Mzk2XSwgWzQ4LjMwNSwgMS45NjE4XSwgWzQ5LjE5MzcsIDIuMDg5NV0sIFs0OC40MjQxLCAzLjM5MzhdLCBbNDguMzkyMSwgMy40XSwgWzQ4LjEyNTMsIDIuNzA2N10sIFs0OC4xMzg2LCAyLjYzNjddLCBbNDguMTU0NiwgMi40NzE5XSwgWzQ5LjE0NTMsIDEuNjU0NV0sIFs0OS4xNDk5LCAyLjQxNTRdLCBbNDkuMTU1OSwgMi4zNjgzXSwgWzQ4LjQ5MDUsIDMuNDIwM10sIFs0OC40ODU2LCAzLjM5OTFdLCBbNDguNDI3OCwgMy4zOTQ0XSwgWzQ4LjM3MDEsIDMuMTQxNF0sIFs0OC4yODIyLCAyLjQxOTJdLCBbNDguMzEzNSwgMi4zNTUyXSwgWzQ4Ljk3ODksIDEuNDgwNl0sIFs0OC41NzMxLCAzLjQ2OV0sIFs0OC41NDcsIDMuNDg1N10sIFs0OS4yMjYsIDEuNjk4OF0sIFs0OC4zMDgyLCAyLjQwOTldLCBbNDguNTI4LCAzLjQwNTRdLCBbNDguNDcwMSwgMy4zOTMyXSwgWzQ4LjE2MjIsIDIuNDg4Ml0sIFs0OC4yNjQ0LCAyLjQyMTJdLCBbNDguMzMyNCwgMi4xODc5XSwgWzQ5LjA5OTUsIDIuNjUyOF0sIFs0OS4xODQ5LCAyLjE0ODNdLCBbNDguMTYwMSwgMi44MDg3XSwgWzQ4LjEyNTgsIDIuNTE3Nl0sIFs0OC4xMjY1LCAyLjUxNjFdLCBbNDguMTM0MywgMi40NTE5XSwgWzQ4LjMwOSwgMi4zNTc1XSwgWzQ4LjMzMTMsIDIuMjQ2Ml0sIFs0OC4zMjkzLCAyLjIzNTVdLCBbNDguMzQzMSwgMi4yMDE5XSwgWzQ4LjI5NDEsIDIuMDY5NF0sIFs0OS4wOTE1LCAzLjAwODhdLCBbNDkuMTE3NSwgMy4wNzEzXSwgWzQ5LjA0NjMsIDMuMTkwMV0sIFs0OS4wODUxLCAzLjA1MTRdLCBbNDkuMDg3LCAzLjA2NTFdLCBbNDkuMDg5NywgMy4wNjM2XSwgWzQ5LjExMjMsIDMuMDgyXSwgWzQ5LjE3OTksIDEuNzkxXSwgWzQ5LjA3MTcsIDIuODczNl0sIFs0OS4xODA1LCAyLjEzNzNdLCBbNDguOTQ1NiwgMy4yNjFdLCBbNDguNTEwOSwgMy40MjU2XSwgWzQ4Ljc2MzMsIDEuNTg0OV0sIFs0OS4wODAyLCAxLjU4MzldLCBbNDguODE1MiwgMy40MjM1XSwgWzQ5LjE3MjMsIDEuOTU1OV0sIFs0OC4yNDQ0LCAyLjQ3NjNdLCBbNDkuMDg0MiwgMS42MDcxXSwgWzQ5LjA3NjYsIDIuODUxM10sIFs0OS4xMjE1LCAyLjU0MzVdLCBbNDguNzY5NywgMy40MDI2XSwgWzQ4LjQ4MzUsIDMuMzkzNF0sIFs0OC4xMjQ4LCAyLjcwNjNdLCBbNDguMzEwNCwgMi4yODg3XSwgWzQ5LjE1MjMsIDIuMzY0OV0sIFs0OS4xMzUxLCAyLjQ3XSwgWzQ4LjM2NzUsIDMuMjE0Ml0sIFs0OS4xMTA2LCAzLjA5MjRdLCBbNDkuMTU4NywgMi4zN10sIFs0OC45MTI4LCAzLjMyNjddLCBbNDguNjI5NCwgMy41NDMzXSwgWzQ4LjQzMjcsIDMuMzk1NF0sIFs0OC40NTU1LCAxLjkyMjddLCBbNDguODQ2NywgMy40NjgyXSwgWzQ4LjgxNjksIDMuNDg2NF0sIFs0OC44MDcxLCAzLjQwNzJdLCBbNDguNzM2NiwgMy40NDUzXSwgWzQ4LjcyODgsIDMuNDY2N10sIFs0OC42MTYsIDMuNTQ3NF0sIFs0OS4wNzA2LCAyLjY5MTJdLCBbNDguNDkwMywgMy40MzQ2XSwgWzQ5LjA3NTMsIDIuNzg3MV0sIFs0OS4wNjcsIDIuNzY4OV0sIFs0OS4xMDQ5LCAyLjYzMTddLCBbNDkuMDcyMSwgMi43MzA4XSwgWzQ5LjA4MTcsIDIuNTk2Nl0sIFs0OS4wODE0LCAyLjkzMzVdLCBbNDkuMDg2LCAyLjc4NzFdLCBbNDkuMDc3OSwgMi45MjI4XSwgWzQ5LjE1MTgsIDIuNDE1NF0sIFs0OS4xNzk3LCAyLjE2NDZdLCBbNDkuMTUxNiwgMi4yMjcxXSwgWzQ5LjExOSwgMi41Mzk2XSwgWzQ5LjExNzIsIDIuNTM5Nl0sIFs0OC41NjU2LCAxLjc2MzFdLCBbNDguMTI3MSwgMi41MTk2XSwgWzQ5LjE3NzEsIDIuMzI3Nl0sIFs0OS4xNzYyLCAyLjMyNzZdLCBbNDguNjQ3NSwgMy40OTU0XSwgWzQ4LjIwNzIsIDIuOTkxM10sIFs0OC45MjU1LCAxLjUxOTFdLCBbNDguOTIwMiwgMy4zNzE4XSwgWzQ4LjkxMDUsIDMuMzc2M10sIFs0OC42NDM1LCAzLjUyODddLCBbNDguOTk3NCwgMS40NzM4XSwgWzQ4LjE4MDIsIDIuNTA3OV0sIFs0OC43ODQsIDMuNDE4OV0sIFs0OC41NjAxLCAzLjQ3NDVdLCBbNDguNDg2NiwgMy4zOTgzXSwgWzQ5LjA5NDksIDMuMDU2OV0sIFs0OC4xNTYzLCAyLjQ3OTRdLCBbNDkuMTExMywgMS42MzMxXSwgWzQ5LjE0OTYsIDIuNDE4NF0sIFs0OC45MTcyLCAzLjM3MjFdLCBbNDguOTI4LCAzLjM2NzZdLCBbNDguODE1NSwgMy40NjA1XSwgWzQ4LjY3MTMsIDMuNDQzOF0sIFs0OC4zNjQzLCAzLjIwNDVdLCBbNDkuMDA4MywgMS40Nzc5XSwgWzQ5LjAxNCwgMS40Nzc5XSwgWzQ5LjA3NiwgMS41MTNdLCBbNDkuMDc0NSwgMS41MTc1XSwgWzQ5LjA3MDEsIDEuNTI4Ml0sIFs0OC4yNDEzLCAyLjQ4MDhdLCBbNDguMzEzNSwgMi4yNjg5XSwgWzQ5LjIwNDMsIDIuMDcyMl0sIFs0OS4xMjI5LCAyLjU1MDhdLCBbNDguNDQ4MSwgMy40MDYzXSwgWzQ4LjM2NjEsIDMuMjExMV0sIFs0OC44ODg5LCAzLjM4MzRdLCBbNDguNDU0NiwgMS45Mjc5XSwgWzQ4LjY3NDUsIDEuNjA2Ml0sIFs0OC40NjYsIDEuODAxNF0sIFs0OC4zMjY3LCAxLjk3OTddLCBbNDguNTE4LCAxLjc3ODVdLCBbNDguNjc1NSwgMS42MDQ3XSwgWzQ4LjM3NzIsIDEuOTc5N10sIFs0OC4zMzc5LCAyLjIxM10sIFs0OC42NzkxLCAxLjYwNjJdLCBbNDguNDQwNCwgMS44ODIxXSwgWzQ5LjIwOTcsIDEuNzIzXSwgWzQ4LjgyMjcsIDMuNDg1NF0sIFs0OC43ODQzLCAzLjQwODFdLCBbNDguNDgwMiwgMy4zODY5XSwgWzQ4LjM2OTUsIDMuMjI1M10sIFs0OC4xNTQ2LCAyLjg2NTldLCBbNDguMzMwNiwgMi4yMzQ3XSwgWzQ5LjEyNjksIDIuNDgxN10sIFs0OC44MTc2LCAzLjQ1OThdLCBbNDguNzk4MSwgMy40Mzk5XSwgWzQ4LjU2MzksIDMuNDcyXSwgWzQ5LjE5MSwgMi4wMzU5XSwgWzQ5LjA4LCAyLjkxNzRdLCBbNDkuMTg4MiwgMi4wMjcyXSwgWzQ4Ljc4NSwgMy40MjM4XSwgWzQ4Ljc4OTMsIDEuNTc2OV0sIFs0OC42Nzc5LCAxLjYwNTldLCBbNDguNjc4OCwgMS42MDU5XSwgWzQ5LjE4MTIsIDIuMTU5XSwgWzQ5LjE2NzIsIDIuMjg3XSwgWzQ4Ljg4MSwgMy4zODI0XSwgWzQ4LjY0NDUsIDMuNDU3MV0sIFs0OC4zOTM2LCAzLjM5NDZdLCBbNDguMzc1NywgMy4xNzk3XSwgWzQ5LjE1NDcsIDIuMzY2Ml0sIFs0OC4xNDEsIDIuNTY3M10sIFs0OC45MDk0LCAxLjU0MzNdLCBbNDguMzc1NCwgMy4xODAzXSwgWzQ4Ljg4MzIsIDMuMzgxNV0sIFs0OC44MDQxLCAzLjQxMzRdLCBbNDguNjYyMiwgMy40NDRdLCBbNDguNjAxNSwgMy41MDY1XSwgWzQ4Ljk1MzMsIDEuNTEwMl0sIFs0OC4zMzIzLCAyLjMyMzldLCBbNDguMzAwNSwgMi4wOTM4XSwgWzQ4Ljg3MzQsIDEuNTQ2OV0sIFs0OS4wNzgyLCAyLjk0MjldLCBbNDguODcyMywgMy40MDU2XSwgWzQ4LjYzOTYsIDMuNDgwM10sIFs0OC4zMTIxLCAyLjQwNzVdLCBbNDguMzI5LCAyLjMxMzFdLCBbNDguMzI4MSwgMi4xODgxXSwgWzQ4LjQyNTUsIDEuOTRdLCBbNDkuMDcwMywgMi44NTU3XSwgWzQ5LjA5ODYsIDIuNjU2XSwgWzQ5LjA3OCwgMi45MjU5XSwgWzQ4Ljg2MDEsIDMuNDQyOF0sIFs0OC42NDQ3LCAzLjQ4ODZdLCBbNDguNTc2OSwgMy40NzM0XSwgWzQ4Ljg0LCAxLjU5MjldLCBbNDkuMTk1OSwgMi4wOTA1XSwgWzQ4LjI5OTEsIDIuMTU2Nl0sIFs0OC42MDczLCAxLjcxOF0sIFs0OS4xNzY3LCAxLjgzNDddLCBbNDguOTA3MiwgMy4zNzU1XSwgWzQ4Ljg3NTksIDMuMzk5OV0sIFs0OC42NjIyLCAzLjQ0NTddLCBbNDguNjQ2MSwgMy41MDE0XSwgWzQ4LjI5MzgsIDIuNDIzMl0sIFs0OC4zMTIxLCAyLjM4OTZdLCBbNDguMzA4NywgMi4zNjk5XSwgWzQ5LjA5ODQsIDIuNjU1XSwgWzQ4LjY3MiwgMy40NDMzXSwgWzQ4LjUyOTYsIDMuNDMyNl0sIFs0OC4zMTUyLCAzLjAyNF0sIFs0OS4xNzU5LCAxLjk5OTNdLCBbNDguNjE2NSwgMS42NjM1XSwgWzQ5LjA5NjEsIDIuNjU4Nl0sIFs0OS4xMTc1LCAyLjU0NzNdLCBbNDguODgzMiwgMy4zODJdLCBbNDguODc0NCwgMy4zODA1XSwgWzQ4LjI3MiwgMy4wNDM2XSwgWzQ4LjE1NDIsIDIuODY1N10sIFs0OC4yMzQxLCAyLjUwNzRdLCBbNDguMzAyNywgMi40MTc1XSwgWzQ5LjE2NDksIDEuNjY0MV0sIFs0OS4wNzE2LCAyLjc4MDNdLCBbNDguODkwNywgMy4zNzY2XSwgWzQ4Ljc1ODQsIDMuNDI4NF0sIFs0OC40NTUsIDEuOTIyOV0sIFs0OC4zMjY0LCAyLjMyODJdLCBbNDkuMTU2NiwgMi4yNTk1XSwgWzQ4Ljk1OTksIDMuMjU2XSwgWzQ5LjE0OTgsIDIuMzk1MV0sIFs0OC44NjU3LCAzLjQxNjVdLCBbNDguNjM0LCAzLjQ1MzFdLCBbNDguNDI1MiwgMy4zOTIxXSwgWzQ4LjEyNTMsIDIuNjc0Nl0sIFs0OC40MzYzLCAzLjM5OV0sIFs0OC4zMTQyLCAyLjI2OV0sIFs0OS4xMDYzLCAyLjYzMThdLCBbNDkuMDgyNCwgMi41OTg0XSwgWzQ5LjAwMTEsIDEuNDgwNV0sIFs0OS4wMDE5LCAxLjQ4MDVdLCBbNDkuMDU2NywgMS40NzI4XSwgWzQ5LjA4NTQsIDEuNTA3OV0sIFs0OS4wNzk3LCAxLjUxNzFdLCBbNDkuMDcxOCwgMS41MzIzXSwgWzQ5LjA3MTgsIDEuNTM1M10sIFs0OS4wNzAzLCAxLjU1NTJdLCBbNDkuMDc2NCwgMS41NzA0XSwgWzQ5LjA5NTEsIDEuNjE3N10sIFs0OC4yMzg4LCAyLjUwMDVdLCBbNDguMzMyMiwgMi4yNDQ1XSwgWzQ4LjI5OTIsIDIuMTYzNl0sIFs0OC45NDY1LCAzLjI2MTRdLCBbNDguMzU1NywgMy4xMDldLCBbNDguMjU5MywgMy4wNDVdLCBbNDguMjg4MiwgMS45ODEzXSwgWzQ4LjY5LCAxLjYwMzNdLCBbNDguNDUzNCwgMS44Mzk2XSwgWzQ4LjYxOTksIDEuNjgyNV0sIFs0OC41NjI4LCAxLjc2NDldLCBbNDguNTkxNywgMS43MDY5XSwgWzQ4LjY0ODQsIDEuNjMyMl0sIFs0OC40MjE3LCAxLjk0MDJdLCBbNDguNTE2MiwgMS43NzcxXSwgWzQ4LjYxNjksIDEuNjkwMl0sIFs0OS4xMTA3LCAzLjA2NDldLCBbNDguMTQyLCAyLjg1MDJdLCBbNDguMzMzNCwgMi4xOTE2XSwgWzQ5LjE0OSwgMi4zNTY0XSwgWzQ4Ljk2MzgsIDMuMjU1MV0sIFs0OC43OTEsIDMuNDQ0MV0sIFs0OC4zNjM3LCAzLjIwMDNdLCBbNDguMTI1MiwgMi41MjIyXSwgWzQ4LjQwMiwgMS45NjkzXSwgWzQ4Ljg4MjgsIDMuMzgyMl0sIFs0OC42MTA0LCAzLjUzNDZdLCBbNDguOTExNCwgMy4zMzgxXSwgWzQ4Ljk2NSwgMS40OTI3XSwgWzQ4LjEzMTMsIDIuNTI2XSwgWzQ4LjI3ODgsIDIuNDE3N10sIFs0OS4xNzE2LCAyLjI5NDJdLCBbNDkuMTY1OCwgMi4yODY0XSwgWzQ4LjI4LCAyLjQxOF0sIFs0OC4zMTA3LCAyLjI4N10sIFs0OC43OTk5LCAxLjU4XSwgWzQ4LjgyODksIDEuNThdLCBbNDkuMTU1LCAyLjM2NjJdLCBbNDguMjA4MiwgMi45ODY5XSwgWzQ4LjE1NDQsIDIuNzUwNl0sIFs0OC4yNzAzLCAyLjQxOTddLCBbNDguMzEzNSwgMi4zOTddLCBbNDguMzE2OCwgMi4zNDJdLCBbNDguMjA1LCAyLjk5NDRdLCBbNDguMTU5NCwgMi45XSwgWzQ4LjI1NCwgMi40NjU1XSwgWzQ4LjMxMTMsIDIuMzgzMV0sIFs0OC4zMjE3LCAyLjMwNTRdLCBbNDkuMTA3MiwgMy4xMzJdLCBbNDkuMTA3MSwgMy4xMzgyXSwgWzQ5LjA4NTIsIDMuMDY1XSwgWzQ5LjA1MjYsIDMuMTldLCBbNDkuMDk5MywgMy4xNjI2XSwgWzQ5LjA5MTUsIDMuMTYxMV0sIFs0OC42MTMsIDEuNzA2NF0sIFs0OC44Mzg3LCAxLjU5ODFdLCBbNDkuMTY0MSwgMS44OTAxXSwgWzQ5LjA4OTYsIDIuOTY4Ml0sIFs0OS4xODkyLCAyLjA5NzddLCBbNDguMzY5MywgMy4yMzIxXSwgWzQ5LjE5NSwgMS43MzMzXSwgWzQ5LjEwNDEsIDMuMDZdLCBbNDguMTM3NCwgMi43OTk1XSwgWzQ4Ljk2OTMsIDEuNDk2Nl0sIFs0OS4yMjE5LCAxLjczNTFdLCBbNDkuMDg3NCwgMi45OTk0XSwgWzQ5LjE3MDYsIDEuOTM4OV0sIFs0OC4xNDg4LCAyLjQ3NDddLCBbNDguMjk0NSwgMi4wNjAxXSwgWzQ5LjEyMjIsIDEuNjQ2OF0sIFs0OC40Mjg1LCAxLjkzODVdLCBbNDkuMTczOCwgMS44MTI3XSwgWzQ5LjA4MzUsIDIuOV0sIFs0OS4xODIxLCAyLjMyMDZdLCBbNDguNzUzLCAzLjQxMDldLCBbNDkuMTE2NSwgMS42NDA3XSwgWzQ4LjI2MzksIDIuNDIxN10sIFs0OC4yODkzLCAyLjQyMzJdLCBbNDguMjkyOSwgMi40MjMyXSwgWzQ4LjYwNDgsIDMuNTAzOV0sIFs0OC40OTAxLCAzLjQyXSwgWzQ4LjQ4OTksIDMuNDE4NV0sIFs0OC4zNzIxLCAzLjMzMDFdLCBbNDguMzgxNiwgMy4yODI4XSwgWzQ4LjIxNCwgMy4wMDY5XSwgWzQ4LjkzOTQsIDMuMzEwMl0sIFs0OC44NjA1LCAzLjQzOTddLCBbNDguNjc0NCwgMy40NDU5XSwgWzQ4LjYzMTYsIDMuNTM1OF0sIFs0OS4xMDE1LCAyLjYyNzZdLCBbNDkuMTA3NCwgMi42MzUzXSwgWzQ5LjA5MzIsIDIuNzk5OV0sIFs0OS4wOTE5LCAyLjYwOTRdLCBbNDkuMDg3NSwgMi45NzA3XSwgWzQ5LjA4NzQsIDIuODE5OF0sIFs0OS4wODczLCAzLjA0MDldLCBbNDguMzIzMywgMS45NzQ1XSwgWzQ5LjE5NDYsIDEuNzM3NF0sIFs0OS4xNjQ4LCAxLjg4ODNdLCBbNDkuMTQ5NCwgMi40MjIzXSwgWzQ4Ljg4ODcsIDMuMzgwNV0sIFs0OC44MTczLCAzLjQ3NTFdLCBbNDguNzAyNywgMS41NzcxXSwgWzQ5LjE3NjQsIDEuOTkxOF0sIFs0OS4xMDQzLCAyLjYzNTRdLCBbNDguOTI3NCwgMy4zNjc0XSwgWzQ4LjM5MDMsIDMuNDExNV0sIFs0OC42MTM0LCAxLjY5NThdLCBbNDguNTQ0OCwgMS43ODQyXSwgWzQ4LjE0NCwgMi43OTc2XSwgWzQ4LjQ1NzUsIDEuOTIzXSwgWzQ4LjYxNDgsIDEuNjc0NV0sIFs0OS4xNzEzLCAxLjk0NTFdLCBbNDguMTU5OSwgMi43NDFdLCBbNDguNTc2OCwgMS43MTRdLCBbNDkuMTczOSwgMi4yOTZdLCBbNDguMzcxMSwgMy4yNjExXSwgWzQ4LjQ1NjYsIDEuOTI5NF0sIFs0OC4yNTEyLCAyLjQ3NjRdLCBbNDkuMTc0MywgMi4yMDVdLCBbNDguNzE4MywgMy40NjgyXSwgWzQ4LjYzMiwgMy41MzUyXSwgWzQ4LjM5NjcsIDMuMzc1MV0sIFs0OC4zNzMxLCAzLjMzMV0sIFs0OS4wNTI4LCAxLjQ0ODddLCBbNDkuMDY4NSwgMS41MjM0XSwgWzQ5LjA3MzMsIDEuNTY5Ml0sIFs0OS4wOCwgMS41ODI5XSwgWzQ5LjEyMTcsIDEuNjQ2OV0sIFs0OS4xNzMxLCAxLjY2ODNdLCBbNDguMzIyLCAyLjE4MzVdLCBbNDkuMTgzNCwgMS42NzA5XSwgWzQ4Ljg2NDEsIDMuNDEzOF0sIFs0OC44Njc3LCAzLjQyM10sIFs0OC44NTc1LCAzLjQ1MDRdLCBbNDguNTM5NSwgMS43ODIxXSwgWzQ4LjI5NTYsIDEuOTY2Nl0sIFs0OC40Nzg2LCAxLjc5NDNdLCBbNDguNDQwMywgMS45NDIyXSwgWzQ4LjM2NzIsIDMuMTI4OV0sIFs0OC4zNjgsIDMuMTI1N10sIFs0OC4yOTYsIDEuOTgwM10sIFs0OC4zMTY2LCAyLjM0ODddLCBbNDguMjU0LCAyLjQ2NzddLCBbNDguMzc4MywgMS45ODAzXSwgWzQ5LjE2NSwgMS44MzQ2XSwgWzQ5LjA4MDQsIDIuOTE1N10sIFs0OC40OTY0LCAzLjQzNTFdLCBbNDguMjA3MSwgMy4wMDIxXSwgWzQ5LjE1NjEsIDEuNjYxOV0sIFs0OS4wODgxLCAyLjYwNjFdLCBbNDkuMDYwOSwgMi43NTRdLCBbNDguODQxOSwgMy40NTU0XSwgWzQ4LjQ1ODMsIDMuNDAwNl0sIFs0OC4zNzcsIDMuMjk1M10sIFs0OS4xNzkxLCAyLjMyNDJdLCBbNDguOTk0NiwgMS40NzEzXSwgWzQ5LjE0MTEsIDIuNDU4Ml0sIFs0OC45MzAzLCAxLjUwOF0sIFs0OS4yMTYxLCAxLjY4MjVdLCBbNDguNjg2MiwgMy40NjU4XSwgWzQ4LjQ2MTcsIDMuMzk1OF0sIFs0OC4zNjg1LCAzLjE5NjFdLCBbNDguNzA2LCAzLjQ2NDldLCBbNDguNjYyNCwgMy40NDJdLCBbNDguMzU3NiwgMy4wODYxXSwgWzQ5LjIzOTEsIDEuNzEwMV0sIFs0OS4wNTk3LCAzLjE4MTVdLCBbNDguMjE0NCwgMi41MTQxXSwgWzQ4LjMzMDYsIDIuMjQ1OV0sIFs0OC40OTc1LCAxLjc4ODldLCBbNDkuMjI2MywgMS43MzQ4XSwgWzQ5LjE0OTcsIDIuNDE4XSwgWzQ4LjQ1ODksIDMuNDAwOF0sIFs0OC4zNjY0LCAzLjI1NDRdLCBbNDguMzUzNiwgMy4xMDhdLCBbNDkuMDgzOCwgMi42ODA5XSwgWzQ4Ljk0NDQsIDMuMjYwNF0sIFs0OC44OTIyLCAzLjM3MTddLCBbNDguNjYsIDMuNDQ3OV0sIFs0OC42NDc0LCAzLjQ5MjJdLCBbNDguNTU3MywgMy40NzddLCBbNDguMzY2NiwgMy4xMTcyXSwgWzQ4LjE3NDUsIDIuNTE1NV0sIFs0OC4yODYzLCAyLjAwMzNdLCBbNDguNjUxNywgMS42MjI1XSwgWzQ5LjExODQsIDEuNjQ0Nl0sIFs0OC45MjQxLCAzLjMxMjhdLCBbNDguNzUzMSwgMy40MTE5XSwgWzQ4LjM3NzMsIDMuMjkwMV0sIFs0OC40NTM0LCAxLjkyMzNdLCBbNDguNDQ5MywgMS44NDU2XSwgWzQ4LjE2NDksIDIuNzY3Nl0sIFs0OC4zMjg4LCAyLjMxMTddLCBbNDkuMTY1NSwgMS44MzQyXSwgWzQ5LjA4MjksIDIuNzY5MV0sIFs0OC45ODg0LCAzLjIyNDNdLCBbNDguODkzNSwgMy4zNjldLCBbNDkuMTk3MywgMS42NzUyXSwgWzQ4LjE0NCwgMi43NDc2XSwgWzQ4LjEyMDcsIDIuNjY1Ml0sIFs0OC42NzUzLCAxLjYwNDZdLCBbNDkuMTc1OCwgMi4yOTk0XSwgWzQ5LjE1LCAyLjM1NDJdLCBbNDguOTE1NSwgMy4zNTQ0XSwgWzQ5LjE5NTIsIDEuNzI5MV0sIFs0OC4zMjksIDIuMTg4N10sIFs0OC4yMzk0LCAyLjQ4OV0sIFs0OC4yOTgyLCAyLjEyNjJdLCBbNDguNDg2LCAxLjc5NDJdLCBbNDkuMDczMiwgMi43ODMxXSwgWzQ4LjcxNjYsIDEuNTk1XSwgWzQ4Ljg0MSwgMS41OTM1XSwgWzQ5LjE4MTYsIDEuOTgyXSwgWzQ4LjEzMTYsIDIuNDQ0Nl0sIFs0OC4xNDgyLCAyLjQ2NzVdLCBbNDguOTEwMywgMy4zMzM1XSwgWzQ4Ljg3NzIsIDEuNTUyMl0sIFs0OC40MTUyLCAzLjQxNzFdLCBbNDguNzUzOSwgMy40MTQxXSwgWzQ4LjUyODQsIDMuNDRdLCBbNDguMTIzOSwgMi42NzJdLCBbNDguMTMyMywgMi41ODA2XSwgWzQ4LjMzMywgMi4zMjc2XSwgWzQ5LjE4NywgMi4xMTFdLCBbNDkuMTYwMywgMi4yODYzXSwgWzQ4Ljg3NTksIDMuNDA1NV0sIFs0OC4zNjgzLCAzLjE0MzNdLCBbNDguNDg2LCAzLjQwNF0sIFs0OS4xODE4LCAyLjMyMTRdLCBbNDkuMDY1NCwgMy4xODAxXSwgWzQ4LjgwNTMsIDEuNTgyXSwgWzQ4Ljg5MTYsIDMuMzc0OF0sIFs0OC45NzQ5LCAzLjI0ODNdLCBbNDguODAzLCAzLjQzNDNdLCBbNDguMzc3LCAzLjM2MjZdLCBbNDguNDE1NSwgMy40MTQ1XSwgWzQ5LjA4NTEsIDMuMDUxXSwgWzQ4LjI4NDQsIDIuMDQxM10sIFs0OS4wNjA0LCAyLjczNV0sIFs0OC4zOTg3LCAzLjM3NTRdLCBbNDguMzU5NCwgMy4wNDkyXSwgWzQ5LjEwMjQsIDEuNjI1MV0sIFs0OC4zMTYzLCAyLjI0OTNdLCBbNDguOTkzNCwgMS40NjkxXSwgWzQ5LjE1NDksIDIuMzY2Nl0sIFs0OS4xNDk4LCAyLjQxNTRdLCBbNDguMzY2NiwgMy4yNDg2XSwgWzQ5LjA3MTEsIDEuNTM0NF0sIFs0OS4wODI0LCAxLjU5NTRdLCBbNDkuMTI1LCAxLjY0ODddLCBbNDguNjk0OCwgMS41OTQ2XSwgWzQ5LjE4MDEsIDEuNjcxNl0sIFs0OS4xODEzLCAxLjY3MTZdLCBbNDkuMTk1MywgMS42NzMxXSwgWzQ5LjEwOTEsIDMuMTJdLCBbNDkuMjA3NywgMS42NzMxXSwgWzQ4LjMyMSwgMi4yNDE1XSwgWzQ5LjE3ODIsIDIuMjE1Nl0sIFs0OC43ODQ3LCAzLjQyNDVdLCBbNDguNjMzNiwgMy41MTkxXSwgWzQ4LjYxMjEsIDMuNTM4OF0sIFs0OC4zMzksIDEuOTcwNV0sIFs0OC40NDE2LCAxLjkzMzldLCBbNDguNDc3NSwgMS43OTUyXSwgWzQ4LjcwNSwgMS41ODQ4XSwgWzQ4LjMxNTksIDEuOTczNV0sIFs0OC42MjA4LCAxLjY1OF0sIFs0OC42MTMzLCAxLjcwODNdLCBbNDguMjg2LCAyLjAzOTJdLCBbNDguNjI3MiwgMS42NThdLCBbNDguNTUzMywgMS43ODQ1XSwgWzQ5LjE4MTgsIDEuOTgwN10sIFs0OS4wNzQxLCAyLjg3NjFdLCBbNDkuMTQ5NiwgMi40MjA0XSwgWzQ4Ljc3OTksIDMuNDI3NF0sIFs0OC43ODMsIDMuNDI0NF0sIFs0OC43MzE1LCAxLjYxMThdLCBbNDguOTUxNywgMS41MDA1XSwgWzQ4LjMxMjgsIDIuMzg4Ml0sIFs0OC40NzI2LCAxLjgwMzJdLCBbNDkuMDcxOCwgMi43MzExXSwgWzQ5LjA3LCAyLjg1NjFdLCBbNDkuMiwgMi4wNTg4XSwgWzQ4LjkyNTMsIDEuNTE4Nl0sIFs0OS4yMjM0LCAxLjc0MDVdLCBbNDkuMTkzNCwgMi4xMjgxXSwgWzQ5LjE3MzEsIDIuMTg5MV0sIFs0OC40ODAzLCAzLjM4ODFdLCBbNDguNDU5MSwgMy40MDAzXSwgWzQ5LjIwNjEsIDEuNjcyOV0sIFs0OC4xMzczLCAyLjY0NDddLCBbNDguMTU2NywgMi40Nzg0XSwgWzQ4LjIxNDQsIDIuNTE2NV0sIFs0OC4zMTYxLCAyLjM0NTldLCBbNDkuMTg5LCAyLjEwOTZdLCBbNDguMjYxMSwgMi40MjI3XSwgWzQ5LjE1NiwgMi4zNjc3XSwgWzQ5LjExNTEsIDIuNTUzN10sIFs0OC4yMDU5LCAyLjk5Ml0sIFs0OC4yMDksIDIuOTg5XSwgWzQ4LjIwMDcsIDIuNTE5NF0sIFs0OC4zMSwgMi4zNTYzXSwgWzQ4LjE5NDEsIDIuNTE3OV0sIFs0OC4yMDEzLCAyLjUxOTRdLCBbNDkuMTE2LCAzLjA3MDFdLCBbNDguMzE5NSwgMi40MDM2XSwgWzQ4LjMxMjYsIDIuMjgzMV0sIFs0OC4zMjc5LCAyLjIzNDNdLCBbNDkuMTA2MSwgMy4xMjY2XSwgWzQ5LjA1MjYsIDMuMTg5MV0sIFs0OS4xMDIzLCAzLjA1OTRdLCBbNDkuMTA2OSwgMy4xMzExXSwgWzQ5LjEwMjcsIDMuMTQzM10sIFs0OS4wOTk1LCAzLjE1ODVdLCBbNDguMTg4OCwgMi45NDgzXSwgWzQ4LjcyNzIsIDEuNjA3M10sIFs0OS4xODA3LCAxLjk3MDhdLCBbNDkuMTAxOCwgMi42MzU4XSwgWzQ5LjE1MzQsIDIuMjQ1Nl0sIFs0OS4xMTc2LCAyLjUwMzNdLCBbNDguMzU2OCwgMS45NzUxXSwgWzQ4LjQwNDIsIDEuOTM1NV0sIFs0OC45MTc2LCAzLjM3MTddLCBbNDguMTU1NSwgMi44NjY3XSwgWzQ4LjI2NjEsIDIuNDJdLCBbNDguODc2LCAxLjU0ODRdLCBbNDkuMTgxOSwgMS42NzExXSwgWzQ5LjE4NDQsIDIuMTUwMV0sIFs0OS4xMzg4LCAyLjQ1MzZdLCBbNDguOTgxMywgMy4yMzAzXSwgWzQ4LjM4OTgsIDEuOTc0Ml0sIFs0OC44ODc3LCAxLjU2MTFdLCBbNDkuMTExLCAxLjYzMzFdLCBbNDkuMDY0OCwgMi43MDAzXSwgWzQ5LjE3MTYsIDIuMjI5Ml0sIFs0OS4xMDA5LCAyLjUyNjVdLCBbNDguMTM0MywgMi44MzQ5XSwgWzQ4LjEyNSwgMi42ODg3XSwgWzQ4LjEzNzEsIDIuNTMzMV0sIFs0OC4yMDYzLCAyLjUyMDldLCBbNDguNjE3MSwgMS42Njc3XSwgWzQ5LjA4NzcsIDIuOTk2NF0sIFs0OC4zOTA3LCAzLjQwNDZdLCBbNDguMTU2NiwgMi44NzE0XSwgWzQ4LjczNiwgMy40NTE4XSwgWzQ4LjQzNDgsIDMuMzk3XSwgWzQ4LjM3MjUsIDMuMTM3OF0sIFs0OC44ODg4LCAzLjM4MzFdLCBbNDguODg2MywgMy4zODE2XSwgWzQ4Ljg2NTUsIDMuNDE4Ml0sIFs0OC44Mzc5LCAzLjQ2MjVdLCBbNDguODA5LCAzLjQwNDVdLCBbNDguNzMyLCAzLjQ2N10sIFs0OC42NzQ3LCAzLjQ0NzNdLCBbNDkuMDg0OSwgMi42MDE2XSwgWzQ5LjA3NDIsIDIuNjk0NV0sIFs0OS4wNjg1LCAyLjY5XSwgWzQ5LjA4NDksIDIuODQzOV0sIFs0OS4wODUzLCAyLjk5MzNdLCBbNDkuMDcxMywgMi45ODI2XSwgWzQ4LjEzMjEsIDIuNTc5Ml0sIFs0OS4xMDcyLCAyLjYzNTddLCBbNDkuMDY2OSwgMi42OTA1XSwgWzQ5LjA5NCwgMi42MTUyXSwgWzQ4Ljg3MSwgMy40MDM0XSwgWzQ5LjE5MjEsIDIuMDM4MV0sIFs0OS4xMTA4LCAzLjA5MThdLCBbNDguNjEzNCwgMy41NDA3XSwgWzQ4LjYxMzIsIDEuNzA3NV0sIFs0OC44ODA1LCAzLjM4MjZdLCBbNDguNzI5MiwgMS42MTA0XSwgWzQ5LjAzOCwgMy4xNzg2XSwgWzQ4LjE2NDcsIDIuODAwNl0sIFs0OC4xNjQxLCAyLjc2MjVdLCBbNDguMzE0OSwgMi4zOTUyXSwgWzQ4LjMwNDEsIDIuMDk5NF0sIFs0OC4zNTU4LCAxLjk3MzNdLCBbNDkuMDc4NCwgMi43Nzk0XSwgWzQ5LjE1NjksIDIuMjcwMl0sIFs0OS4yMzc4LCAxLjcxMjldLCBbNDguMTk0OSwgMi41MjMxXSwgWzQ4Ljg0OTEsIDEuNTc4M10sIFs0OS4xNzM2LCAxLjkzNDNdLCBbNDkuMTU0NywgMi4yMTY2XSwgWzQ4LjQ5MzMsIDMuNDMzNF0sIFs0OC40OTc1LCAzLjQzNDldLCBbNDguMjQ5OCwgMy4wMzRdLCBbNDguOTE2OSwgMy4zNTddLCBbNDguMTUxMiwgMi44NjIxXSwgWzQ4LjEzMTUsIDIuNDQ0M10sIFs0OC4zMDExLCAyLjA5NTJdLCBbNDguOTAzOSwgMS41NDA4XSwgWzQ5LjEwMDQsIDIuNjI0M10sIFs0OS4xMjQ0LCAyLjQ5MTZdLCBbNDguNDgxNSwgMy4zOTJdLCBbNDguMjkyNSwgMy4wMjE1XSwgWzQ5LjAxODUsIDEuNDcyMl0sIFs0OS4wNDg0LCAxLjQ1MDhdLCBbNDguODgyMSwgMS41NTk1XSwgWzQ5LjA4NDMsIDEuNTEwM10sIFs0OS4wNzE4LCAxLjUzNjJdLCBbNDkuMDc4NCwgMS41NzU4XSwgWzQ5LjE1MjUsIDEuNjYyN10sIFs0OS4xOTQ1LCAxLjY3MTldLCBbNDguMjU0OCwgMi40MzM1XSwgWzQ4LjMzNjMsIDIuMjIzMV0sIFs0OC4zODc5LCAxLjk3Ml0sIFs0OC41MDAyLCAxLjc4M10sIFs0OS4xMjM0LCAxLjY0NjVdLCBbNDguMzI3NCwgMy4wMzczXSwgWzQ4LjY4ODQsIDEuNjExMl0sIFs0OC40NDEzLCAxLjkzNzRdLCBbNDguNjM4NCwgMS42NTA4XSwgWzQ4LjYzODYsIDEuNjQ5M10sIFs0OC42MjA0LCAxLjY4NTldLCBbNDguNDc1MSwgMS43OTg3XSwgWzQ4LjQ1NTksIDEuODM5OF0sIFs0OC42MTI0LCAxLjY4NTldLCBbNDguMjkzMywgMS45NzI1XSwgWzQ4LjI5NTcsIDEuOTY0OF0sIFs0OC4yMjQ0LCAyLjUxMzNdLCBbNDguNzk1NSwgMS41Nzc1XSwgWzQ5LjEzODYsIDIuNDUzOF0sIFs0OC45MTA0LCAzLjMzNzVdLCBbNDguNzgwMywgMy40MzE5XSwgWzQ4Ljg4NDMsIDMuMzgxOV0sIFs0OC4zMTM5LCAxLjk3OTFdLCBbNDkuMDk5NCwgMi42MjQ1XSwgWzQ4Ljk1NDYsIDEuNTA0OV0sIFs0OS4wNzkzLCAzLjE2MTNdLCBbNDguMTIwOCwgMi42Njc3XSwgWzQ4LjUwMywgMS43ODI0XSwgWzQ4Ljc1OTMsIDMuMzk1OF0sIFs0OC4zNzYyLCAzLjE3NzddLCBbNDguOTA4NywgMy4zMzAzXSwgWzQ4LjEzNDcsIDIuODM2N10sIFs0OC4yNSwgMi40NTI1XSwgWzQ4LjMyOSwgMi4zMjldLCBbNDkuMTc5LCAyLjEzN10sIFs0OS4xODQ4LCAyLjMwNjNdLCBbNDguNzU1MiwgMy40MjM4XSwgWzQ5LjE4MjksIDIuMzJdLCBbNDkuMTgzOCwgMS45NzM4XSwgWzQ4LjE0OTksIDIuNzk5Ml0sIFs0OC4yOTg1LCAyLjI0NTldLCBbNDguNDI1NCwgMS45Mzk4XSwgWzQ4LjYxNDMsIDEuNzEyN10sIFs0OC45NTIxLCAxLjUwMDhdLCBbNDguODE3MSwgMy40NjAxXSwgWzQ4LjIwNjgsIDMuMDA0NF0sIFs0OC4yOTc2LCAyLjA5MDJdLCBbNDkuMDk2MywgMS42MTg3XSwgWzQ5LjA5ODUsIDIuNTU4MV0sIFs0OC44NjA0LCAzLjQ0MV0sIFs0OC40MzkyLCAxLjg5NTldLCBbNDguNDgzMywgMS43OTUzXSwgWzQ5LjE3MTQsIDEuOTE2M10sIFs0OC4xNTk1LCAyLjkwMDFdLCBbNDkuMTczNywgMS45MzM0XSwgWzQ5LjIyODEsIDEuNzMyMV0sIFs0OC44NDA4LCAzLjQ2MDZdLCBbNDkuMDk0NywgMy4xNjI3XSwgWzQ4LjMwMDIsIDIuMjUzNl0sIFs0OS4xMjUsIDEuNjQ4MV0sIFs0OS4xMzUsIDEuNjUyNl0sIFs0OS4xNzg5LCAyLjE0MDhdLCBbNDguODc5OCwgMS41NTQ4XSwgWzQ4Ljk3NDgsIDEuNDcwOV0sIFs0OS4xNzE0LCAxLjg3N10sIFs0OC4xMjA4LCAyLjY2ODhdLCBbNDkuMTQ3MywgMi4zNTkzXSwgWzQ4Ljg0MTEsIDMuNDU5NF0sIFs0OC42NDg0LCAzLjQ1NzldLCBbNDguNjQyMiwgMy40NTY0XSwgWzQ4LjYxNywgMy41NTg1XSwgWzQ4LjYxNTcsIDEuNjcyN10sIFs0OS4xNzMxLCAxLjk1OTFdLCBbNDguMjcwNywgMy4wNDU1XSwgWzQ5LjExMTMsIDMuMDY3MV0sIFs0OS4xMTIyLCAzLjA2NzFdLCBbNDguMzM1MiwgMi4yMTU4XSwgWzQ4LjYxNDksIDEuNjczNl0sIFs0OC42NDUsIDEuNjM4NV0sIFs0OS4yMTU5LCAxLjczNTNdLCBbNDkuMTgwNCwgMi4yMTldLCBbNDguODAzNywgMy40MzcxXSwgWzQ4LjQ4NiwgMy40MDJdLCBbNDguNDc5MSwgMy4zODM4XSwgWzQ4LjMzMzksIDMuMDM5Ml0sIFs0OS4xMzY2LCAyLjQ2MTNdLCBbNDkuMDQxLCAzLjE4MjhdLCBbNDguMjAwNSwgMi41MjI5XSwgWzQ4LjkyLCAzLjM3MTZdLCBbNDguMjc2NywgMi40MTkzXSwgWzQ5LjE3NDIsIDIuMjAxMl0sIFs0OS4xMDk1LCAyLjUzMjFdLCBbNDguODc2LCAzLjQwMTldLCBbNDguMzc3MiwgMy4xNzQ4XSwgWzQ4LjI3NzMsIDMuMDI1NF0sIFs0OS4wOTQyLCAyLjU3MzJdLCBbNDkuMDkzMywgMi41NzMyXSwgWzQ4LjQ2NSwgMy4zOTQ2XSwgWzQ5LjExMTUsIDMuMDY3NF0sIFs0OC4xMjkzLCAyLjQ3N10sIFs0OC4xMjM1LCAyLjQ1MTFdLCBbNDguMzA2NywgMi4xMDM1XSwgWzQ4LjQxNjIsIDEuOTMwMV0sIFs0OC44MDU5LCAxLjU4MV0sIFs0OS4yMzAyLCAxLjcwMzddLCBbNDkuMTI4MywgMi40NzU1XSwgWzQ4LjUyODgsIDMuNDM0NF0sIFs0OC4zNzc2LCAzLjE3MjJdLCBbNDguMjg3NywgMi4wMjAyXSwgWzQ4LjIwMiwgMi45NzE0XSwgWzQ4LjE5NDQsIDIuNTIwMl0sIFs0OC4zMjc4LCAyLjIzMzZdLCBbNDguMzA0NCwgMi4xNTU5XSwgWzQ4Ljg1NSwgMS41ODE2XSwgWzQ5LjE5MjQsIDIuMDM4NF0sIFs0OC4yOTI5LCAzLjAyMTJdLCBbNDguNDg2LCAzLjQwMzddLCBbNDguNzU4NSwgMy4zOTYyXSwgWzQ4LjY1NzUsIDMuNDUxXSwgWzQ4LjUwMzQsIDMuNDI5Nl0sIFs0OS4wMTI0LCAzLjE3M10sIFs0OC4xODI5LCAyLjkzNzddLCBbNDguMTQwNywgMi41NTJdLCBbNDguNjUyMywgMS42MTY0XSwgWzQ5LjIwOTgsIDIuMDgwOV0sIFs0OS4xNzk2LCAyLjMyMzRdLCBbNDguNjQ1NSwgMy41MDQ5XSwgWzQ5LjE2MTgsIDIuMzQ2M10sIFs0OC4xMzE1LCAyLjgwMTFdLCBbNDkuMjAxMywgMi4wOTIyXSwgWzQ5LjE5NzcsIDIuMDkyMl0sIFs0OC42MzYzLCAzLjQ2ODJdLCBbNDkuMDE2NSwgMS40NzYzXSwgWzQ5LjA1MzcsIDEuNDc2M10sIFs0OS4wODA5LCAxLjUxNTldLCBbNDkuMDczNCwgMS41Mzg4XSwgWzQ5LjA3ODMsIDEuNTc4NF0sIFs0OS4wODI1LCAxLjYwNDNdLCBbNDkuMTM5OCwgMS42NTMxXSwgWzQ5LjE0NDUsIDEuNjUzMV0sIFs0OS4xNDYzLCAxLjY1NDZdLCBbNDguMTMzLCAyLjcxODZdLCBbNDguMTI0NywgMi42NzI4XSwgWzQ5LjA3MTYsIDEuNTJdLCBbNDkuMTU3NiwgMi4yNjEyXSwgWzQ4Ljg2MzcsIDMuNDA2M10sIFs0OC42NDkxLCAzLjQ1ODFdLCBbNDguNDI0MiwgMy4zOTQxXSwgWzQ4LjYxNDQsIDEuNzE0OV0sIFs0OC40NDU1LCAxLjkxMTZdLCBbNDguMzExNiwgMS45NjQ5XSwgWzQ4LjMzMzMsIDEuOTc3MV0sIFs0OC40MjY0LCAxLjkzNzVdLCBbNDguMjk1NywgMS45NjQ5XSwgWzQ4LjMxNTIsIDEuOTc0MV0sIFs0OC42OTUxLCAxLjU4NjldLCBbNDguNzQ4MSwgMS42MjY1XSwgWzQ4Ljk0MTEsIDEuNTAxNV0sIFs0OS4wOTI4LCAxLjYyMjddLCBbNDkuMDcxMiwgMi44NzE2XSwgWzQ4Ljg2MzcsIDMuNDA5Ml0sIFs0OC42MDU2LCAzLjUwODFdLCBbNDguMjY2NywgMi40MjAxXSwgWzQ4LjMyNzMsIDIuMjQ0OF0sIFs0OS4wOTg1LCAyLjY1NjRdLCBbNDkuMDc4NywgMi45Mjc4XSwgWzQ4Ljg2MDIsIDMuNDMyNV0sIFs0OC4zNzAzLCAzLjIzMjhdLCBbNDkuMTg4NCwgMi4xMjEzXSwgWzQ5LjA5NTIsIDIuNTY1XSwgWzQ5LjExMjksIDMuMDY4NF0sIFs0OC4xNDM1LCAyLjg1MzddLCBbNDguNzkzNSwgMy40NDE2XSwgWzQ4LjMxMzEsIDIuMjY1M10sIFs0OC4zMDA1LCAyLjI1MzFdLCBbNDguNzM1OSwgMS42MTc4XSwgWzQ4Ljg5MiwgMy4zNzI5XSwgWzQ4Ljc1NjQsIDMuNDMwOV0sIFs0OC42MzIyLCAzLjUzNDVdLCBbNDkuMTUyNiwgMi4zNjIyXSwgWzQ5LjA4NjgsIDMuMDY2XSwgWzQ5LjA1MjksIDMuMTgxOF0sIFs0OC4yOTAzLCAyLjA1MTZdLCBbNDkuMTg5OSwgMi4xMDY2XSwgWzQ5LjE2NjEsIDIuMTcwNl0sIFs0OC44NzA5LCAzLjM5MTddLCBbNDguNzgwOCwgMy40MzNdLCBbNDguNDgyNSwgMy4zOTMyXSwgWzQ4LjQxNzcsIDMuNDAyNF0sIFs0OC45MjI2LCAxLjUxMjldLCBbNDkuMDM5NCwgMy4xODE1XSwgWzQ5LjE3MzMsIDEuODE0XSwgWzQ4LjIwNjUsIDIuOTk5NF0sIFs0OC4xMjcxLCAyLjcwOThdLCBbNDguMjg1OSwgMi40MjE3XSwgWzQ4LjMxNCwgMi4xNzAyXSwgWzQ4LjEzMSwgMi44MDc0XSwgWzQ4LjE2MDgsIDIuNzU3MV0sIFs0OC4xMzkzLCAyLjcyOTddLCBbNDguMzE3MiwgMi4zNDU1XSwgWzQ4LjMxOTgsIDIuMzA0NF0sIFs0OC4zMDY5LCAyLjI2MTZdLCBbNDkuMDg2MywgMy4wNTQ2XSwgWzQ5LjA5OTYsIDMuMTU2OV0sIFs0OS4wNDQ5LCAzLjE4MjhdLCBbNDkuMDEyOCwgMy4xNzgxXSwgWzQ5LjAzMTUsIDMuMTc2Nl0sIFs0OS4wMjA3LCAzLjE2NTldLCBbNDkuMTE3MSwgMy4wNjkzXSwgWzQ5LjEwNDcsIDMuMDYwM10sIFs0OC43NjAzLCAxLjYwODhdLCBbNDguOTg2OSwgMS40NjA5XSwgWzQ5LjA3NzksIDIuOTM3Nl0sIFs0OC42MzI4LCAzLjUzMjRdLCBbNDguNDgzOCwgMy4zOTk3XSwgWzQ4Ljk5MTgsIDEuNDcwNl0sIFs0OS4wOTIsIDMuMDZdLCBbNDkuMjExLCAxLjczMzddLCBbNDguODcyOCwgMy4zODEyXSwgWzQ5LjA5OTgsIDMuMTU1Ml0sIFs0OS4wMTAzLCAzLjE4NTZdLCBbNDguMTUzMiwgMi43NTM2XSwgWzQ4LjI1NTUsIDIuNDMwNF0sIFs0OC45NTIzLCAxLjUwNTVdLCBbNDkuMDcwNywgMi43NzVdLCBbNDguNzU0OSwgMy40MDE3XSwgWzQ4LjY1NTcsIDMuNDU2NV0sIFs0OC4xNDUzLCAyLjQ2NDZdLCBbNDguMzEyNSwgMi40MDY2XSwgWzQ5LjEzOTksIDEuNjUzMl0sIFs0OS4xODQ5LCAxLjgwMjZdLCBbNDguNjk1MywgMy40NzE2XSwgWzQ4LjYzMzEsIDMuNTMxMV0sIFs0OC41ODA0LCAzLjQ4NTNdLCBbNDguNzYyNCwgMS41ODI4XSwgWzQ4Ljg5ODUsIDMuMzddLCBbNDguODAzNiwgMy40MTI4XSwgWzQ4LjQ4MDQsIDMuMzg4NF0sIFs0OC40NTk1LCAzLjQwMDZdLCBbNDguMzcyNiwgMy4xMzk5XSwgWzQ4LjM1NzcsIDMuMDY2N10sIFs0OC45MDUyLCAzLjM3MTVdLCBbNDguOTE1NCwgMy4zNDQxXSwgWzQ4LjkxNjgsIDMuMzQ3MV0sIFs0OC45MDgxLCAzLjM3NjJdLCBbNDkuMDc4MywgMi45MjU0XSwgWzQ5LjA4NzcsIDIuOTU4OF0sIFs0OS4wOTI4LCAyLjc5ODddLCBbNDkuMDk1MSwgMi42MjE5XSwgWzQ5LjA5MSwgMi45NjVdLCBbNDkuMDk2MywgMi44MDY0XSwgWzQ5LjEwMTksIDMuMDU2M10sIFs0OC4xNzM2LCAyLjkzNDVdLCBbNDkuMDgzNSwgMi41ODA3XSwgWzQ4LjM5NzIsIDMuMzg4Ml0sIFs0OC4zNzcxLCAzLjM1NjFdLCBbNDguMzY5LCAxLjk3OF0sIFs0OC42NDE3LCAxLjY0MzVdLCBbNDkuMTc0NiwgMS43NTU1XSwgWzQ5LjA3OTgsIDIuOTE3NV0sIFs0OS4wODA2LCAyLjkzMTJdLCBbNDguODc2OSwgMy4zODExXSwgWzQ5LjEwNDUsIDIuNDk5OV0sIFs0OC4zNDEzLCAxLjk2ODddLCBbNDkuMjE0OCwgMS42ODExXSwgWzQ4LjMzMTksIDIuMjM4MV0sIFs0OC4zMjI4LCAyLjE4MThdLCBbNDkuMTUwNCwgMi4zNTQxXSwgWzQ4LjgxMzYsIDMuNDgzMV0sIFs0OC41NTA1LCAzLjQ4MTZdLCBbNDguMzA5MywgMi4zNjldLCBbNDguNzUyNSwgMS42MTg0XSwgWzQ4LjE0MjMsIDIuNzQxNl0sIFs0OS4xNzA4LCAxLjg1MV0sIFs0OS4wODg1LCAyLjU3ODVdLCBbNDguODczMywgMy40MDU3XSwgWzQ4LjgwOTMsIDMuNDA0Ml0sIFs0OS4wNTk2LCAxLjQ2NzRdLCBbNDkuMDczOCwgMS41NDIxXSwgWzQ4Ljk5MjksIDEuNDY5Nl0sIFs0OS4wODUsIDEuNjA0Nl0sIFs0OS4xMDMxLCAxLjYyNzVdLCBbNDkuMTE2NCwgMS42NDEyXSwgWzQ5LjEzNzUsIDEuNjU0OV0sIFs0OS4xNjgyLCAxLjY2ODZdLCBbNDkuMTY1NywgMS44OTQ3XSwgWzQ4LjUzMzUsIDMuNDE0Ml0sIFs0OC4zMDQ5LCAxLjk2MTNdLCBbNDguNDQwOCwgMS45MzU0XSwgWzQ5LjA3OTQsIDIuODk2OV0sIFs0OS4wODU1LCAyLjk5NDVdLCBbNDguOTkxMywgMy4yMjMzXSwgWzQ4LjY0NjgsIDEuNjQwN10sIFs0OC43MSwgMS41ODc0XSwgWzQ4LjI5MjksIDEuOTc0Nl0sIFs0OC42MTE1LCAxLjY4OF0sIFs0OC40NDE1LCAxLjkzOF0sIFs0OC40MjY1LCAxLjkzOF0sIFs0OC40Mzc5LCAxLjkzOTVdLCBbNDguNTY1MSwgMS43NjI3XSwgWzQ4LjQwMiwgMS45Nzc2XSwgWzQ4LjY4OTUsIDEuNjExOF0sIFs0OS4xNzM1LCAxLjkyNDVdLCBbNDguNjE0MSwgMS42Njc0XSwgWzQ5LjA4MjgsIDIuNzgwMl0sIFs0OS4wODM4LCAyLjgzOTVdLCBbNDguMzc0MSwgMy4xODE5XSwgWzQ4LjM2MTEsIDMuMDc5OF0sIFs0OC43ODgxLCAzLjQ0MjZdLCBbNDkuMTAzOSwgMy4wNTk1XSwgWzQ4LjEzOSwgMi42Mzk3XSwgWzQ5LjE3MzIsIDEuODM3NV0sIFs0OS4wOTE5LCAyLjY3MDFdLCBbNDguNDg4NCwgMy40MDgxXSwgWzQ4Ljk0NzIsIDMuMjYxOV0sIFs0OC44NDg3LCAzLjQ2OTFdLCBbNDkuMTA3MywgMy4xMTU3XSwgWzQ4LjE5MjEsIDIuOTU0M10sIFs0OC45NDQ1LCAzLjMwNzZdLCBbNDguMzExMiwgMi4zODI2XSwgWzQ4LjMxMiwgMi4yOTg3XSwgWzQ5LjA4NjEsIDIuOTUyOF0sIFs0OS4wODU2LCAyLjk2OTVdLCBbNDguNDYwNCwgMy4zOTg4XSwgWzQ4LjQ1MDksIDMuNDA2NV0sIFs0OS4xODI4LCAyLjMwMDRdLCBbNDkuMjExNywgMS42NzQ0XSwgWzQ4LjMyOTYsIDIuMzI0NV0sIFs0OC40OTExLCAzLjQyMzRdLCBbNDguNDU1OSwgMS44NDAxXSwgWzQ5LjE2OTUsIDIuMTc1MV0sIFs0OS4xMDkzLCAzLjEyMDddLCBbNDguMTY1NCwgMi44MDA3XSwgWzQ4LjE1OTYsIDIuNzQyN10sIFs0OC42MzQ3LCAzLjQ1MTFdLCBbNDguODI5NCwgMS41NzldLCBbNDkuMTgzNiwgMS43OTM3XSwgWzQ4LjE2NzUsIDIuNzc5Ml0sIFs0OC4xMzI4LCAyLjUyNzddLCBbNDkuMTcyLCAxLjg1NV0sIFs0OC4zNTQyLCAzLjEwMDldLCBbNDguODY2LCAzLjQxOTZdLCBbNDguNzExNSwgMy40NjU0XSwgWzQ4LjU0NTQsIDMuNDc5MV0sIFs0OC4yNDQ2LCAyLjQ3NjNdLCBbNDguMzA2MiwgMi40MTM4XSwgWzQ4LjM1NjUsIDEuOTc1Ml0sIFs0OS4xNDY5LCAyLjQzNjhdLCBbNDkuMTkxMSwgMi4xMjU3XSwgWzQ5LjE3MDMsIDIuMzM2MV0sIFs0OC42Mzc4LCAzLjUyMDFdLCBbNDguNDc3OSwgMy4zODU5XSwgWzQ4LjM3MDgsIDMuMTY0OF0sIFs0OC4zMTYzLCAyLjQwNDVdLCBbNDguNDg3OSwgMS43OTIxXSwgWzQ4Ljg3NzcsIDEuNTUyOF0sIFs0OS4yMDU3LCAyLjA4MjhdLCBbNDguODkyLCAzLjM3MTFdLCBbNDguODEwNiwgMS41ODA3XSwgWzQ4LjE2NTQsIDIuODA2XSwgWzQ5LjIyLCAxLjY4OThdLCBbNDkuMDg5MSwgMi43ODc4XSwgWzQ5LjA5MjgsIDIuNTc1OV0sIFs0OC45MjU3LCAzLjM3MV0sIFs0OC44NTUzLCAzLjQ1MTddLCBbNDguNDkwNSwgMy40MzJdLCBbNDguNjE0LCAxLjY4MzRdLCBbNDkuMTYxLCAyLjI4NTldLCBbNDkuMDg5LCAzLjA2NDFdLCBbNDguOTI3NCwgMy4zNjg2XSwgWzQ4LjY0OTEsIDMuNDU4NV0sIFs0OC40NTc2LCAzLjQwMDVdLCBbNDguNDMyNiwgMy4zOTZdLCBbNDguMTI4NSwgMi40NzI2XSwgWzQ4LjMzNTgsIDIuMjIxMV0sIFs0OS4xNzE5LCAyLjE1ODZdLCBbNDguODM4NiwgMy40OTAzXSwgWzQ4LjI5MjEsIDMuMDIyMl0sIFs0OS4wOTM2LCAzLjA1ODRdLCBbNDkuMTA1MiwgMy4wNjE0XSwgWzQ4LjIwNDQsIDIuNTE5Nl0sIFs0OC4yOTM3LCAyLjA3NzZdLCBbNDguODAxMiwgMy40MjU0XSwgWzQ4LjE5MjEsIDIuOTU2Ml0sIFs0OC4xNTAxLCAyLjc1NV0sIFs0OC4xMzY1LCAyLjYyMzhdLCBbNDkuMDg0OSwgMi44NDQ5XSwgWzQ4LjUzMDksIDMuNDI2Nl0sIFs0OC40ODQxLCAzLjM5NzZdLCBbNDguMTY3NCwgMi43OTc1XSwgWzQ4LjI2MTQsIDMuMDQzNV0sIFs0OC42MzY5LCAzLjQ1MzFdLCBbNDguNDMyOSwgMy4zOTY4XSwgWzQ4LjQwMiwgMS45NzgyXSwgWzQ5LjA5NDYsIDIuNjE5Nl0sIFs0OS4yMDQyLCAyLjA3MjVdLCBbNDguNTk2MiwgMy41MTIzXSwgWzQ5LjA1OSwgMS41MDI4XSwgWzQ5LjA3OTUsIDEuNTgwNV0sIFs0OS4wOTcsIDEuNjE4Nl0sIFs0OS4xODA0LCAxLjY3MDRdLCBbNDkuMjEwMywgMS43Mjk5XSwgWzQ4LjY4NDQsIDMuNDYwMV0sIFs0OS4xODk0LCAxLjc0MDZdLCBbNDkuMDk5MSwgMy4wNTZdLCBbNDkuMTgwMiwgMS43NDIxXSwgWzQ4LjE1OTEsIDIuODA4NV0sIFs0OC4yNzU0LCAyLjQxOThdLCBbNDguMzQ0OSwgMi4yMDQ5XSwgWzQ5LjA2OTIsIDEuNTU4MV0sIFs0OS4wNzk4LCAxLjU4MjVdLCBbNDkuMTczNywgMi4xODJdLCBbNDkuMTYsIDIuMjIzMV0sIFs0OC45MTg0LCAzLjM2MDVdLCBbNDguMzc1OSwgMS45OF0sIFs0OC4zOCwgMS45NzA4XSwgWzQ4LjQ3OTYsIDEuNzk0XSwgWzQ4LjUwOTYsIDEuNzgwM10sIFs0OC40MTA3LCAxLjkzMjddLCBbNDguMzMxOSwgMS45Nzg1XSwgWzQ4LjM3MjYsIDEuOTgxNV0sIFs0OC41MDcsIDEuNzgwM10sIFs0OC40NCwgMS45NDE5XSwgWzQ4LjQ2NzYsIDEuODMyMV0sIFs0OS4xMDg0LCAzLjEwMTVdLCBbNDguNTE0OCwgMy40MjM1XSwgWzQ4LjEzNDQsIDIuODMyXSwgWzQ4LjI5NDMsIDIuNDIzNF0sIFs0OC4yOTk4LCAyLjQyMDRdLCBbNDguMzE0NiwgMi4zOTc1XSwgWzQ5LjE3OTcsIDEuOTg0XSwgWzQ4LjM3ODksIDMuMjk5NF0sIFs0OC45MTIxLCAzLjMzOV0sIFs0OC43ODM4LCAzLjQyNDRdLCBbNDkuMTc1MiwgMS42NjY0XSwgWzQ5LjIwOTYsIDEuNzI4OV0sIFs0OS4xMDA5LCAzLjE0NzldLCBbNDkuMDk1OCwgMy4xNjMxXSwgWzQ4LjI2NjIsIDIuNDIwMV0sIFs0OC4yOTQ4LCAyLjQyMzNdLCBbNDguNzM2NywgMy40NDQ3XSwgWzQ4Ljg2NTEsIDEuNTU1Ml0sIFs0OC4xMzE0LCAyLjQ0NjZdLCBbNDguNDQ0NiwgMS45MzE4XSwgWzQ5LjA4MjUsIDIuODQ3NV0sIFs0OC43OCwgMy40MzA5XSwgWzQ5LjIxNjYsIDEuNjg1MV0sIFs0OC45MTc4LCAzLjM3MTZdLCBbNDguNDM5NCwgMS44OTk2XSwgWzQ4LjQ2MzYsIDEuODM1Nl0sIFs0OC42NDEsIDMuNDgzM10sIFs0OC4zNzM5LCAzLjMwMThdLCBbNDguOTc5MiwgMS40OTg0XSwgWzQ4LjE2NjMsIDIuNzM2N10sIFs0OC4zMDYzLCAyLjQxMzVdLCBbNDguMzEyMiwgMi4yODA4XSwgWzQ4LjQ5OSwgMS43ODg5XSwgWzQ5LjE2ODcsIDIuMTYyXSwgWzQ4LjMxNSwgMi4xNzA4XSwgWzQ4LjE1MTgsIDIuNDc0MV0sIFs0OC4xMzgyLCAyLjY0MTddLCBbNDguMjMyOCwgMi41MDc3XSwgWzQ4LjMyNzcsIDIuMjMxOF0sIFs0OC4zMzM1LCAyLjIxNzldLCBbNDguMzM1NiwgMi4xOTUyXSwgWzQ4LjI5NDQsIDIuMDY0XSwgWzQ5LjEwMDEsIDMuMTUyOF0sIFs0OC4xNjYxLCAyLjgwOTVdLCBbNDguMzY1LCAzLjI1NDRdLCBbNDkuMDQ1NywgMy4xODc5XSwgWzQ5LjEwOSwgMy4xMTkyXSwgWzQ5LjEwNzQsIDMuMTM2MV0sIFs0OS4wNDc2LCAzLjE5MDldLCBbNDkuMDg4MywgMy4wMjMzXSwgWzQ4LjE2NjcsIDIuNzgzN10sIFs0OC40NjYzLCAxLjgxMTVdLCBbNDguOTYzMiwgMS40OTQ1XSwgWzQ5LjE4OTksIDEuNjcwNV0sIFs0OS4xMDAxLCAyLjY1MTJdLCBbNDguNjczMSwgMy40NDRdLCBbNDguNDg2OCwgMy40MTM0XSwgWzQ5LjA5NDEsIDEuNjE3NV0sIFs0OS4xMTEzLCAzLjA4NzRdLCBbNDkuMDQyNSwgMy4xODA1XSwgWzQ4LjEyNzgsIDIuNTIwNl0sIFs0OS4wNjA3LCAyLjczN10sIFs0OS4wNjYxLCAyLjc2NzZdLCBbNDguODg4OCwgMy4zODI5XSwgWzQ4Ljc4NTEsIDMuNDM3N10sIFs0OS4xNDk2LCAyLjQyM10sIFs0OC4xOTI1LCAyLjk2NF0sIFs0OC4xMzE5LCAyLjU3NjhdLCBbNDguMjk4NCwgMi4xNjM3XSwgWzQ4LjY3OTEsIDEuNjA2MV0sIFs0OS4wNzU3LCAyLjY5NDFdLCBbNDkuMDYwNywgMi43NTM2XSwgWzQ4LjUwODQsIDMuNDI2MV0sIFs0OC41NjM4LCAxLjc2MzZdLCBbNDguMTYyOSwgMi43Njk0XSwgWzQ4LjEzNDksIDIuNzE5MV0sIFs0OC4yOTQ3LCAyLjA4OTZdLCBbNDguMzcwNCwgMS45ODAyXSwgWzQ5LjA3MzUsIDEuNTQwNF0sIFs0OS4wNjgsIDIuNzMyOF0sIFs0OC41Mjc3LCAxLjc3NThdLCBbNDkuMDA4OCwgMy4xOTgxXSwgWzQ4LjMyMDgsIDIuMzA0NF0sIFs0OC45ODg5LCAxLjQ2MTddLCBbNDguOTk3NiwgMS40NzM5XSwgWzQ4Ljc4MzksIDMuNDM1NF0sIFs0OC42MzU2LCAzLjQ2MjhdLCBbNDguNjMyNiwgMy41MjIzXSwgWzQ4LjYxOTcsIDMuNTU1OV0sIFs0OC41ODk1LCAzLjUxMTZdLCBbNDguNTMyMywgMy40MTU1XSwgWzQ4LjM5MzcsIDMuNDE1NV0sIFs0OC4zOTA2LCAzLjQwNjVdLCBbNDguMzcxLCAzLjM1NzddLCBbNDguMzc3NiwgMy4yOF0sIFs0OS4wODYsIDIuNjc4MV0sIFs0OS4wNzAyLCAyLjg3MDNdLCBbNDkuMDc0MiwgMi45NzU0XSwgWzQ5LjA4NzcsIDIuOTk4M10sIFs0OS4wNzQ3LCAyLjY5NV0sIFs0OS4wNzI3LCAyLjg1NDldLCBbNDguNDQ3OCwgMS45MTE5XSwgWzQ5LjEwMzcsIDMuMDU5M10sIFs0OC42MTQxLCAxLjY5MDldLCBbNDkuMDg0MywgMi45MDM5XSwgWzQ5LjE0NzUsIDIuNDM0NV0sIFs0OC41NDQ3LCAzLjQ3OTZdLCBbNDguMzcxMywgMy4xNjQxXSwgWzQ4Ljk3NjksIDEuNDc3NF0sIFs0OC41MTU5LCAxLjc3NjhdLCBbNDguMjkyMywgMS45ODA0XSwgWzQ5LjE3MTEsIDEuOTUyMl0sIFs0OS4wNzM0LCAyLjg1NV0sIFs0OS4xNTg0LCAyLjM3MDJdLCBbNDguODkxOSwgMy4zNzM0XSwgWzQ4LjY2MTIsIDMuNDQ2Nl0sIFs0OC41OTc2LCAzLjUxMDZdLCBbNDkuMDg4MywgMy4wNTUxXSwgWzQ4LjEzNTQsIDIuNTMwOV0sIFs0OC4yNjk4LCAyLjQxOTZdLCBbNDguMjk1MSwgMi4wNTUzXSwgWzQ5LjA4NDEsIDEuNjAzMl0sIFs0OC40NjYsIDEuODIyNF0sIFs0OS4wODE0LCAyLjU5NDldLCBbNDguODg2OSwgMy4zODFdLCBbNDguNzgwNCwgMy40MzI4XSwgWzQ4LjYxNjEsIDMuNTQ0MV0sIFs0OC40MTgyLCAzLjQxMTRdLCBbNDguODU4OSwgMS41ODM2XSwgWzQ4LjgxNzMsIDEuNTkwNV0sIFs0OC42OTI1LCAxLjU5MTJdLCBbNDkuMDcyOSwgMi45NzczXSwgWzQ4LjkxLCAzLjMzNzNdLCBbNDguODU5LCAzLjQ0NzFdLCBbNDguODQ5NiwgMS41Nzg4XSwgWzQ4Ljg3NTIsIDEuNTUxNF0sIFs0OC4yNTI1LCAyLjQ0OV0sIFs0OC43NzkxLCAxLjU4MDRdLCBbNDguODQyMywgMS41ODk2XSwgWzQ5LjE3NDIsIDIuMjAyXSwgWzQ5LjE4NjMsIDIuMzEzM10sIFs0OC40MjQzLCAzLjM5Ml0sIFs0OC4zNTczLCAzLjA4ODddLCBbNDkuMDU2MywgMS40OTI0XSwgWzQ5LjA3MjEsIDEuNTE5OF0sIFs0OC40NDM4LCAxLjkzNDVdLCBbNDguNDQ1NCwgMS45MDcxXSwgWzQ5LjA2ODQsIDEuNTIxM10sIFs0OS4wODQxLCAxLjYwMzddLCBbNDkuMDIwNywgMy4xNjU4XSwgWzQ5LjA4ODcsIDEuNjE4OV0sIFs0OC4xMzc1LCAyLjU3MjJdXTsKICAgICAgICAgICAgICAgIHZhciBjbHVzdGVyID0gTC5tYXJrZXJDbHVzdGVyR3JvdXAoe30pOwoKICAgICAgICAgICAgICAgIGZvciAodmFyIGkgPSAwOyBpIDwgZGF0YS5sZW5ndGg7IGkrKykgewogICAgICAgICAgICAgICAgICAgIHZhciByb3cgPSBkYXRhW2ldOwogICAgICAgICAgICAgICAgICAgIHZhciBtYXJrZXIgPSBjYWxsYmFjayhyb3cpOwogICAgICAgICAgICAgICAgICAgIG1hcmtlci5hZGRUbyhjbHVzdGVyKTsKICAgICAgICAgICAgICAgIH0KCiAgICAgICAgICAgICAgICBjbHVzdGVyLmFkZFRvKG1hcF85NDJjZjU5MjFkOWE0YjFiOGVkZGZhNTc1Y2E1ZmEyYSk7CiAgICAgICAgICAgICAgICByZXR1cm4gY2x1c3RlcjsKICAgICAgICAgICAgfSkoKTsKICAgICAgICAgICAgCjwvc2NyaXB0Pg== onload=\"this.contentDocument.open();this.contentDocument.write(atob(this.getAttribute('data-html')));this.contentDocument.close();\" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>"
            ],
            "text/plain": [
              "<folium.folium.Map at 0x7fce89cbebe0>"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 90
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "0IsMIh2Ey9Ja"
      },
      "source": [
        "coord_dep = json.load(open(\"/content/geoloc/departements.geojson\"))"
      ],
      "execution_count": null,
      "outputs": []
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "WADEGSN8zH_u",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 35
        },
        "outputId": "1f803936-5238-4ddf-d42f-eb6c93eca1f7"
      },
      "source": [
        "coordinates_dep = list(coord_dep['features'][0]['geometry']['coordinates'])\n",
        "lat_dep = [coordinates_dep[0][i][0] for i in range(len(coordinates_dep[0]))]\n",
        "lon_dep = [coordinates_dep[0][i][1] for i in range(len(coordinates_dep[0]))]\n",
        "\n",
        "loc = set(zip(lon_dep, lat_dep))\n",
        "\n",
        "map_dep = folium.Map(location = [lon_dep[0], lat_dep[0]], zoom_start=16)\n",
        "FastMarkerCluster(data=loc).add_to(map_dep)"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/plain": [
              "<folium.plugins.fast_marker_cluster.FastMarkerCluster at 0x7fce89cb0f60>"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 96
        }
      ]
    },
    {
      "cell_type": "code",
      "metadata": {
        "id": "Tq38LosHz2_m",
        "colab": {
          "base_uri": "https://localhost:8080/",
          "height": 788
        },
        "outputId": "9b23c921-65ea-48e1-ba45-7d0abace5af7"
      },
      "source": [
        "map_dep"
      ],
      "execution_count": null,
      "outputs": [
        {
          "output_type": "execute_result",
          "data": {
            "text/html": [
              "<div style=\"width:100%;\"><div style=\"position:relative;width:100%;height:0;padding-bottom:60%;\"><span style=\"color:#565656\">Make this Notebook Trusted to load map: File -> Trust Notebook</span><iframe src=\"about:blank\" style=\"position:absolute;width:100%;height:100%;left:0;top:0;border:none !important;\" data-html=PCFET0NUWVBFIGh0bWw+CjxoZWFkPiAgICAKICAgIDxtZXRhIGh0dHAtZXF1aXY9ImNvbnRlbnQtdHlwZSIgY29udGVudD0idGV4dC9odG1sOyBjaGFyc2V0PVVURi04IiAvPgogICAgPHNjcmlwdD5MX1BSRUZFUl9DQU5WQVM9ZmFsc2U7IExfTk9fVE9VQ0g9ZmFsc2U7IExfRElTQUJMRV8zRD1mYWxzZTs8L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS40LjAvZGlzdC9sZWFmbGV0LmpzIj48L3NjcmlwdD4KICAgIDxzY3JpcHQgc3JjPSJodHRwczovL2NvZGUuanF1ZXJ5LmNvbS9qcXVlcnktMS4xMi40Lm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvanMvYm9vdHN0cmFwLm1pbi5qcyI+PC9zY3JpcHQ+CiAgICA8c2NyaXB0IHNyYz0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvTGVhZmxldC5hd2Vzb21lLW1hcmtlcnMvMi4wLjIvbGVhZmxldC5hd2Vzb21lLW1hcmtlcnMuanMiPjwvc2NyaXB0PgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvbnBtL2xlYWZsZXRAMS40LjAvZGlzdC9sZWFmbGV0LmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL21heGNkbi5ib290c3RyYXBjZG4uY29tL2Jvb3RzdHJhcC8zLjIuMC9jc3MvYm9vdHN0cmFwLm1pbi5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9tYXhjZG4uYm9vdHN0cmFwY2RuLmNvbS9ib290c3RyYXAvMy4yLjAvY3NzL2Jvb3RzdHJhcC10aGVtZS5taW4uY3NzIi8+CiAgICA8bGluayByZWw9InN0eWxlc2hlZXQiIGhyZWY9Imh0dHBzOi8vbWF4Y2RuLmJvb3RzdHJhcGNkbi5jb20vZm9udC1hd2Vzb21lLzQuNi4zL2Nzcy9mb250LWF3ZXNvbWUubWluLmNzcyIvPgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9MZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy8yLjAuMi9sZWFmbGV0LmF3ZXNvbWUtbWFya2Vycy5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9yYXdjZG4uZ2l0aGFjay5jb20vcHl0aG9uLXZpc3VhbGl6YXRpb24vZm9saXVtL21hc3Rlci9mb2xpdW0vdGVtcGxhdGVzL2xlYWZsZXQuYXdlc29tZS5yb3RhdGUuY3NzIi8+CiAgICA8c3R5bGU+aHRtbCwgYm9keSB7d2lkdGg6IDEwMCU7aGVpZ2h0OiAxMDAlO21hcmdpbjogMDtwYWRkaW5nOiAwO308L3N0eWxlPgogICAgPHN0eWxlPiNtYXAge3Bvc2l0aW9uOmFic29sdXRlO3RvcDowO2JvdHRvbTowO3JpZ2h0OjA7bGVmdDowO308L3N0eWxlPgogICAgCiAgICA8bWV0YSBuYW1lPSJ2aWV3cG9ydCIgY29udGVudD0id2lkdGg9ZGV2aWNlLXdpZHRoLAogICAgICAgIGluaXRpYWwtc2NhbGU9MS4wLCBtYXhpbXVtLXNjYWxlPTEuMCwgdXNlci1zY2FsYWJsZT1ubyIgLz4KICAgIDxzdHlsZT4jbWFwX2VjODUxNGFiYjAyZjQ0ODE5ZDRkZWJmNTgwZGU2ZGQ1IHsKICAgICAgICBwb3NpdGlvbjogcmVsYXRpdmU7CiAgICAgICAgd2lkdGg6IDEwMC4wJTsKICAgICAgICBoZWlnaHQ6IDEwMC4wJTsKICAgICAgICBsZWZ0OiAwLjAlOwogICAgICAgIHRvcDogMC4wJTsKICAgICAgICB9CiAgICA8L3N0eWxlPgogICAgPHNjcmlwdCBzcmM9Imh0dHBzOi8vY2RuanMuY2xvdWRmbGFyZS5jb20vYWpheC9saWJzL2xlYWZsZXQubWFya2VyY2x1c3Rlci8xLjEuMC9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIuanMiPjwvc2NyaXB0PgogICAgPGxpbmsgcmVsPSJzdHlsZXNoZWV0IiBocmVmPSJodHRwczovL2NkbmpzLmNsb3VkZmxhcmUuY29tL2FqYXgvbGlicy9sZWFmbGV0Lm1hcmtlcmNsdXN0ZXIvMS4xLjAvTWFya2VyQ2x1c3Rlci5jc3MiLz4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgaHJlZj0iaHR0cHM6Ly9jZG5qcy5jbG91ZGZsYXJlLmNvbS9hamF4L2xpYnMvbGVhZmxldC5tYXJrZXJjbHVzdGVyLzEuMS4wL01hcmtlckNsdXN0ZXIuRGVmYXVsdC5jc3MiLz4KPC9oZWFkPgo8Ym9keT4gICAgCiAgICAKICAgIDxkaXYgY2xhc3M9ImZvbGl1bS1tYXAiIGlkPSJtYXBfZWM4NTE0YWJiMDJmNDQ4MTlkNGRlYmY1ODBkZTZkZDUiID48L2Rpdj4KPC9ib2R5Pgo8c2NyaXB0PiAgICAKICAgIAogICAgCiAgICAgICAgdmFyIGJvdW5kcyA9IG51bGw7CiAgICAKCiAgICB2YXIgbWFwX2VjODUxNGFiYjAyZjQ0ODE5ZDRkZWJmNTgwZGU2ZGQ1ID0gTC5tYXAoCiAgICAgICAgJ21hcF9lYzg1MTRhYmIwMmY0NDgxOWQ0ZGViZjU4MGRlNmRkNScsIHsKICAgICAgICBjZW50ZXI6IFs0Ni4xNzY3LCA0Ljc4MDJdLAogICAgICAgIHpvb206IDE2LAogICAgICAgIG1heEJvdW5kczogYm91bmRzLAogICAgICAgIGxheWVyczogW10sCiAgICAgICAgd29ybGRDb3B5SnVtcDogZmFsc2UsCiAgICAgICAgY3JzOiBMLkNSUy5FUFNHMzg1NywKICAgICAgICB6b29tQ29udHJvbDogdHJ1ZSwKICAgICAgICB9KTsKCgogICAgCiAgICB2YXIgdGlsZV9sYXllcl80NWI0NjRhMTc5ZGM0MmZmOTU3MTlmMmUzMGRmNjQ1OCA9IEwudGlsZUxheWVyKAogICAgICAgICdodHRwczovL3tzfS50aWxlLm9wZW5zdHJlZXRtYXAub3JnL3t6fS97eH0ve3l9LnBuZycsCiAgICAgICAgewogICAgICAgICJhdHRyaWJ1dGlvbiI6IG51bGwsCiAgICAgICAgImRldGVjdFJldGluYSI6IGZhbHNlLAogICAgICAgICJtYXhOYXRpdmVab29tIjogMTgsCiAgICAgICAgIm1heFpvb20iOiAxOCwKICAgICAgICAibWluWm9vbSI6IDAsCiAgICAgICAgIm5vV3JhcCI6IGZhbHNlLAogICAgICAgICJvcGFjaXR5IjogMSwKICAgICAgICAic3ViZG9tYWlucyI6ICJhYmMiLAogICAgICAgICJ0bXMiOiBmYWxzZQp9KS5hZGRUbyhtYXBfZWM4NTE0YWJiMDJmNDQ4MTlkNGRlYmY1ODBkZTZkZDUpOwogICAgCgogICAgICAgICAgICB2YXIgZmFzdF9tYXJrZXJfY2x1c3Rlcl81NTgzOTM0NGU1Njk0OTcxYmQ5YTY5NTBmMmM4MTg4NSA9IChmdW5jdGlvbigpewogICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICB2YXIgY2FsbGJhY2sgPSBmdW5jdGlvbiAocm93KSB7CiAgICAgICAgICAgICAgICAgICAgdmFyIGljb24gPSBMLkF3ZXNvbWVNYXJrZXJzLmljb24oKTsKICAgICAgICAgICAgICAgICAgICB2YXIgbWFya2VyID0gTC5tYXJrZXIobmV3IEwuTGF0TG5nKHJvd1swXSwgcm93WzFdKSk7CiAgICAgICAgICAgICAgICAgICAgbWFya2VyLnNldEljb24oaWNvbik7CiAgICAgICAgICAgICAgICAgICAgcmV0dXJuIG1hcmtlcjsKICAgICAgICAgICAgICAgIH07CgogICAgICAgICAgICAgICAgdmFyIGRhdGEgPSBbWzQ2LjE3MjQsIDUuOTg2NF0sIFs0Ni4xMDcsIDUuODg1NV0sIFs0Ni4zMTYzLCA1LjY4MzNdLCBbNDUuOTA0NiwgNC44NjQ1XSwgWzQ1LjkyMjgsIDQuNzg5OF0sIFs0Ni4zNjU5LCA1Ljk5MjJdLCBbNDUuNjQ0LCA1LjY4NzldLCBbNDUuNzUxMywgNS40ODY1XSwgWzQ1LjgyMzgsIDUuNDIyNV0sIFs0NS44MjY0LCA1LjQzNjJdLCBbNDUuODQ4LCA1LjMwMjRdLCBbNDUuODQ0LCA1LjMwMDVdLCBbNDUuODEwMywgNS4wNTg0XSwgWzQ2LjQ0MzIsIDUuMzE0M10sIFs0Ni40NTA3LCA1LjI1NjNdLCBbNDYuMzQ2NywgNS40MjExXSwgWzQ2LjM1MDUsIDUuMzc1M10sIFs0Ni4zOTU1LCA1LjM1MjZdLCBbNDYuNDI3NiwgNS4zMTg4XSwgWzQ2LjI4OSwgNS40NTkyXSwgWzQ2LjI3MSwgNS40NjUyXSwgWzQ2LjI2OTEsIDUuNDkyOF0sIFs0Ni4zMDksIDUuNjAyNl0sIFs0Ni41MTA3LCA0LjkzMjJdLCBbNDYuMzEwOSwgNS42ODQ2XSwgWzQ2LjA4NTYsIDUuODc2Nl0sIFs0Ni4wNDgsIDUuODA5N10sIFs0Ni4wOTA4LCA0Ljc0NzddLCBbNDYuMTUzMSwgNC44MDI3XSwgWzQ2LjIxODYsIDUuOTkzOF0sIFs0Ni4zNzgyLCA2LjE1NTRdLCBbNDYuMzI5MSwgNi4xMzU1XSwgWzQ2LjMyNzYsIDYuMTM0XSwgWzQ2LjMyMSwgNi4xMjY1XSwgWzQ2LjM0NjUsIDUuOTcyXSwgWzQ2LjMxMzIsIDYuMTIwM10sIFs0Ni4zMDMzLCA2LjExOV0sIFs0Ni4yNDQzLCA2LjA3NzldLCBbNDYuMjY1LCA1LjUxMDldLCBbNDUuODA3MywgNS4wMDYzXSwgWzQ1LjgzMDksIDQuOTIxM10sIFs0NS44OTcxLCA0Ljg3MjNdLCBbNDUuOTA5NCwgNC44MzU5XSwgWzQ1Ljg0NzYsIDUuMzAyXSwgWzQ1Ljk1NTgsIDQuNzM4M10sIFs0Ni4zMTAyLCA1LjkyXSwgWzQ1Ljc0MzcsIDUuNzgyOF0sIFs0NS43MjAxLCA1Ljc2NDZdLCBbNDUuNzA5OCwgNS43MDA0XSwgWzQ1LjY3MTgsIDUuNTU0Ml0sIFs0NS44MDU4LCA1LjE0NzFdLCBbNDYuNDg4OSwgNS4wODAyXSwgWzQ2LjUwOTUsIDUuMTM5M10sIFs0Ni41MDc0LCA1LjE0NDJdLCBbNDYuNDUwOCwgNS4yNjEzXSwgWzQ2LjMzNTIsIDUuNDE1NF0sIFs0Ni40ODk5LCA1LjIwOF0sIFs0Ni4zNDY0LCA1LjQyMTRdLCBbNDYuNDU3MiwgNS4yMzY5XSwgWzQ2LjQ4MzQsIDUuMjE0Ml0sIFs0Ni40MDE5LCA1LjMzOTJdLCBbNDYuNTA1OSwgNC45NjU5XSwgWzQ2LjIxNjksIDUuOTgxMV0sIFs0Ni4wOTksIDUuODQyM10sIFs0Ni4wNjYzLCA0Ljc2MTddLCBbNDYuMDcyNSwgNC43NjAyXSwgWzQ2LjMxMDUsIDUuOTM1M10sIFs0Ni4yNjY3LCA1Ljg1ODZdLCBbNDYuMzk4MywgNi4wNDE0XSwgWzQ2LjQxMDcsIDYuMDUyMV0sIFs0Ni4zNzQxLCA2LjE2MTldLCBbNDYuMzE3MiwgNi4xMjU1XSwgWzQ2LjE4ODEsIDUuOTg3MV0sIFs0NS44MTE4LCA1LjA1MV0sIFs0NS42OTc4LCA1LjU1NTRdLCBbNDUuODE1NywgNC45MjAxXSwgWzQ1Ljg0NTMsIDQuOTE3MV0sIFs0NS45MDM4LCA0LjgyMjVdLCBbNDUuODk3MSwgNC44MDg4XSwgWzQ2LjExMzksIDQuNzcxNl0sIFs0NS44MzA2LCA1Ljc5NjhdLCBbNDUuNzMyNiwgNS43NzQxXSwgWzQ1LjY5ODIsIDUuNzAzN10sIFs0NS42NDMxLCA1LjY4NzJdLCBbNDUuNjQwMywgNS42ODI1XSwgWzQ1LjYxMDksIDUuNjMwMV0sIFs0NS43ODI5LCA1LjQ1MzddLCBbNDYuNDk1NCwgNS4xMDE3XSwgWzQ2LjUxMjEsIDUuMTc0OV0sIFs0Ni4zMTgxLCA1LjQ1NjhdLCBbNDYuMzM0NiwgNS40Mjk2XSwgWzQ2LjMxNzksIDUuNDU0XSwgWzQ2LjQ1MzQsIDUuMjU1Nl0sIFs0Ni40ODYxLCA1LjIwN10sIFs0Ni4yNzU1LCA1LjQ1N10sIFs0Ni4yODg2LCA1LjkxMjddLCBbNDYuMzYzNiwgNS45ODQ0XSwgWzQ2LjI3ODIsIDUuNTUxM10sIFs0Ni4wMDExLCA1LjgwOTldLCBbNDYuMDQ3MiwgNC43Mzk1XSwgWzQ2LjM2OTcsIDUuOTk5OF0sIFs0Ni4xNjYzLCA0Ljc4NjZdLCBbNDUuNzk5MiwgNS4xMDcxXSwgWzQ2LjM3ODcsIDYuMDE3N10sIFs0Ni4zODk0LCA2LjAzMjddLCBbNDYuNDA4NSwgNi4wOTgyXSwgWzQ2LjMzOCwgNi4xMzhdLCBbNDYuMzAxLCA2LjEyMTFdLCBbNDYuMjQxOCwgNi4wOTU0XSwgWzQ2LjI2NiwgNS43NTE0XSwgWzQ2LjE4OCwgNS45ODc5XSwgWzQ2LjI2NjQsIDUuNzUyNF0sIFs0Ni4yNjg2LCA1Ljg3NzFdLCBbNDUuOTAzMSwgNC44MjExXSwgWzQ1LjkwMDUsIDQuODAzMV0sIFs0NS45MzY2LCA0Ljc2NDhdLCBbNDYuMzI0NiwgNS45NTI1XSwgWzQ1LjkxNiwgNS44Mjk0XSwgWzQ1Ljc4NzMsIDUuNzgzNl0sIFs0NS43NDUyLCA1Ljc4MzZdLCBbNDYuMTIyNywgNS45MDY5XSwgWzQ1LjcxMDQsIDUuNzU3N10sIFs0NS42NzQxLCA1LjY5NjVdLCBbNDUuNjk5NSwgNS41NDg2XSwgWzQ2LjQxNTQsIDUuMzA5Nl0sIFs0Ni41MDU4LCA1LjE2MDJdLCBbNDYuMzE2NywgNS40MDRdLCBbNDYuNDU4NSwgNS4yMzQ5XSwgWzQ2LjM0NzcsIDUuNDIzN10sIFs0Ni4zMTgzLCA1LjQ0OTZdLCBbNDYuMzgyMywgNS4zNzc5XSwgWzQ2LjQ0NzEsIDUuMjg2NV0sIFs0Ni40ODk3LCA1LjIwODhdLCBbNDYuNDUwMSwgNS4yNjk4XSwgWzQ2LjMyNTUsIDQuODUxMV0sIFs0Ni41MTI2LCA0Ljk0MjNdLCBbNDYuMzY0MywgNS45ODU4XSwgWzQ2LjA5NDEsIDQuNzUwM10sIFs0Ni4yODIsIDUuODkwOF0sIFs0NS44Njk4LCA1LjM3NzhdLCBbNDYuMzc5MiwgNi4wMTY1XSwgWzQ2LjM5MjEsIDYuMDM2Ml0sIFs0Ni40MDA3LCA2LjA0MzldLCBbNDYuMzc3NCwgNi4xNTM3XSwgWzQ2LjM0NjUsIDYuMTUyXSwgWzQ2LjMyOCwgNi4xMzM4XSwgWzQ2LjI5MzcsIDYuMTEyNF0sIFs0Ni4yNzgxLCA2LjEwNDldLCBbNDYuMzI1NiwgNS45NTMzXSwgWzQ2LjI0MTUsIDYuMDU1OV0sIFs0NS43ODk2LCA1LjI2NzJdLCBbNDYuMzIzNSwgNS40NjUyXSwgWzQ2LjEwNTgsIDUuODg2MV0sIFs0NS43OTE3LCA1LjE3OTFdLCBbNDUuOTM4NSwgNS44MzEyXSwgWzQ1LjcyNjQsIDUuNzc2Ml0sIFs0NS42NTMsIDUuNjg3OF0sIFs0NS42OTMxLCA1LjU2MTNdLCBbNDUuNzk1OCwgNS40MzhdLCBbNDUuODU2OSwgNS40MDQ0XSwgWzQ1Ljg4MTEsIDUuMzU4OF0sIFs0Ni40MDMsIDUuMzI0OV0sIFs0Ni40MzU4LCA1LjMxNzRdLCBbNDYuNDksIDUuMDgxM10sIFs0Ni41MDI4LCA1LjEzMDFdLCBbNDYuNTEyMiwgNS4xNzU1XSwgWzQ2LjQ1NzcsIDUuMjM2NV0sIFs0Ni40Mjg5LCA1LjMyMzRdLCBbNDYuNDMzNSwgNS4zMTc2XSwgWzQ2LjQ2MiwgNS4yMzIyXSwgWzQ2LjM3MDksIDUuMzYzXSwgWzQ2LjI3MDIsIDQuODIyNV0sIFs0Ni4wMjk4LCA1LjgxMDZdLCBbNDUuNzM2MSwgNS41MTAxXSwgWzQ2LjA4NCwgNC43NDc2XSwgWzQ2LjEwNDIsIDQuNzY0NV0sIFs0NS45NTMyLCA0LjczNDFdLCBbNDUuOTAzNCwgNC44MjIxXSwgWzQ2LjIxNSwgNS45NzQ3XSwgWzQ2LjM2MzcsIDUuOTg0OV0sIFs0Ni4yMTY3LCA1Ljk4N10sIFs0NS43MzEsIDUuNzc1XSwgWzQ1LjY3NiwgNS43MDAzXSwgWzQ1Ljc1NjMsIDUuNDgwOV0sIFs0NS44Nzk3LCA1LjM2MjFdLCBbNDUuODgyLCA1LjM0MzldLCBbNDUuNzcxNywgNS4xOTE1XSwgWzQ1Ljc5NjgsIDUuMTY3MV0sIFs0Ni40Mjc4LCA1LjMxOTJdLCBbNDYuNDk4MSwgNS4wMjA0XSwgWzQ2LjUxNTUsIDUuMTY3XSwgWzQ2LjQzMTUsIDUuMzE5NF0sIFs0Ni4zODI2LCA1LjM3NDJdLCBbNDYuMjY0NSwgNS41MTI5XSwgWzQ2LjI2NDMsIDUuNTE0NF0sIFs0Ni4yNjc1LCA1LjUzMDNdLCBbNDYuMjY2NSwgNS43NzUxXSwgWzQ2LjIwMjgsIDUuOTczM10sIFs0Ni4zMjk4LCA0Ljg1MzRdLCBbNDYuMzAxOSwgNC44MzQ4XSwgWzQ2LjE4OTEsIDQuNzgwMl0sIFs0Ni4zNTIzLCA1Ljk3ODFdLCBbNDYuMTIyNSwgNC43NzddLCBbNDYuMTg4NiwgNS45ODUyXSwgWzQ1Ljc3MTEsIDUuMTk3MV0sIFs0Ni4zODksIDYuMDMyM10sIFs0Ni40MDI2LCA2LjEwMjVdLCBbNDYuMzUyOCwgNi4xNTc1XSwgWzQ2LjMyNDgsIDYuMTMxNl0sIFs0Ni4yNzk2LCA2LjEwNF0sIFs0Ni4zMTE5LCA1Ljk0MzZdLCBbNDYuMDAyOCwgNS44MDk4XSwgWzQ1LjkzNzgsIDQuNzQwMl0sIFs0Ni4zMjg2LCA1Ljk1NTJdLCBbNDYuMzQ2OCwgNS45NzNdLCBbNDUuODExMiwgNS43ODYyXSwgWzQ1LjcwOSwgNS43NDA0XSwgWzQ1LjcxMDQsIDUuNzM3Nl0sIFs0NS42OTM1LCA1LjcwN10sIFs0NS42ODc4LCA1LjcwOThdLCBbNDUuNzU5MiwgNS40NzgyXSwgWzQ2LjA2MzEsIDUuODA3NV0sIFs0Ni41MTE2LCA1LjE2NzNdLCBbNDYuNDg4NiwgNS4wNzg5XSwgWzQ2LjQ5NDIsIDUuMDg3OV0sIFs0Ni40OTU5LCA1LjA4OTZdLCBbNDYuNTA0MiwgNS4xMzUyXSwgWzQ2LjQ4MTEsIDUuMjEzMV0sIFs0Ni40NTksIDUuMjM0NV0sIFs0Ni4zMTY5LCA1LjQ0MzJdLCBbNDYuMzUwNSwgNS4zNzYyXSwgWzQ2LjQ5NzgsIDUuMjAyNF0sIFs0Ni41MTcxLCA0Ljk0MjFdLCBbNDUuNzg1MiwgNS40NDg1XSwgWzQ2LjE0ODEsIDUuOTY3Ml0sIFs0Ni4yNjM4LCA1LjczMzddLCBbNDYuMDI0OSwgNS44MTI1XSwgWzQ2LjMyNjYsIDYuMTMzNF0sIFs0Ni4zMTc4LCA2LjEyNTldLCBbNDYuMzAzNiwgNi4xMTk3XSwgWzQ2LjAxMjUsIDUuODA3NF0sIFs0Ni4yMjE4LCA1Ljk5NzldLCBbNDYuMzA0MywgNS40NzA4XSwgWzQ1LjgzMjgsIDQuOTIwM10sIFs0NS45MDk4LCA0LjgxMDddLCBbNDUuOTEwMSwgNC44MTA1XSwgWzQ2LjA2MiwgNS44MDc2XSwgWzQ1LjkzNDgsIDQuNzU0Ml0sIFs0NS42NzQyLCA1LjU2MzldLCBbNDYuMzUwNSwgNS45NzUzXSwgWzQ1LjgyNDksIDUuNDI1Ml0sIFs0NS44NjM4LCA1LjM4ODhdLCBbNDYuNDYwNCwgNS4yNDFdLCBbNDYuNDY4MiwgNS4yMTk2XSwgWzQ2LjUwMjksIDUuMTM3Ml0sIFs0Ni4zMjAyLCA1LjQxMzNdLCBbNDYuNTA5MSwgNS4xMzU3XSwgWzQ2LjQ5MjMsIDUuMjEwNF0sIFs0Ni40ODE1LCA1LjIxMzRdLCBbNDYuNDU5NCwgNS4yNDY4XSwgWzQ2LjMyMDMsIDUuNjExMV0sIFs0Ni4yNjYsIDUuODcyXSwgWzQ2LjM1ODIsIDQuODUyNV0sIFs0Ni41MTE4LCA0Ljk0MDldLCBbNDYuMjE2MywgNS45ODg0XSwgWzQ2LjE3MTYsIDQuNzgyM10sIFs0NS44MzkyLCA1LjI5OThdLCBbNDYuMzcwMiwgNi4wMDA4XSwgWzQ2LjM3MDUsIDYuMDAyM10sIFs0Ni4zNzA4LCA2LjAwMjJdLCBbNDYuMzcyNCwgNi4wMDY3XSwgWzQ2LjM3MzIsIDYuMDA2N10sIFs0Ni4zNzQsIDYuMDA4NV0sIFs0Ni4zMzc0LCA1Ljk2NDNdLCBbNDYuMzc1LCA2LjAxMTNdLCBbNDYuMzc1OSwgNi4wMTI4XSwgWzQ2LjM3NjEsIDYuMDE0Nl0sIFs0NS42Njk5LCA1LjU3MDZdLCBbNDUuODA2MSwgNS4xMzkxXSwgWzQ2LjMyODUsIDYuMTM1Ml0sIFs0Ni4yODU1LCA2LjEwMzNdLCBbNDYuMjQ1NiwgNi4wODA0XSwgWzQ1Ljc5NzYsIDUuMjc0NV0sIFs0NS44MTA1LCA0LjkxNzZdLCBbNDYuMjg4MywgNS45MTI0XSwgWzQ1LjgyNDYsIDQuOTIwNl0sIFs0NS44NDgzLCA0LjkxMzNdLCBbNDUuOTEyNywgNC44NDc2XSwgWzQ2LjM0NjQsIDUuOTcyN10sIFs0NS45MzY5LCA0Ljc0ODVdLCBbNDUuODAwMSwgNS40MzI2XSwgWzQ1LjgwOTQsIDUuNzg2OF0sIFs0NS43Njg0LCA1Ljc4MjVdLCBbNDUuNzExNSwgNS43NTgxXSwgWzQ1LjcwOTIsIDUuNzI3NV0sIFs0NS42OTczLCA1LjcwNDZdLCBbNDUuNjkyNywgNS43MDc2XSwgWzQ1LjYyNzQsIDUuNjQ4M10sIFs0Ni4zNjQxLCA1LjM3N10sIFs0Ni4zOTc0LCA1LjMzNDJdLCBbNDYuMzczNywgNS4zNjYxXSwgWzQ2LjQyMzEsIDUuMzEyOF0sIFs0Ni4zMDg2LCA1LjQ3MzFdLCBbNDYuMzM1NSwgNS42NDk3XSwgWzQ2LjMxMjEsIDUuOTQ0XSwgWzQ2LjA5MjQsIDUuODkyMl0sIFs0NS44MDM2LCA1LjQyODFdLCBbNDUuODExNCwgNS4wODk3XSwgWzQ2LjQ0OTUsIDQuODk4Nl0sIFs0Ni4xNTIxLCA0LjgwMjVdLCBbNDYuMjY1NCwgNS44NzA4XSwgWzQ2LjMxMTMsIDUuOTIwOV0sIFs0NS44Mjc5LCA0LjkyMDFdLCBbNDYuMzU1NiwgNS45ODA0XSwgWzQ2LjM5OTMsIDYuMTE0M10sIFs0Ni4zMjA0LCA2LjEyNjVdLCBbNDYuMjk1NSwgNi4xMTg4XSwgWzQ2LjI2MTQsIDYuMTIwNV0sIFs0Ni4yMjM2LCA2LjAwNzVdLCBbNDYuMzMwNiwgNS42MzE0XSwgWzQ1Ljg1NzUsIDQuOTAxNF0sIFs0NS44MDA5LCA1LjI3NTZdLCBbNDUuODUyMiwgNS40MTMxXSwgWzQ2LjE1MDgsIDUuOTY4NV0sIFs0NS44NzI0LCA1LjgxMzJdLCBbNDUuODI4NywgNS43OTM1XSwgWzQ1Ljc0MjQsIDUuNzczOF0sIFs0Ni4zMzEyLCA1LjYzMjVdLCBbNDYuMzU4NSwgNS45ODE4XSwgWzQ2LjQwOCwgNi4wOTg4XSwgWzQ1LjcwNTMsIDUuNzQ3OV0sIFs0Ni41MTAxLCA1LjE4MDhdLCBbNDYuMzQ2NCwgNS40MTk5XSwgWzQ2LjM0NjEsIDUuNDIwMV0sIFs0Ni40ODQsIDUuMDU3MV0sIFs0Ni40ODkzLCA1LjA4XSwgWzQ2LjQ5NTEsIDUuMDkyMl0sIFs0Ni40OTc3LCA1LjA5MzldLCBbNDYuMzM1MywgNS40MTU0XSwgWzQ2LjQ1MDIsIDUuMjY5XSwgWzQ2LjMxNywgNS40Njg5XSwgWzQ2LjUwODMsIDQuOTYyOV0sIFs0Ni4zMzUyLCA2LjEzNzddLCBbNDYuMjQzNiwgNi4wNjU4XSwgWzQ2LjIzMjgsIDYuMDIzNF0sIFs0NS44MTQzLCA0LjkyMDFdLCBbNDUuOTg5OCwgNS44MDk2XSwgWzQ1Ljk4MzIsIDUuODE2OV0sIFs0NS45ODA3LCA1LjgyMTddLCBbNDUuOTcyLCA1LjgzNF0sIFs0NS45NzEzLCA1LjgzNF0sIFs0NS45NzA1LCA1LjgzMzldLCBbNDUuOTY5MywgNS44MzM4XSwgWzQ1Ljk2ODUsIDUuODMzOV0sIFs0NS45Njc1LCA1LjgzMzldLCBbNDUuOTU1LCA1LjgzNF0sIFs0Ni4zMjksIDUuOTU3MV0sIFs0NS44MTgyLCA1Ljc4NDZdLCBbNDUuNzA3NywgNS43NTU3XSwgWzQ1LjcwOTMsIDUuNzEyOV0sIFs0NS42NTA2LCA1LjY4ODVdLCBbNDUuNjcyNSwgNS41NTIyXSwgWzQ2LjQ4OTcsIDUuMjA4M10sIFs0Ni4zNDY1LCA1LjQyMTddLCBbNDYuMzQ2MiwgNS40MjA0XSwgWzQ2LjQzMjksIDUuMzE4MV0sIFs0Ni4yOCwgNS40NTgzXSwgWzQ2LjI3NDcsIDUuNDU2OF0sIFs0Ni4zMywgNS42MjkxXSwgWzQ2LjMzMTEsIDUuNjMyM10sIFs0Ni4xMjUxLCA1LjkxMTJdLCBbNDYuMDA4MSwgNS44MTA2XSwgWzQ2LjQ1NDMsIDQuOTA1Nl0sIFs0Ni40NzE2LCA0LjkxNjFdLCBbNDYuNTE0NSwgNC45NzExXSwgWzQ2LjA1MzEsIDQuNzQ2OF0sIFs0Ni4yNzA2LCA1Ljg2MzFdLCBbNDYuMTYwNSwgNC43OTg2XSwgWzQ2LjMxMjYsIDUuNjA3XSwgWzQ2LjI5MTIsIDUuNTYzNV0sIFs0NS42ODA2LCA1LjU1MThdLCBbNDYuMzk1MSwgNi4wMzc0XSwgWzQ2LjQxMzcsIDYuMDU0M10sIFs0Ni40MDg4LCA2LjA5ODJdLCBbNDYuMjgxNywgNi4xMDQ2XSwgWzQ2LjI1MjUsIDYuMTI0M10sIFs0Ni4wODgyLCA1Ljg1NDFdLCBbNDUuODE4NSwgNC45MjA0XSwgWzQ1Ljg3ODEsIDQuODldLCBbNDUuOTAyNywgNC44MDQ2XSwgWzQ1LjkzOTQsIDQuNzM0NF0sIFs0NS45ODU2LCA0Ljc0OThdLCBbNDUuNzk3OCwgNS4xMTE2XSwgWzQ2LjI2NSwgNS43Ml0sIFs0NS43MjIxLCA1Ljc2OTddLCBbNDUuNzA2OSwgNS43NDI1XSwgWzQ1LjY5NzcsIDUuNzA0Ml0sIFs0NS44NTgzLCA1LjMxNDJdLCBbNDUuNzgwMywgNS4xODc1XSwgWzQ1LjgwNTEsIDUuMTUxNl0sIFs0Ni40NDc5LCA1LjI4OF0sIFs0Ni4zOTQ1LCA1LjM2MjldLCBbNDYuNDk4OSwgNS4xMjQ5XSwgWzQ2LjUxNzgsIDUuMTY2XSwgWzQ2LjQ1NjIsIDUuMjUxNl0sIFs0Ni4yNzE2LCA1LjQ2MThdLCBbNDYuMzY1LCA1Ljk5MDldLCBbNDYuMTE5NSwgNS44OTRdLCBbNDYuMDk2OSwgNS44NDI4XSwgWzQ2LjAxNzcsIDUuODA4MV0sIFs0Ni40MjUxLCA0Ljg5MDVdLCBbNDYuNTE5MSwgNC45NDA4XSwgWzQ2LjE0NTksIDQuODAwNl0sIFs0Ni4zMTcsIDUuOTQ4MV0sIFs0NS44Njk3LCA1LjM3OF0sIFs0Ni40MDc1LCA2LjA1MDFdLCBbNDYuNDA5NCwgNi4wOTU3XSwgWzQ2LjMxMTMsIDYuMTE5OV0sIFs0Ni4zMDk1LCA2LjExOTldLCBbNDYuMzMzNSwgNS42MzUzXSwgWzQ2LjIyODksIDYuMDEzNV0sIFs0Ni4yMjY3LCA2LjAwODhdLCBbNDYuMDgwMiwgNC43NTUzXSwgWzQ2LjAxNTcsIDUuODA1NV0sIFs0NS44OTUxLCA0Ljg3NDldLCBbNDUuOTAzNSwgNC44NzIxXSwgWzQ1LjkxLCA0LjgzODVdLCBbNDYuMzE3OCwgNS40Njg1XSwgWzQ1LjcxMDUsIDUuNzAxN10sIFs0NS42NzcsIDUuNzAxN10sIFs0NS42ODczLCA1LjU3NV0sIFs0NS43MzAyLCA1LjUxODVdLCBbNDUuODA3MSwgNS40MjI2XSwgWzQ1Ljc3MTQsIDUuMjAwMl0sIFs0NS44MTIyLCA1LjEwNDFdLCBbNDYuNDM5MSwgNS4zMTYxXSwgWzQ2LjMyMzEsIDUuNDU5M10sIFs0Ni41MDM5LCA1LjE5OTldLCBbNDYuNTAyNywgNS4yMDAxXSwgWzQ2LjQ5MjksIDUuMjA5MV0sIFs0Ni4zMjIsIDUuNDM0OV0sIFs0Ni40MjksIDUuMzIzNl0sIFs0Ni4yNjY2LCA1LjQ4MDddLCBbNDYuMjk0NCwgNS41OTM1XSwgWzQ2LjMyNjMsIDUuNjEyMl0sIFs0Ni40NTY1LCA0LjkwOTRdLCBbNDYuMjA0MSwgNC43OTM2XSwgWzQ2LjMwNTMsIDQuODM3M10sIFs0Ni4zODEzLCA0Ljg3MDhdLCBbNDYuMzE3MywgNC44NDQ5XSwgWzQ2LjUxMDksIDQuOTVdLCBbNDYuMjI0LCA0Ljc5NzZdLCBbNDYuMjUzMywgNC44MTEzXSwgWzQ2LjE5NzEsIDQuNzg4Nl0sIFs0Ni41MTc2LCA0Ljk0MjVdLCBbNDYuMjI5NywgNC44MDA2XSwgWzQ2LjQ3NjUsIDQuOTE1MV0sIFs0Ni4zMDQzLCA1LjYwMTZdLCBbNDYuMzQxLCA2LjE0NDhdLCBbNDYuMzIzOSwgNi4xMzExXSwgWzQ2LjMwNzIsIDYuMTIwNF0sIFs0Ni4yNDE2LCA2LjA3MDNdLCBbNDYuMTc1NCwgNS45OTAxXSwgWzQ2LjI2NSwgNS44MDA2XSwgWzQ2LjMxODksIDUuOTQ4N10sIFs0NS44NzQxLCA0LjkwOV0sIFs0NS45MDQyLCA0Ljg2NjJdLCBbNDUuNzg5NCwgNS4yNjY5XSwgWzQ1LjkwNjIsIDQuODI4MV0sIFs0Ni4zNDcyLCA1Ljk3MjddLCBbNDUuOTM5MSwgNC43NzQ4XSwgWzQ2LjEwMjIsIDUuODIwN10sIFs0NS45NDk1LCA1LjgzMzJdLCBbNDUuODUxNywgNS40MTM5XSwgWzQ2LjI5NTYsIDUuNDY3NF0sIFs0Ni4zNTg3LCA1Ljk4MTZdLCBbNDUuODY2NiwgNS4zODE4XSwgWzQ1LjgxMiwgNS4wOTM5XSwgWzQ1LjgxMjMsIDUuMDg2XSwgWzQ2LjQ0NzcsIDUuMjc2OF0sIFs0Ni4zOTY0LCA1LjM1M10sIFs0Ni4zODIyLCA1LjM3NzRdLCBbNDYuNTA0OCwgNS4yMDM2XSwgWzQ2LjQ3NDUsIDUuMjE1OF0sIFs0Ni40MDE3LCA1LjMyNzFdLCBbNDYuNTAyMywgNS4xMzY2XSwgWzQ2LjUwNzgsIDUuMTUwMV0sIFs0Ni40MzMzLCA1LjMxNzldLCBbNDYuNDIzNywgNS4zMDg1XSwgWzQ2LjMxMTgsIDQuODQxMl0sIFs0Ni40NjIyLCA0LjkxNDRdLCBbNDYuNTEzNCwgNC45NTM4XSwgWzQ2LjE5MzcsIDQuNzg0N10sIFs0Ni4wNTgyLCA0Ljc1NThdLCBbNDYuMDgyNSwgNC43NDk2XSwgWzQ1LjgwNjgsIDUuMDA3XSwgWzQ2LjA5MjMsIDUuODIyN10sIFs0Ni40MDYxLCA2LjA0OTJdLCBbNDYuMzI2MSwgNi4xMzI5XSwgWzQ2LjI5MDYsIDYuMTEwMl0sIFs0Ni4yNzM0LCA2LjExMTddLCBbNDYuMjQyMSwgNi4wNzE5XSwgWzQ2LjIzMTYsIDYuMDE4Nl0sIFs0Ni4zNTgzLCA1Ljk4MThdLCBbNDYuMjYzNywgNS44MTI5XSwgWzQ1Ljg0NjQsIDUuMzAxNF0sIFs0Ni4zNDU2LCA1Ljk3MjFdLCBbNDUuNzk4NCwgNS4xMTM5XSwgWzQ1Ljc2MjcsIDUuNDc0OF0sIFs0Ni40NjMyLCA1LjIzMTNdLCBbNDYuNDk2NiwgNS4wMjI0XSwgWzQ2LjQ4NTYsIDUuMDYzN10sIFs0Ni41MDI5LCA1LjEzMDddLCBbNDYuNDc3MywgNS4yMTI5XSwgWzQ2LjQ0NTYsIDUuMzA2Ml0sIFs0Ni4yNjkxLCA1LjQ5MzVdLCBbNDYuMjY0NCwgNS41MTc5XSwgWzQ2LjM1ODEsIDUuOTgxNV0sIFs0Ni4yMjAzLCA1Ljk5MTddLCBbNDYuMzkwMSwgNC44Nzc5XSwgWzQ2LjQ0LCA0Ljg5MThdLCBbNDUuNjcyNCwgNS41NTY2XSwgWzQ2LjEyNDEsIDQuNzc4OF0sIFs0NS43Nzc0LCA1LjI0MDJdLCBbNDYuMTA0MywgNS44MjA0XSwgWzQ2LjE3MzgsIDUuOTg0XSwgWzQ2LjMwNzIsIDUuNzE1MV0sIFs0Ni4zNDE4LCA1Ljk2NjRdLCBbNDYuMzYwNSwgNi4xNjIzXSwgWzQ2LjM1MzMsIDYuMTU3OF0sIFs0Ni4zMjMyLCA2LjEzMDJdLCBbNDYuMjU1MSwgNi4xMjEyXSwgWzQ2LjI3MjQsIDUuNzE5XSwgWzQ2LjI0NjgsIDYuMDg0Nl0sIFs0Ni4yMzA4LCA2LjAxMjldLCBbNDYuMjI4NSwgNi4wMDk5XSwgWzQ1Ljg3NjgsIDUuMzY3XSwgWzQ1Ljc4MzUsIDUuMjUzOF0sIFs0NS44MDcxLCA1LjAyMDhdLCBbNDUuODc4MSwgNC44OTEyXSwgWzQ2LjM2NywgNS45OTQ2XSwgWzQ2LjE3ODQsIDUuOTkxNl0sIFs0NS45MzY0LCA0Ljc4MDFdLCBbNDUuODA5MywgNS4xMjldLCBbNDUuNzg3OCwgNS43ODM1XSwgWzQ1Ljc0NDMsIDUuNzgzNV0sIFs0NS42OTcsIDUuNTcwMV0sIFs0Ni4zMDk4LCA1LjcwODddLCBbNDUuNzQzNSwgNS40OTg2XSwgWzQ1Ljg0MDgsIDUuNDE3N10sIFs0NS44NTI3LCA1LjQxMTddLCBbNDYuNTA3NCwgNS4xNTA5XSwgWzQ2LjQwMTUsIDUuMzQxNl0sIFs0Ni40NTgxLCA1LjI0ODNdLCBbNDYuNDQzNCwgNS4zMTQyXSwgWzQ2LjQyMDksIDUuMzA3OF0sIFs0Ni4yNjg0LCA1LjQ2OTZdLCBbNDYuMjY1MSwgNS41MTA1XSwgWzQ2LjMyNDgsIDUuOTUyN10sIFs0Ni4yMDM3LCA1Ljk3MjZdLCBbNDYuMTA3OSwgNS44ODUzXSwgWzQ2LjUwMzksIDQuOTQ2OV0sIFs0Ni41MTQsIDQuOTY4NV0sIFs0Ni4wNjE5LCA0Ljc1OTZdLCBbNDYuMDc0MSwgNC43NTk0XSwgWzQ2LjA4MjgsIDQuNzQ4OV0sIFs0Ni4zMjI1LCA1LjQ2NDVdLCBbNDYuMzQ2NywgNS45NzJdLCBbNDYuMzIzNCwgNS42NDhdLCBbNDUuODI1NiwgNS4yOTI4XSwgWzQ2LjMxNDEsIDUuNjA1OF0sIFs0Ni4zMzkxLCA2LjEzOTldLCBbNDYuMzIwMiwgNi4xMjYyXSwgWzQ2LjI0MDcsIDYuMTA2M10sIFs0Ni4yMzc1LCA2LjEwMThdLCBbNDYuMTQ1MSwgNS45NjQ4XSwgWzQ2LjUwOTEsIDUuMTkzOF0sIFs0Ni4wNzU0LCA1LjgxMTNdLCBbNDYuMjY3MSwgNS43NjE1XSwgWzQ1LjgwNjMsIDQuOTIyMV0sIFs0NS44Njg3LCA0LjkwODRdLCBbNDUuOTY2NSwgNC43NTE3XSwgWzQ2LjI2ODMsIDUuNTM3XSwgWzQ1Ljg5MzgsIDUuODIyMV0sIFs0NS44MywgNS43OTZdLCBbNDUuNjgzMiwgNS41NDldLCBbNDUuNjk3MywgNS41NDZdLCBbNDUuODA3MSwgNS40MjI1XSwgWzQ1LjgzLCA1LjI5Nl0sIFs0Ni40MjE1LCA1LjMwNjZdLCBbNDYuNDg2NCwgNS4wNTA4XSwgWzQ2LjUwNzUsIDUuMl0sIFs0Ni41MDEyLCA1LjIwMDJdLCBbNDYuMzc1MywgNS4zNjkxXSwgWzQ2LjQ2ODMsIDUuMjE1Ml0sIFs0Ni4zMTM1LCA1LjQwNDJdLCBbNDYuMzE4NiwgNS40NDU1XSwgWzQ2LjMzNzIsIDUuNDAyOV0sIFs0Ni4zNDA4LCA1LjY0MDddLCBbNDYuMzU2MywgNC44NTE1XSwgWzQ2LjQ0NjgsIDQuODk1Nl0sIFs0Ni4yNjEsIDQuODExN10sIFs0Ni4wODY2LCA1Ljg3MDRdLCBbNDYuMTcwOSwgNS45ODY4XSwgWzQ1LjgwMiwgNS4xMTQ0XSwgWzQ2LjA4LCA0Ljc1NTRdLCBbNDYuMTMwOSwgNC43ODc1XSwgWzQ2LjA4NTQsIDUuODY1NV0sIFs0Ni4yNjgyLCA1LjQ4OTVdLCBbNDYuMzgxOCwgNi4wMTk5XSwgWzQ2LjM5MjUsIDYuMDM2Nl0sIFs0Ni4zOTY3LCA2LjExNDNdLCBbNDYuMjk1OCwgNi4xMTg4XSwgWzQ2LjI3NTcsIDYuMTA4MV0sIFs0Ni4yNjI3LCA2LjExOV0sIFs0Ni4yMzkxLCA2LjA5ODldLCBbNDYuMjQ2MiwgNi4wODM3XSwgWzQ2LjIzMDcsIDYuMDE1Ml0sIFs0NS43ODcxLCA1LjE4MjddLCBbNDUuNzk0OCwgNS4xNzQzXSwgWzQ1LjgwNzQsIDUuMDA2XSwgWzQ1LjgyMiwgNC45MTk2XSwgWzQ1LjYyMzQsIDUuNjE2N10sIFs0NS42NzI2LCA1LjU2MTddLCBbNDUuNjk5NywgNS41NTg1XSwgWzQ1Ljg1OTksIDUuMzE3OV0sIFs0NS43ODgzLCA1LjE4MjJdLCBbNDYuMjk5OCwgNS45MTY2XSwgWzQ2LjQzMDcsIDUuMzE5NV0sIFs0Ni40ODU1LCA1LjA2OTVdLCBbNDYuNTA3NiwgNS4xNjU0XSwgWzQ2LjMxODQsIDUuNDEzN10sIFs0Ni4zMzE0LCA1LjQxNTRdLCBbNDYuNDI4MiwgNS4zMjRdLCBbNDYuNDAzNywgNS4zMjI1XSwgWzQ2LjI2NzIsIDUuNDgzOV0sIFs0Ni4yNjgxLCA1LjQ5MThdLCBbNDYuMjY4NCwgNS41MDA2XSwgWzQ2LjM4OTksIDQuODc3N10sIFs0Ni40MTE3LCA0Ljg4ODJdLCBbNDYuMzM5LCA1Ljk2NTddLCBbNDUuNjc3NywgNS41NTQ1XSwgWzQ1LjgwOTQsIDUuMDYyM10sIFs0Ni4zNzgzLCA2LjE2MDRdLCBbNDYuMzQwNSwgNi4xNDA3XSwgWzQ2LjI5NDMsIDYuMTE3Nl0sIFs0Ni4yNzMxLCA2LjExMThdLCBbNDYuMjU4MiwgNi4xMjI1XSwgWzQ2LjI0MjEsIDYuMDcyMl0sIFs0Ni4yNDIyLCA2LjA2NzNdLCBbNDYuMjIyMSwgNi4wMDM1XSwgWzQ2LjMyNjIsIDUuOTUzNF0sIFs0Ni4zMjQ3LCA1LjY2NDhdLCBbNDUuNjcxMywgNS42OTI0XSwgWzQ1Ljc3MzgsIDUuMjM0XSwgWzQ1Ljg5NDUsIDQuODc0M10sIFs0NS45MjIzLCA0Ljc5OTRdLCBbNDUuODk4NywgNS44MjQyXSwgWzQ1LjcwOTQsIDUuNzI4MV0sIFs0NS42MjMsIDUuNjM4NF0sIFs0NS42MjA2LCA1LjYzNjddLCBbNDUuNjg2OCwgNS41NDU1XSwgWzQ1LjY5OTEsIDUuNTVdLCBbNDUuODc4NywgNS4zNjRdLCBbNDYuMzE1MSwgNS40MzcxXSwgWzQ2LjMxNzksIDUuNDQzM10sIFs0Ni40OTcsIDUuMDkyNV0sIFs0Ni41MDc2LCA1LjIwMjVdLCBbNDYuMzc0NCwgNS4zNjcxXSwgWzQ2LjI2NDMsIDUuNDczN10sIFs0Ni4yNjg2LCA1LjUwMTFdLCBbNDYuMjY4OCwgNS41MDEzXSwgWzQ2LjMyMzEsIDUuNjcwNF0sIFs0Ni4zMTkyLCA1LjY3NDldLCBbNDYuMjMyMiwgNC44MDMzXSwgWzQ2LjQxNzQsIDQuODg4N10sIFs0Ni41MTI4LCA0Ljk2MzZdLCBbNDUuODUyLCA1LjMwNzRdLCBbNDYuMjkyNiwgNS41NzUyXSwgWzQ2LjEyODQsIDUuOTI1Nl0sIFs0Ni4yODk4LCA1LjQ2MV0sIFs0Ni4xNzU2LCA0Ljc4MDRdLCBbNDYuMzY2NCwgNS45OTM0XSwgWzQ1LjgyOTEsIDUuMjk1Ml0sIFs0Ni4yNzExLCA1LjUwMjVdLCBbNDYuMDEwMywgNS44MTA4XSwgWzQ2LjM3OTMsIDYuMDE3NV0sIFs0Ni4zODU2LCA2LjAyODJdLCBbNDYuNDA1MSwgNi4wNDgxXSwgWzQ2LjMzNzcsIDYuMTM5NV0sIFs0Ni4yNjYzLCA2LjExNTFdLCBbNDYuMjUyMSwgNi4xMjQxXSwgWzQ2LjIzMTcsIDYuMDQ1MV0sIFs0Ni4yMjkyLCA2LjAxXSwgWzQ2LjA4NTYsIDUuODE3M10sIFs0NS44MzQxLCA0LjkxODddLCBbNDUuOTA3MywgNC44MzE4XSwgWzQ1LjkyMTYsIDQuODA1OV0sIFs0Ni4zNTQxLCA1Ljk3OTddLCBbNDUuODA4NSwgNS4wMzgxXSwgWzQ1Ljk0MTMsIDQuNzMxNF0sIFs0NS44NjExLCA1LjgwNzhdLCBbNDYuMjY3OCwgNS40ODc1XSwgWzQ1LjgxMDQsIDUuNzg2Nl0sIFs0Ni4yNjE3LCA1Ljg1MDhdLCBbNDUuNzA4NywgNS43MjU2XSwgWzQ2LjA4NTYsIDUuODU4Nl0sIFs0NS42MzgxLCA1LjY2NzhdLCBbNDYuNDQ5OSwgNS4yNTc2XSwgWzQ2LjQ0OSwgNS4yNzNdLCBbNDYuNDg0NywgNS4yMTMzXSwgWzQ2LjQ4NjUsIDUuMDQ4OV0sIFs0Ni40OTQyLCA1LjEwMzddLCBbNDYuNDg2MiwgNS4yMDc1XSwgWzQ2LjMxMDMsIDUuNDc0Ml0sIFs0Ni4yNjgxLCA1LjUwMDFdLCBbNDYuMjY0MiwgNS41MTUzXSwgWzQ2LjI3OTMsIDUuNTUzMl0sIFs0Ni4zODQ3LCA0Ljg3MzhdLCBbNDYuMzE5MywgNC44NDY2XSwgWzQ2LjM0NTYsIDUuOTcxM10sIFs0NS44Nzk1LCA1LjMzOThdLCBbNDYuMzY2NSwgNi4xNzAyXSwgWzQ1Ljg5MzUsIDQuODcyMV0sIFs0NS45NDQzLCA0LjcyODddLCBbNDUuODgzNiwgNS4zNTI0XSwgWzQ1Ljg1NjcsIDUuMzExNV0sIFs0NS43OTM0LCA1LjE3NzFdLCBbNDUuODA5NSwgNS4wNjQzXSwgWzQ2LjMxODUsIDUuNDQ3MV0sIFs0Ni40NzA0LCA1LjIxNTVdLCBbNDYuNDE3LCA1LjMwMjRdLCBbNDYuNDUwNiwgNS4yNjI0XSwgWzQ2LjUwMTIsIDUuMjAwMV0sIFs0Ni40Nzk0LCA1LjIxMDhdLCBbNDYuMjY4MywgNS40OTI3XSwgWzQ2LjMyNDgsIDUuNjY2NV0sIFs0Ni4yNzE3LCA1LjcxOTddLCBbNDYuMjYxNCwgNS43MjldLCBbNDYuMzAwMSwgNC44MzMyXSwgWzQ2LjMwOTcsIDUuOTM1Nl0sIFs0Ni4zMzYzLCA1Ljk2MTldLCBbNDYuMTE5NiwgNS44OTQ4XSwgWzQ2LjE2NywgNC43ODU3XSwgWzQ2LjE3MjEsIDUuOTg5MV0sIFs0Ni4yNjYxLCA1Ljc4NzZdLCBbNDYuNTAxNCwgNS4yMDE0XSwgWzQ2LjMyODIsIDYuMTM0M10sIFs0Ni4zMDY4LCA1LjkxOTldLCBbNDUuODEwMSwgNS4wMDEyXSwgWzQ2LjMyMzgsIDUuOTUyMl0sIFs0NS44MDE0LCA1Ljc4NTldLCBbNDUuNjM0NiwgNS42NV0sIFs0NS42OTEsIDUuNTYxNl0sIFs0NS43Mzg0LCA1LjUwNTVdLCBbNDUuNzY2NywgNS40NzA0XSwgWzQ1LjgzMDYsIDUuMjk2NF0sIFs0Ni40MzgzLCA1LjMxNjRdLCBbNDYuNDIxMiwgNS4zMDddLCBbNDYuNTA4NiwgNS4wMDk5XSwgWzQ2LjQ5NzEsIDUuMTE4Ml0sIFs0Ni41MDM1LCA1LjEzNjZdLCBbNDYuNTE0LCA1LjE2NjhdLCBbNDYuNDY4MiwgNS4yMTg2XSwgWzQ2LjQ2ODUsIDUuMjI1XSwgWzQ2LjQyNCwgNS4zMTMyXSwgWzQ2LjMyNDcsIDUuNjY2OF0sIFs0Ni40Mjc1LCA0Ljg5MTVdLCBbNDYuNTA5NiwgNC45NDQ2XSwgWzQ2LjUwOSwgNC45NDQ4XSwgWzQ2LjUwODksIDQuOTcwNV0sIFs0Ni4xMDEzLCA1LjgyMjVdLCBbNDYuNCwgNi4xMTMyXSwgWzQ2LjM0MTMsIDYuMTQzNl0sIFs0Ni4yODY2LCA1LjU2MTZdLCBbNDYuMzI0NSwgNi4xMzE0XSwgWzQ2LjI2NjUsIDYuMTE0OV0sIFs0Ni4wMzM5LCA0Ljc0NjFdLCBbNDUuODExNSwgNC45MTgzXSwgWzQ1LjgzMjcsIDQuOTIxNV0sIFs0NS45MDc3LCA0LjgzMzFdLCBbNDUuOTIzNiwgNC43ODldLCBbNDYuMjkzNywgNS45MTY1XSwgWzQ1Ljk1MTEsIDUuODM1XSwgWzQ2LjMzNDUsIDUuOTYwMV0sIFs0NS43NzI1LCA1Ljc4M10sIFs0NS43MDc0LCA1Ljc0MTldLCBbNDUuNjUyOSwgNS42MDE3XSwgWzQ1LjY4NTQsIDUuNTcyNl0sIFs0NS43MDMzLCA1LjU1MjldLCBbNDYuNDU4NiwgNS4yNDhdLCBbNDYuMzcyLCA1LjM2MzhdLCBbNDYuNDE2NSwgNS4zMDNdLCBbNDYuNDU5MSwgNS4yMzczXSwgWzQ2LjM2NDcsIDUuMzc0NV0sIFs0Ni40OTc2LCA1LjEyXSwgWzQ2LjUwODIsIDUuMTQyOV0sIFs0Ni41MTc3LCA1LjE2NThdLCBbNDYuNDQ0OCwgNS4zMTVdLCBbNDYuMjk1OCwgNS41OTU4XSwgWzQ2LjQ0ODgsIDQuODk3OF0sIFs0Ni41MDk4LCA0Ljk2NzhdLCBbNDYuNTExMywgNC45NTI2XSwgWzQ2LjUwODIsIDQuOTYzNV0sIFs0Ni4xMjg1LCA1LjkzODRdLCBbNDYuMDQxMiwgNC43NDIyXSwgWzQ2LjI4NDksIDUuOV0sIFs0Ni4zMjAxLCA1Ljk1MDNdLCBbNDYuMzk3NiwgNi4wNDA1XSwgWzQ2LjMxNzMsIDYuMTI0NF0sIFs0Ni4yNzI0LCA2LjExMzVdLCBbNDYuMjUxMiwgNi4xMjQ0XSwgWzQ1Ljc5NTUsIDUuMTY3N10sIFs0NS44NDYsIDQuOTE0M10sIFs0NS44NTUxLCA0LjkwMzZdLCBbNDUuOTAwNiwgNC44MTUyXSwgWzQ2LjM0NTgsIDUuOTcwN10sIFs0NS45MDYsIDQuODA5XSwgWzQ1LjkyOTQsIDQuNzg0OF0sIFs0Ni4zMTI3LCA1Ljk0NTRdLCBbNDYuMjIxNCwgNS45OTk0XSwgWzQ1LjkxNjksIDUuODI5M10sIFs0NS42NzQ5LCA1LjY5ODFdLCBbNDUuNjUzNiwgNS42ODc2XSwgWzQ1LjYzNTUsIDUuNjUxXSwgWzQ1LjY4NDQsIDUuNTcwM10sIFs0NS44MjQ0LCA1LjQzMjldLCBbNDUuODA3NywgNS4wMjE1XSwgWzQ2LjMyMzYsIDUuNDM0M10sIFs0Ni41MDQyLCA1LjIwMTRdLCBbNDYuNTAyMywgNS4yMDEyXSwgWzQ2LjQ2ODksIDUuMjIyNl0sIFs0Ni40NDg5LCA1LjI4ODFdLCBbNDYuNDMyMSwgNS4zMTg1XSwgWzQ2LjM5ODUsIDUuMzM1NF0sIFs0Ni4zMTQ4LCA1LjQwNDFdLCBbNDYuNDkxOSwgNS4wMjg5XSwgWzQ2LjQ4NTcsIDUuMDUxOF0sIFs0Ni41MTUxLCA0Ljk4NV0sIFs0Ni4yMDE5LCA0Ljc5MzJdLCBbNDYuMDEyOCwgNC43NDcyXSwgWzQ2LjEyMzMsIDQuNzc4XSwgWzQ2LjEzMDUsIDQuNzg3XSwgWzQ2LjQwMzIsIDUuMzI5XSwgWzQ2LjI2NjMsIDUuNzc1OF0sIFs0Ni4zMzcxLCA1Ljk2MjhdLCBbNDYuMzc5NiwgNi4xNTgzXSwgWzQ2LjM1NTYsIDYuMTU4M10sIFs0Ni4yOTc4LCA2LjEyMDJdLCBbNDYuMjM5OCwgNi4xMDkzXSwgWzQ2LjI0MzUsIDYuMDY1Ml0sIFs0Ni4yMjg3LCA2LjAxMTddLCBbNDYuMTg3LCA1Ljk5MTldLCBbNDYuMzEwMSwgNS42ODgyXSwgWzQ2LjMxMjIsIDUuOTIxOF0sIFs0Ni4xNzE0LCA1Ljk4MTNdLCBbNDUuODA2NywgNC45MTkzXSwgWzQ1Ljg3MDIsIDQuOTA4NF0sIFs0NS44OTQ2LCA0Ljg3Ml0sIFs0NS45MDUxLCA0Ljg2MjhdLCBbNDUuODk3NiwgNC44MTA4XSwgWzQ1LjkwODksIDQuODEwOF0sIFs0Ni4wMTUxLCA1LjgwNTRdLCBbNDUuOTIwNSwgNS44MjgxXSwgWzQ1Ljg2NzcsIDUuODExMl0sIFs0NS43NDg4LCA1Ljc4MzhdLCBbNDYuMTc2OSwgNS45OTIzXSwgWzQ1LjY3MjUsIDUuNjkzOV0sIFs0NS42NjYyLCA1LjY4NDldLCBbNDUuNjUxNSwgNS42MDI3XSwgWzQ2LjQ3NjUsIDUuMjEyNF0sIFs0Ni40MDEsIDUuMzMxMl0sIFs0Ni4zMTY0LCA1LjQwNDJdLCBbNDYuNDg1NSwgNS4wNjldLCBbNDYuNTA4NywgNS4xMzc3XSwgWzQ2LjUxMjcsIDUuMTc0MV0sIFs0Ni40NDYsIDUuMzEzXSwgWzQ2LjI3MDUsIDUuNTA0OF0sIFs0Ni4zMDE5LCA1LjcxNjddLCBbNDYuMjY2NSwgNS43NTMzXSwgWzQ2LjM4LCA0Ljg2OTddLCBbNDYuNTExNSwgNC45NDU3XSwgWzQ2LjA1ODIsIDUuODEzNl0sIFs0Ni4xNjM3LCA1Ljk3ODFdLCBbNDYuNDA1NywgNi4wNDg2XSwgWzQ2LjM3NDcsIDYuMTYxNl0sIFs0Ni4yNzcsIDUuNTQ5NF0sIFs0Ni4yNTI3LCA2LjEyMzVdLCBbNDYuMjM3MiwgNi4wNTE4XSwgWzQ2LjI3NDEsIDUuODgyOF0sIFs0NS44MjUxLCA1LjQzNV0sIFs0NS42OTY5LCA1LjU3MTJdLCBbNDUuODEyMywgNS4wODU2XSwgWzQ1Ljg1NDksIDQuOTAyN10sIFs0NS44NjAzLCA0LjkwMTJdLCBbNDUuOTIyMSwgNC44MDIxXSwgWzQ2LjEwMzYsIDUuODI0M10sIFs0NS44NjU1LCA1LjM4NDJdLCBbNDUuOTgzMywgNC43NTAzXSwgWzQ2LjMzNjgsIDUuOTYyM10sIFs0NS43Mzg3LCA1Ljc3MDZdLCBbNDUuNzMwNiwgNS43NzUzXSwgWzQ1Ljg0MDEsIDUuNDE4M10sIFs0NS44NTY2LCA1LjQwNDhdLCBbNDUuODI4NywgNS4yOTQ4XSwgWzQ1Ljc5ODcsIDUuMTYzOF0sIFs0Ni4zNTg0LCA1LjM3NThdLCBbNDYuNDQ3MywgNS4yOTk2XSwgWzQ2LjUwNzYsIDUuMTQ4NV0sIFs0Ni40OTI4LCA1LjIwOTddLCBbNDYuMzk5NiwgNS4zMzYyXSwgWzQ2LjM3NTcsIDUuMzY5Nl0sIFs0Ni4yODE1LCA1LjU1NzFdLCBbNDYuMjk4NCwgNS41OTg0XSwgWzQ2LjMwOTMsIDUuNjAyOV0sIFs0Ni4zNDQsIDUuNjQyN10sIFs0Ni41MDA1LCA0Ljk1MjRdLCBbNDYuMzAyMSwgNC44MzQ5XSwgWzQ2LjQ0MjYsIDQuODkyOV0sIFs0Ni40OTYyLCA0LjkyNV0sIFs0Ni4xMzY3LCA1Ljk2NTZdLCBbNDYuMTAwNiwgNS44MjNdLCBbNDYuMDgzMywgNS44MTc5XSwgWzQ1Ljc5MzEsIDUuMTc3NV0sIFs0Ni4wNjg4LCA0Ljc2MTddLCBbNDYuMjE2MSwgNS45NzY2XSwgWzQ2LjM4NTUsIDYuMTM5Ml0sIFs0Ni4yODUxLCA2LjEwMjZdLCBbNDYuMjIwNywgNi4wMDE4XSwgWzQ2LjI2NDMsIDUuNzE5N10sIFs0Ni4xNTMxLCA1Ljk3MDZdLCBbNDYuMTA0MiwgNS44MjYyXSwgWzQ1Ljc5NzksIDUuMTEwMl0sIFs0NS44ODIxLCA1LjM1NjJdLCBbNDUuODE0MSwgNC45MTk5XSwgWzQ2LjMwNzYsIDUuOTE3MV0sIFs0NS45MDAxLCA0LjgxMzNdLCBbNDUuOTExNSwgNC44MTAzXSwgWzQ2LjEwMDQsIDUuODQxNV0sIFs0NS45MjMyLCA1LjgyNTddLCBbNDUuNjM5NywgNS42MDY1XSwgWzQ1LjY3MjEsIDUuNTU2Ml0sIFs0NS44MjU0LCA1LjQzNTVdLCBbNDUuODgwNSwgNS4zNDA5XSwgWzQ1Ljc5MTEsIDUuMjY5NF0sIFs0NS44MDYsIDUuMTQ5MV0sIFs0Ni40OTc3LCA1LjIwMjVdLCBbNDYuNDkzNCwgNS4xMDQ5XSwgWzQ2LjUwMjQsIDUuMTM3XSwgWzQ2LjUwODcsIDUuMTY1N10sIFs0Ni4zNDgsIDUuOTczN10sIFs0Ni4xMzA4LCA1Ljk1MzhdLCBbNDYuMjg0NCwgNS45MDc1XSwgWzQ2LjEwMzEsIDUuODE5Nl0sIFs0Ni4zNjU3LCA1Ljk5MTddLCBbNDYuMDU0MywgNS44MTM2XSwgWzQ2LjI4MTIsIDUuNzE0NF0sIFs0Ni4wMTgyLCA0Ljc0NF0sIFs0Ni4zOTEzLCA1LjM1ODhdLCBbNDYuMzY0NiwgNS45ODk2XSwgWzQ2LjE5NiwgNS45NjY3XSwgWzQ1Ljc5MzQsIDUuMjcyMV0sIFs0Ni4wOTA3LCA1Ljg1MDRdLCBbNDUuODA5NywgNS4xMDQ4XSwgWzQ2LjIxNjcsIDUuOTg1N10sIFs0Ni4zMDk1LCA1LjQ3MzldLCBbNDYuMzk5MiwgNi4xMDYxXSwgWzQ2LjMyODcsIDYuMTM1XSwgWzQ2LjMxOTksIDUuOTUwM10sIFs0Ni4zMDgzLCA2LjExOTZdLCBbNDYuMjY4OSwgNi4xMTE5XSwgWzQ2LjI0NTEsIDYuMDYxNl0sIFs0Ni4yMzMzLCA2LjA0MjFdLCBbNDYuMTYxNywgNS45NzY2XSwgWzQ2LjA4OTIsIDUuODIwOV0sIFs0Ni41MTIyLCA1LjE3NDhdLCBbNDYuMTg3NiwgNS45OTExXSwgWzQ1LjgzNywgNC45MTg3XSwgWzQ1LjkwMjEsIDQuODE4M10sIFs0NS45NzY3LCA0Ljc1NDFdLCBbNDYuMzE2OSwgNS42ODM3XSwgWzQ1LjcwNzksIDUuNzE4MV0sIFs0NS42OTYyLCA1LjcwNTddLCBbNDUuNzgxLCA1LjQ1NzRdLCBbNDUuODIwNSwgNS40MjA2XSwgWzQ1Ljg3MzUsIDUuMzczNV0sIFs0NS44MzAzLCA1LjQzNTRdLCBbNDYuMjgsIDUuODg5M10sIFs0Ni40NjksIDUuMjIxMl0sIFs0Ni40OTA3LCA1LjIxMDVdLCBbNDYuNDQ5NSwgNS4yNzI4XSwgWzQ2LjQ4NzcsIDUuMDQ3NF0sIFs0Ni41MDA2LCA1LjEyOTZdLCBbNDYuNTExOSwgNS4wMDE0XSwgWzQ2LjI2NDYsIDUuNTA5MV0sIFs0Ni4yODYxLCA1LjcxNjVdLCBbNDYuMjYzOCwgNS43MzM0XSwgWzQ2LjI2NjUsIDUuNzU3Nl0sIFs0Ni4zODUsIDQuODc0XSwgWzQ2LjI2MDksIDQuODExNV0sIFs0Ni4xMTY2LCA0Ljc3MTddLCBbNDYuMTMzMSwgNC43ODk5XSwgWzQ1LjY4MTksIDUuNTUwM10sIFs0Ni4xMjg2LCA1LjkzN10sIFs0NS43NzgyLCA1LjQ2MDZdLCBbNDUuODExNywgNS4wNTM5XSwgWzQ2LjQxNzUsIDYuMDYwNl0sIFs0Ni4zOTY5LCA2LjExODZdLCBbNDYuMzEwNywgNi4xMTk5XSwgWzQ2LjEyODEsIDUuOTI5NF0sIFs0Ni4yOTM4LCA1LjkxNjJdLCBbNDUuODI4NiwgNC45MjA5XSwgWzQ1LjgzMzcsIDQuOTE5Ml0sIFs0NS45MDIzLCA0LjgyMDFdLCBbNDUuOSwgNC44MDMyXSwgWzQ1LjcxNzksIDUuNzYyN10sIFs0NS42NzUyLCA1LjY5ODddLCBbNDUuNjU5OSwgNS41ODc0XSwgWzQ1Ljg3NDcsIDUuMzM1N10sIFs0NS43OTUyLCA1LjE2NzldLCBbNDUuODAyMywgNS4xNjA0XSwgWzQ1LjgxMTEsIDUuMTI1NV0sIFs0Ni40MTY0LCA1LjMxNDRdLCBbNDYuMzIxNCwgNS40MTM1XSwgWzQ2LjQ5OTIsIDUuMjAzM10sIFs0Ni40MDAyLCA1LjM0MzNdLCBbNDYuNDU4LCA1LjIzNV0sIFs0Ni40NjY0LCA1LjIyNzVdLCBbNDYuNDk1NCwgNS4xMDI1XSwgWzQ2LjI3MTcsIDUuNDY2OF0sIFs0Ni4zNDQ3LCA1LjY0MzhdLCBbNDYuMzE4OSwgNS42NzU1XSwgWzQ2LjUxNTEsIDQuOTc3OV0sIFs0Ni4xMDYsIDUuODMyM10sIFs0Ni4wMDQyLCA0Ljc0OTFdLCBbNDUuODA5OCwgNC45OTg2XSwgWzQ1LjgwODIsIDQuOTkzOV0sIFs0NS44MDU0LCA0Ljk4MTZdLCBbNDUuODA1NiwgNC45OF0sIFs0NS44MDczLCA0Ljk3NDJdLCBbNDUuODA3MiwgNC45NzI0XSwgWzQ1LjgwODEsIDQuOTM5Ml0sIFs0Ni4yMTYxLCA1Ljk4OTRdLCBbNDUuODA3NCwgNC45Mzc0XSwgWzQ1LjgwNDEsIDQuOTI1M10sIFs0NS44MDgzLCA1LjI4MzhdLCBbNDYuMzgxNCwgNi4wMl0sIFs0Ni4zMzg5LCA2LjEzODhdLCBbNDYuMjY1NCwgNi4xMTg5XSwgWzQ2LjI1NzksIDYuMTIyMV0sIFs0Ni4zMjYzLCA1LjY0NDNdLCBbNDUuODk5NiwgNC44MTI5XSwgWzQ1LjkwOTMsIDUuODI4NV0sIFs0NS42Mjg3LCA1LjYxMzRdLCBbNDUuNjM0LCA1LjYwNDZdLCBbNDUuNjg5OSwgNS41NjE2XSwgWzQ2LjI3ODQsIDYuMTAzM10sIFs0NS43MjY3LCA1LjUyMDVdLCBbNDUuODIzMywgNS4yOTIxXSwgWzQ2LjQzLCA1LjMyMDddLCBbNDYuNDE3OSwgNS4zMDcyXSwgWzQ2LjQ0NjYsIDUuMzA0XSwgWzQ2LjMzNjksIDUuNDI3NV0sIFs0Ni40OTc1LCA1LjIwMzZdLCBbNDYuNDQ1MSwgNS4zMTQ5XSwgWzQ2LjM0NjQsIDUuNDE5OF0sIFs0Ni40ODY0LCA1LjA1MTJdLCBbNDYuNDk4MiwgNS4wOTgzXSwgWzQ2LjQ5NjUsIDUuMV0sIFs0Ni4yOTY5LCA0LjgzMThdLCBbNDYuNTEwOSwgNC45NTI1XSwgWzQ2LjUwNDQsIDQuOTQ2MV0sIFs0Ni40ODIyLCA0LjkxNDRdLCBbNDYuNTE0NCwgNC45NTA4XSwgWzQ2LjE4MywgNS45OTUzXSwgWzQ1Ljg3MjUsIDUuMzc0Nl0sIFs0NS44MDk0LCA1LjA2MTRdLCBbNDYuMzQyLCA1LjY0Ml0sIFs0Ni40MDE3LCA2LjA0NDVdLCBbNDYuMjM4MiwgNi4wNTIyXSwgWzQ2LjM0NjEsIDUuOTcxM10sIFs0NS43MDIyLCA1LjU1MTldLCBbNDYuNTA4LCA1LjE0MzRdLCBbNDYuMzY0NCwgNS45ODYxXSwgWzQ1LjkyMjIsIDQuNzk2NV0sIFs0Ni4zMzA4LCA1Ljk1ODJdLCBbNDUuOTM0OSwgNC43ODEzXSwgWzQ1Ljc1NTIsIDUuNzgxN10sIFs0NS42ODMxLCA1LjcwODNdLCBbNDUuNjEyNCwgNS42MjQ4XSwgWzQ1LjYxMzIsIDUuNjIzOV0sIFs0NS42OTEyLCA1LjU0NjldLCBbNDUuNzY4MiwgNS40NjldLCBbNDUuNzg2OSwgNS40NDYxXSwgWzQ2LjQ0NjUsIDUuMjg2MV0sIFs0Ni40MTg1LCA1LjMwNzddLCBbNDYuMzgyOSwgNS4zNzE1XSwgWzQ2LjQ5OCwgNS4yMDI0XSwgWzQ2LjM0NzcsIDUuNDIzNV0sIFs0Ni4zNzcyLCA1LjM3MTddLCBbNDYuMzY5MywgNS4zNjM4XSwgWzQ2LjQ5NTEsIDUuMTE1NV0sIFs0Ni4zMDMzLCA1LjQ3MDhdLCBbNDYuMzQxMiwgNS42NDE0XSwgWzQ2LjUwOTIsIDQuOTMxNF0sIFs0Ni4yMzIzLCA0LjgwMzRdLCBbNDYuMzA5NCwgNS43MTExXSwgWzQ2LjExNTUsIDQuNzcxNV0sIFs0Ni4xNDA3LCA0Ljc5NzRdLCBbNDYuMTEwOSwgNS44ODc0XSwgWzQ2LjM4NzQsIDYuMDI5Nl0sIFs0Ni4zNTM4LCA2LjE1NzhdLCBbNDYuMjk3MywgNi4xMjFdLCBbNDYuMjkzOSwgNi4xMTY3XSwgWzQ2LjI1OTcsIDYuMTIxXSwgWzQ2LjI0NTcsIDYuMDgxNF0sIFs0Ni4yMzMyLCA2LjAyNTNdLCBbNDUuNzc2OSwgNS4yMzldLCBbNDUuODYzLCA1LjM5MV0sIFs0Ni40MjMxLCA1LjMwODRdLCBbNDYuNTEwMywgNS4wMTFdLCBbNDYuNDg5NywgNS4wNDYxXSwgWzQ2LjQ4OTUsIDUuMDQ2M10sIFs0Ni40OTUsIDUuMTAyNF0sIFs0Ni41MDIsIDUuMTMxNV0sIFs0Ni41MDMxLCA1LjE2NjRdLCBbNDYuNTEzOSwgNS4xNzI2XSwgWzQ2LjUwOTEsIDUuMTg5M10sIFs0Ni41MDQ0LCA1LjIwMTddLCBbNDYuMzQwNiwgNS42NDk2XSwgWzQ2LjA3OTIsIDUuODExOV0sIFs0NS43MSwgNS43MzM0XSwgWzQ2LjUwNzIsIDUuMTQ3NF0sIFs0NS42MzgxLCA1LjY3NjldLCBbNDYuMzE0OCwgNS42MDY4XSwgWzQ1LjYyMzUsIDUuNjQwMV0sIFs0NS42OTA1LCA1LjU3NjFdLCBbNDUuNzg2MywgNS40NDY4XSwgWzQ2LjM5MTksIDUuMzYxMV0sIFs0Ni4zMTY1LCA1LjQwMzldLCBbNDYuNDQ5MywgNS4yNzI5XSwgWzQ2LjQyOTgsIDUuMzIzMl0sIFs0Ni4zOTI1LCA1LjM1NTNdLCBbNDYuNDg1OSwgNS4wNjg1XSwgWzQ2LjI5MDcsIDUuNDU4OV0sIFs0Ni4yNjY3LCA1LjUwNl0sIFs0Ni4zNTcsIDUuOTgxNl0sIFs0Ni4zNjczLCA1Ljk5NTNdLCBbNDYuMzU0NSwgNC44NTFdLCBbNDYuNDYzNSwgNC45MTVdLCBbNDYuNTE1NCwgNC45ODJdLCBbNDYuMjEwNCwgNC43OTNdLCBbNDYuMzA4NiwgNS42MDI0XSwgWzQ2LjEzMTUsIDUuOTIyM10sIFs0Ni4wMDgsIDQuNzQ4OV0sIFs0Ni4xNzQ0LCA0Ljc4MV0sIFs0Ni40NTcyLCA1LjIzNzRdLCBbNDYuMTI3OSwgNS45Mjc5XSwgWzQ2LjMxMTcsIDUuOTIxMl0sIFs0Ni4wMTk3LCA1LjgwOTldLCBbNDYuMzE3NywgNS40MTM4XSwgWzQ2LjQwMywgNi4wNDU1XSwgWzQ2LjMzMDUsIDYuMTM2OV0sIFs0Ni4yNTU3LCA2LjEyMTddLCBbNDYuMjI4NCwgNi4wMTA0XSwgWzQ2LjE3MywgNS45ODU5XSwgWzQ2LjM1NjIsIDUuOTgwNV0sIFs0NS45MDIzLCA0LjgxODddLCBbNDYuMzU2NiwgNS45ODExXSwgWzQ2LjE2OTEsIDUuOTgxMV0sIFs0NS45NjQzLCA0Ljc1XSwgWzQ2LjE3MDUsIDUuOTg3OV0sIFs0Ni4zMTIsIDUuOTIzMl0sIFs0NS45NDg3LCA1LjgzMjhdLCBbNDUuOCwgNS43ODUzXSwgWzQ1LjczMTcsIDUuNzc0OF0sIFs0Ni4yMTY5LCA1Ljk4MzFdLCBbNDUuNzI0MywgNS43NzQ2XSwgWzQ1LjcxMzYsIDUuNzU5Nl0sIFs0NS43MDkxLCA1LjY5OTldLCBbNDYuMzEwMywgNS40MTA0XSwgWzQ2LjM5NDUsIDUuMzYzMV0sIFs0Ni40OTMzLCA1LjIwNl0sIFs0Ni4zNTM2LCA1LjM3NF0sIFs0Ni4zMzY3LCA1LjQwMjldLCBbNDYuNDg0NiwgNS4yMTIyXSwgWzQ2LjQ3OTksIDUuMjEwOV0sIFs0Ni4zMjkxLCA1LjYxNzZdLCBbNDYuMzE5NywgNS42NzQxXSwgWzQ2LjI2ODEsIDUuODY3OF0sIFs0Ni4zMDk0LCA1Ljk0MTRdLCBbNDUuODIzMSwgNS40MjE4XSwgWzQ2LjMxMjEsIDUuNjg0M10sIFs0Ni4wODU1LCA1Ljg2Nl0sIFs0NS43Njk1LCA1LjIyNjddLCBbNDYuMDg2NCwgNS44NzUzXSwgWzQ2LjI4NCwgNS45MDg5XSwgWzQ2LjQxNjIsIDYuMDY0XSwgWzQ2LjQwNDEsIDYuMTAwOF0sIFs0Ni4zNDAyLCA2LjE0MDRdLCBbNDYuMjk1MywgNi4xMTg4XSwgWzQ1LjgzMzIsIDUuMjk4M10sIFs0Ni4yNjUyLCA1LjUwOF0sIFs0NS45MzEsIDUuODIyNF0sIFs0NS43NzM3LCA1Ljc4MjhdLCBbNDUuNzIsIDUuNzY0Nl0sIFs0NS42OTk3LCA1LjU1NzJdLCBbNDUuNzk1NiwgNS40MzgyXSwgWzQ1Ljg1NDMsIDUuNDA3OF0sIFs0Ni40OTkyLCA1LjAxNzddLCBbNDYuNDg5MiwgNS4wNDY0XSwgWzQ2LjQ4ODksIDUuMDc4NV0sIFs0Ni40ODc3LCA1LjIwNV0sIFs0Ni40MDIxLCA1LjMzXSwgWzQ2LjMzOTUsIDUuNDE3MV0sIFs0Ni40NDg2LCA1LjI3MzddLCBbNDYuNTA3NSwgNS4xOTldLCBbNDYuMzgwMiwgNS4zNzU2XSwgWzQ2LjQ4MDMsIDUuMjExMl0sIFs0Ni4zMTksIDUuNjA5OV0sIFs0Ni4wMTE1LCA0Ljc0OF0sIFs0Ni4wMzYyLCA0Ljc0NTJdLCBbNDYuMTQ4OSwgNC44MDE1XSwgWzQ2LjQxNjEsIDYuMDY0M10sIFs0Ni4zMjE3LCA2LjEyODNdLCBbNDYuMDUzNywgNS44MTMzXSwgWzQ1Ljg3MTIsIDQuOTA3OV0sIFs0NS45NDE2LCA1LjgzMDZdLCBbNDUuNzU3NSwgNS43ODAxXSwgWzQ1LjYxNDIsIDUuNjIzMl0sIFs0NS42NzIzLCA1LjU1MjhdLCBbNDUuNzk1NywgNS4yNzM5XSwgWzQ2LjMwOTgsIDUuOTQxXSwgWzQ1LjgwNzgsIDUuMTM1Ml0sIFs0Ni40ODY1LCA1LjA3MTNdLCBbNDYuMzI5LCA1LjQzMjZdLCBbNDYuNDMzMSwgNS4zMTgzXSwgWzQ2LjI3NDUsIDUuNDU2OF0sIFs0Ni4yNjc0LCA1LjQ3Ml0sIFs0Ni4zMTAyLCA1LjY5NDZdLCBbNDYuMjg0OCwgNS44OTI4XSwgWzQ2LjMxMiwgNS45MjM0XSwgWzQ2LjMyMjYsIDUuOTUxXSwgWzQ2LjIyMjYsIDUuOTk0OV0sIFs0Ni4xNjY3LCA1Ljk4MDddLCBbNDYuMzYwNCwgNS45ODNdLCBbNDYuMzEyNSwgNi4xMTk4XSwgWzQ2LjI5NDgsIDYuMTE5Nl0sIFs0NS43NjkzLCA1LjIyNTldLCBbNDUuODM5OCwgNC45MTcyXSwgWzQ2LjIxNjgsIDUuOTg1Nl0sIFs0NS44NDcxLCA0LjkxNDJdLCBbNDUuODc3OCwgNC44OTQzXSwgWzQ1LjkwNTQsIDQuODI2XSwgWzQ1LjkyMSwgNC44MDc0XSwgWzQ1LjkzNDUsIDQuNzgxNV0sIFs0Ni41MDU1LCA1LjEzNDRdLCBbNDUuNjQxNCwgNS42ODQ1XSwgWzQ1LjYxMTMsIDUuNjI2NV0sIFs0NS44NzUyLCA1LjM3MDNdLCBbNDUuNzcyOSwgNS4xODk0XSwgWzQ1LjgxMDYsIDUuMTEzMl0sIFs0NS42NzUxLCA1LjU1MjVdLCBbNDUuODEzNCwgNS4xMDA4XSwgWzQ2LjUxMDIsIDUuMTY2XSwgWzQ2LjUxMjksIDUuMTczN10sIFs0Ni40NDU1LCA1LjMwNzldLCBbNDYuMjY2MiwgNS40NzI1XSwgWzQ2LjI5MzgsIDUuNTY1Nl0sIFs0Ni4zMzY3LCA1LjY0OTVdLCBbNDYuMjY2MiwgNS43NzczXSwgWzQ2LjI2MTcsIDUuODI2M10sIFs0Ni4xNzYxLCA1Ljk5MDddLCBbNDYuMTQxMSwgNS45NjVdLCBbNDYuNTEyNiwgNC45OTExXSwgWzQ2LjM2NjYsIDUuOTk0M10sIFs0Ni4yNjgzLCA1Ljc2Nl0sIFs0Ni4yMDE4LCA1Ljk3MTldLCBbNDUuOTUxMSwgNC43MzA5XSwgWzQ2LjI2NzQsIDUuNzY0Nl0sIFs0NS43Mjg5LCA1LjUxOTNdLCBbNDYuMzgxNywgNi4xNDQzXSwgWzQ2LjM1OTYsIDYuMTYxMl0sIFs0Ni4zNTE1LCA2LjE1ODJdLCBbNDYuMzA0OSwgNi4xMjAxXSwgWzQ2LjI3NjEsIDYuMTA3N10sIFs0Ni4yNDYsIDYuMDg4Ml0sIFs0Ni4zMDk2LCA1LjY5MjddLCBbNDYuMDgxOSwgNS44MTY2XSwgWzQ1LjgyOTYsIDQuOTE5Ml0sIFs0NS44NTUxLCA0LjkwNF0sIFs0NS45MTA1LCA0Ljg0XSwgWzQ1Ljk3MzYsIDQuNzU0Nl0sIFs0Ni4wNjA5LCA1LjgwODFdLCBbNDYuMjg0MSwgNS43MTU4XSwgWzQ1LjcwNzMsIDUuNzU1XSwgWzQ1LjcwOTYsIDUuNzI4OV0sIFs0NS42NzE2LCA1LjU1NTNdLCBbNDUuODYxMSwgNS4zOTY3XSwgWzQ1Ljc4OTUsIDUuMjY3XSwgWzQ1Ljc3MTksIDUuMjMxNF0sIFs0NS44MDc0LCA1LjEzNjJdLCBbNDYuNDQ0LCA1LjMxNDRdLCBbNDYuMzMyOSwgNS40MDI4XSwgWzQ2LjQ5NTcsIDUuMDkwNV0sIFs0Ni41MDY2LCA1LjIwMzNdLCBbNDYuNDczMywgNS4yMTUzXSwgWzQ2LjQ2ODgsIDUuMjIyOF0sIFs0Ni40NTkzLCA1LjIzODJdLCBbNDYuNDYyNiwgNS4yMzJdLCBbNDYuNDQ2OCwgNS4zMDUyXSwgWzQ2LjMzMTIsIDUuNDMxOV0sIFs0Ni4xOTE5LCA0Ljc4MjldLCBbNDYuMjkzNSwgNS43MTkzXSwgWzQ1LjY5MDYsIDUuNTQ1N10sIFs0NS43NzU5LCA1LjIzNzRdLCBbNDYuMzY0OSwgNS45ODY2XSwgWzQ2LjIwNjQsIDUuOTY5Ml0sIFs0Ni4xMzUyLCA0Ljc5MjFdLCBbNDYuMTI4LCA1Ljk0NjZdLCBbNDYuMDU2NSwgNS44MTQyXSwgWzQ2LjM0NTIsIDYuMTUxXSwgWzQ2LjI0MzYsIDYuMDY1Nl0sIFs0Ni4yMjkyLCA2LjAxMzZdLCBbNDYuMDk4MywgNS44MjM2XSwgWzQ2LjMxNjMsIDUuOTQ3N10sIFs0Ni4yODM1LCA1LjcxNTddLCBbNDUuODAzOCwgNS4xNTYxXSwgWzQ1Ljg5NywgNC44Nzk5XSwgWzQ1LjkxMywgNC44NDhdLCBbNDUuOTM1LCA0Ljc2MTFdLCBbNDYuMjg0NiwgNS45MDk1XSwgWzQ2LjE3MzUsIDUuOTg0OV0sIFs0NS44NjI0LCA1LjgwODhdLCBbNDUuNjM4NiwgNS42NjIyXSwgWzQ1LjY4ODEsIDUuNTc1NV0sIFs0Ni4wMDg5LCA1LjgxMDhdLCBbNDUuNzA5NywgNS41NTI2XSwgWzQ1LjczMTIsIDUuNTE3NV0sIFs0NS43NTExLCA1LjQ4NjldLCBbNDYuNDY5MiwgNS4yMjE4XSwgWzQ2LjQ1MTMsIDUuMjY0Nl0sIFs0Ni40NjM2LCA1LjIzMDhdLCBbNDYuNDg1MSwgNS4yMTExXSwgWzQ2LjQxODIsIDUuMzA3XSwgWzQ2LjQxOTgsIDUuMzA4NV0sIFs0Ni40ODY0LCA1LjIwNjRdLCBbNDYuMzEzOCwgNS40NzQ4XSwgWzQ2LjI2ODIsIDUuNDldLCBbNDYuMzIzMywgNS42N10sIFs0Ni4yOTcyLCA0LjgzMl0sIFs0Ni4zMjk5LCA0Ljg1MzRdLCBbNDYuNDY5NCwgNC45MTU5XSwgWzQ2LjA4NTEsIDUuODc5Nl0sIFs0Ni4wNTA2LCA0Ljc0MTldLCBbNDYuMDgxOSwgNC43NTI4XSwgWzQ2LjEwMiwgNC43NjE4XSwgWzQ1Ljc2OTMsIDUuMjE0N10sIFs0Ni4zNzcyLCA2LjAxNThdLCBbNDYuMzk5NiwgNi4wNDNdLCBbNDYuNDE0OCwgNi4wNTUyXSwgWzQ1LjgwOTcsIDUuMDY1OV0sIFs0NS45MTAyLCA0LjgzOTNdLCBbNDYuMTkwNywgNS45ODI2XSwgWzQ1LjkzNTMsIDQuNzUyNF0sIFs0Ni4zMzMyLCA1LjYzNDldLCBbNDUuOTM2NSwgNS44Mjc1XSwgWzQ1LjY5MTMsIDUuNzA4M10sIFs0NS42NzQzLCA1LjU2MzZdLCBbNDUuNjE1MSwgNS42MzYxXSwgWzQ1LjY4NzQsIDUuNTQ1Ml0sIFs0NS42OTc4LCA1LjU2ODNdLCBbNDUuNzYwNSwgNS40NzY5XSwgWzQ2LjQ4NTgsIDUuMDcxNF0sIFs0Ni41MDc1LCA1LjE1NjhdLCBbNDYuNTA2MywgNS4xNjU4XSwgWzQ2LjUwOTgsIDUuMTY1Nl0sIFs0Ni40NDk5LCA1LjI3MjZdLCBbNDYuNDQ2NSwgNS4yODQ2XSwgWzQ2LjUxMjYsIDUuMTc0OF0sIFs0Ni40MTYyLCA1LjMxNV0sIFs0Ni4zNDU1LCA1LjQxNzNdLCBbNDYuMzg0MSwgNS4zNzE3XSwgWzQ2LjQ4MTQsIDQuOTE0NV0sIFs0Ni4zNzc3LCA0Ljg2NzRdLCBbNDYuNTE0OCwgNC45NDM2XSwgWzQ2LjUwMjQsIDQuOTUyNl0sIFs0Ni4yNjgxLCA0LjgyMDNdLCBbNDYuMjExNSwgNS45NzE4XSwgWzQ2LjEyNTYsIDQuNzgwNV0sIFs0Ni4zOTg0LCA2LjA0Ml0sIFs0Ni4zNDgzLCA2LjE1NDZdLCBbNDYuMzQ0MiwgNi4xNTAxXSwgWzQ2LjMzMTQsIDYuMTM2NF0sIFs0Ni4zMTcxLCA2LjEyNDJdLCBbNDYuMzEzMSwgNi4xMjEyXSwgWzQ2LjMwOTYsIDYuMTE5N10sIFs0Ni4yNTEsIDYuMTI0Ml0sIFs0Ni4yNDIyLCA2LjA3MzldLCBbNDYuMjQzMSwgNi4wNjYyXSwgWzQ2LjEzNDksIDUuOTYxMl0sIFs0NS44NDgzLCA1LjMwMjddLCBbNDYuMTAxMywgNS44NDA5XSwgWzQ2LjA3OTUsIDUuODEyNV0sIFs0NS45MDM0LCA0LjgyMTRdLCBbNDUuOTA2MiwgNC44MDkyXSwgWzQ1LjkzODQsIDQuNzc3MV0sIFs0Ni4yOTY0LCA1LjkxNTddLCBbNDUuOTM1OCwgNC43NjM0XSwgWzQ1LjkxMTcsIDUuODI5MV0sIFs0Ni4xMzA3LCA1LjkxOV0sIFs0NS42MTQ0LCA1LjYzNThdLCBbNDUuNjkzOSwgNS41NDU5XSwgWzQ1LjcwMjQsIDUuNTUxOV0sIFs0NS43NDYyLCA1LjQ5NTRdLCBbNDUuNzk4NCwgNS40MzQ2XSwgWzQ2LjUwMTQsIDUuMTM0XSwgWzQ2LjQ4NjgsIDUuMjA1N10sIFs0Ni4zODgsIDUuMzY3M10sIFs0Ni40NjA5LCA1LjI0MjNdLCBbNDYuNDY4MywgNS4yMTY0XSwgWzQ2LjUwMzEsIDUuMTY2M10sIFs0Ni4yOTc5LCA1LjQ2ODFdLCBbNDYuMjY0MywgNS40NzM5XSwgWzQ2LjI5MzMsIDUuNTgyNF0sIFs0Ni4zMDUzLCA1LjYwMjFdLCBbNDYuNTA1MiwgNC45Njg1XSwgWzQ2LjUwOTEsIDQuOTddLCBbNDYuNTEzNCwgNC45ODk3XSwgWzQ2LjA1ODksIDUuODEwOV0sIFs0Ni4zNzA3LCA2LjAwMjVdLCBbNDYuMzcxMiwgNi4wMDI4XSwgWzQ2LjM3MTQsIDYuMDA0MV0sIFs0Ni4zNzE2LCA2LjAwNTZdLCBbNDYuMzcxNywgNi4wMDU5XSwgWzQ2LjM3NTQsIDYuMDExN10sIFs0Ni4zNzYsIDYuMDEzNF0sIFs0Ni4zNzYyLCA2LjAxNDhdLCBbNDYuMzc2NSwgNi4wMTQ4XSwgWzQ2LjM3ODksIDYuMDE2NF0sIFs0Ni4zOSwgNi4wMzMxXSwgWzQ2LjMxMjgsIDYuMTIwMl0sIFs0Ni4wMTc4LCA1LjgwODJdLCBbNDYuMzM0NiwgNS45NjA5XSwgWzQ1LjgwNCwgNC45MjM4XSwgWzQ1LjgyODQsIDQuOTIwOF0sIFs0NS44NDczLCA0LjkxMzNdLCBbNDUuOTM5MiwgNC43NzE0XSwgWzQ1Ljk4MTEsIDQuNzUxN10sIFs0NS45MjkzLCA1LjgyMTldLCBbNDUuODUwOSwgNS44MDI0XSwgWzQ1LjczOSwgNS43NzAzXSwgWzQ2LjM0MzMsIDUuOTY3OV0sIFs0NS43MDk0LCA1LjczOTddLCBbNDYuMzQ2MywgNS45NzI5XSwgWzQ1Ljc5MzIsIDUuMTc3Ml0sIFs0Ni4zMzk2LCA1LjQwMTRdLCBbNDYuNDE3LCA1LjMwMjNdLCBbNDYuMzM2LCA1LjQxNjZdLCBbNDYuNTA2OSwgNS4wMDk1XSwgWzQ2LjQ5NjEsIDUuMTE2MV0sIFs0Ni41MDc2LCA1LjE1NDJdLCBbNDYuNDQ2NiwgNS4zMDk4XSwgWzQ2LjM0MDUsIDUuMzkzN10sIFs0Ni4zNjkzLCA1LjM2MzNdLCBbNDYuNDgxMSwgNS4yMTI0XSwgWzQ2LjIwMDgsIDQuNzkyXSwgWzQ2LjUxMDgsIDQuOTUyMV0sIFs0Ni4zNDU5LCA1Ljk3MjRdLCBbNDUuNzUyNywgNS40ODQ3XSwgWzQ2LjA2NDksIDQuNzYxNF0sIFs0Ni4yODUyLCA1LjU2MDldLCBbNDYuMTE5NiwgNS44OTYzXSwgWzQ1LjgyODgsIDQuOTIwMV0sIFs0Ni4wODU3LCA1Ljg2NjddLCBbNDYuMzEyMiwgNS45MjIzXSwgWzQ2LjM0MywgNi4xNDk0XSwgWzQ2LjI2MTMsIDYuMTIwNV0sIFs0Ni4yNDMsIDYuMDczXSwgWzQ2LjIzMzUsIDYuMDI1OV0sIFs0Ni4zNDY3LCA1Ljk3MjJdLCBbNDYuMzEwNiwgNS45MzUyXSwgWzQ2LjAzMTgsIDUuODA5NV0sIFs0NS45MDgzLCA0LjgzNDJdLCBbNDUuOTAwNSwgNC44MTQzXSwgWzQ1Ljc1ODQsIDUuNzc5Nl0sIFs0NS43MjQ4LCA1Ljc3NTFdLCBbNDUuNjk4NiwgNS41NTEyXSwgWzQ2LjE3MzgsIDUuOTgzM10sIFs0Ni4zOTYzLCA2LjAzOTNdLCBbNDYuMDk0MywgNS44OTMyXSwgWzQ2LjEwNDIsIDUuODIxN10sIFs0Ni40ODU4LCA1LjA2OF0sIFs0Ni41MDc5LCA1LjEzNV0sIFs0Ni40ODIxLCA1LjIxNF0sIFs0Ni40NTcyLCA1LjIzNzFdLCBbNDYuMzQ0OCwgNS40MTcxXSwgWzQ2LjMzMjksIDUuNDE1NF0sIFs0Ni40MTI0LCA1LjI5OTJdLCBbNDYuMzY2NiwgNS4zNjk2XSwgWzQ2LjQ2NDksIDUuMjI5NF0sIFs0Ni4zMjQ3LCA1LjQwNDddLCBbNDYuMzk2NCwgNC44ODIyXSwgWzQ2LjUwNjksIDQuOTQ0N10sIFs0Ni41MTE2LCA0Ljk5ODJdLCBbNDYuMjYxOSwgNC44MTJdLCBbNDYuNDg4OSwgNC45MTU2XSwgWzQ2LjUwNTYsIDQuOTU3MV0sIFs0Ni4wMjY0LCA0Ljc0NjNdLCBbNDYuMTAwNiwgNC43NjAyXSwgWzQ1Ljc4NDksIDUuMTg0MV0sIFs0Ni4zOTQsIDYuMDM2OV0sIFs0Ni4zOTA4LCA2LjEzXSwgWzQ2LjM0NzMsIDYuMTUyOV0sIFs0Ni4zMzE2LCA2LjEzNjJdLCBbNDYuMjI3MSwgNi4wMDk1XSwgWzQ2LjI2NjYsIDUuNzQzOV0sIFs0Ni4xMzgyLCA1Ljk2NjVdLCBbNDYuMzM3NCwgNS42NDkyXSwgWzQ1Ljg5OTksIDQuODEzMV0sIFs0NS45OTIsIDUuODFdLCBbNDUuOTkxMiwgNS44MV0sIFs0NS45ODkxLCA1LjgwOTldLCBbNDUuOTg2LCA1LjgxM10sIFs0NS45ODIsIDUuODE4OF0sIFs0NS45ODA1LCA1LjgyMjJdLCBbNDUuOTc5MiwgNS44MjUxXSwgWzQ1Ljk3NjcsIDUuODI5Nl0sIFs0NS45NjE3LCA1LjgzMjhdLCBbNDUuOTU5MiwgNS44MzI3XSwgWzQ2LjI5NDgsIDUuNzE5MV0sIFs0NS42MTg5LCA1LjYyXSwgWzQ2LjEwNDIsIDUuODJdLCBbNDUuNjY3MSwgNS41ODY0XSwgWzQ1LjY5ODIsIDUuNTQ2OF0sIFs0NS43MzIzLCA1LjUxNjJdLCBbNDYuNDQ5NSwgNS4yOTM5XSwgWzQ2LjM5MTgsIDUuMzU3N10sIFs0Ni41MDg5LCA1LjAxMDFdLCBbNDYuNTE3NSwgNS4xNjU5XSwgWzQ2LjUwODgsIDUuMTkxOF0sIFs0Ni40MDA5LCA1LjM0MjVdLCBbNDYuNDQ2NSwgNS4yODE1XSwgWzQ2LjI2NzMsIDUuNDgyOV0sIFs0Ni4yNywgNS44NjU2XSwgWzQ2LjI5NDgsIDUuOTE1Ml0sIFs0Ni41MTI1LCA0Ljk1NDRdLCBbNDYuMzM0NSwgNC44NTM2XSwgWzQ2LjM5MjQsIDQuODc5N10sIFs0Ni41MTEyLCA0Ljk2MzRdLCBbNDYuMDQyNywgNS44MDcyXSwgWzQ2LjAxODcsIDUuODA5M10sIFs0NS43OTA3LCA1LjI2ODldLCBbNDUuODA3MSwgNS4xMTE1XSwgWzQ2LjAzNTUsIDQuNzQ1NV0sIFs0Ni4wNjExLCA0Ljc1OV0sIFs0Ni4wNjE0LCA0Ljc1OTJdLCBbNDYuMzkwNSwgNi4wMzQ0XSwgWzQ2LjM4MTksIDYuMTQ0XSwgWzQ2LjM3NDMsIDYuMTYyMl0sIFs0Ni4zMzIxLCA2LjEzNjNdLCBbNDYuMzIyNCwgNi4xMjldLCBbNDYuMjg2OCwgNi4xMDQ2XSwgWzQ2LjI3NDgsIDYuMTA4OV0sIFs0Ni4yNTQ2LCA2LjEyMTFdLCBbNDYuMjQyNCwgNi4wNzM4XSwgWzQ2LjI0NDgsIDYuMDYwMV0sIFs0Ni4wODEzLCA1LjgxNjRdLCBbNDUuODIxMSwgNC45MjA0XSwgWzQ1Ljg4LCA0Ljg4MzhdLCBbNDUuOTA1LCA0LjgyNDVdLCBbNDUuNzgxNCwgNS4yNDgzXSwgWzQ1LjkzNDYsIDQuNzU3M10sIFs0NS45MzYxLCA0Ljc0OThdLCBbNDYuMjY1OSwgNS43Ml0sIFs0NS45NDQ4LCA1LjgzMjJdLCBbNDUuNzg1NSwgNS43ODM0XSwgWzQ1LjgwOTksIDUuMDY3Ml0sIFs0NS44MDU2LCA1LjAxNjddLCBbNDYuMzk0NywgNS4zNTJdLCBbNDYuNDAyMSwgNS4zMjc4XSwgWzQ2LjQyOTIsIDUuMzIzMV0sIFs0Ni41MTI3LCA1LjE3MzddLCBbNDYuNDg1LCA1LjIxMDNdLCBbNDYuMzkyNywgNS4zNTM1XSwgWzQ2LjI4MzUsIDUuNTU5NF0sIFs0Ni4zMTIzLCA1Ljk0MzldLCBbNDYuMzU1MiwgNS45ODAyXSwgWzQ2LjM2NzYsIDUuOTk2XSwgWzQ2LjMxNTIsIDQuODQzMl0sIFs0Ni4yMjQ1LCA0Ljc5NzhdLCBbNDUuNzkzNSwgNS4xNzY5XSwgWzQ2LjAxNDcsIDQuNzQ1Nl0sIFs0Ni4xMDYzLCA0Ljc2N10sIFs0Ni4zMjc4LCA2LjEzMzhdLCBbNDYuMjYxOCwgNi4xMjAxXSwgWzQ2LjEwMjksIDUuODM3NF0sIFs0NS44NTUxLCA0LjkwMjVdLCBbNDYuMjY1MywgNS41MjM3XSwgWzQ2LjEyODgsIDUuOTMxN10sIFs0Ni4yNjE2LCA1Ljg1MTNdLCBbNDUuNjM3OSwgNS42NzI4XSwgWzQ1LjcyMTIsIDUuNTIzMl0sIFs0NS43NjU1LCA1LjQ3MTZdLCBbNDUuNzg0NiwgNS4yNTYzXSwgWzQ1Ljc5MiwgNS4xNzg4XSwgWzQ1LjgwODQsIDUuMTA1NF0sIFs0Ni4zNDY3LCA1LjQyMTJdLCBbNDYuNDk1OSwgNS4wODg4XSwgWzQ2LjUxMTMsIDUuMTY2N10sIFs0Ni41MTY2LCA1LjE2NjVdLCBbNDYuNDk5NywgNS4yMDMxXSwgWzQ2LjQ5MjcsIDUuMjA3Nl0sIFs0Ni4zNjYzLCA1LjM3MDldLCBbNDYuNTA5NywgNS4wMDY2XSwgWzQ2LjI2ODgsIDUuNDY4M10sIFs0Ni4yNjczLCA1LjUwNDldLCBbNDYuNTExOSwgNC45NDEzXSwgWzQ1Ljg4MjQsIDUuMzQ1N10sIFs0Ni4yMzAxLCA0LjgwMV0sIFs0Ni4zMjgyLCA0Ljg1MjhdLCBbNDYuNTE5NywgNC45NDEyXSwgWzQ2LjM5OCwgNC44ODMyXSwgWzQ2LjQ5MDcsIDQuOTE3XSwgWzQ2LjUxMDYsIDQuOTQ0Ml0sIFs0Ni41MDE0LCA0Ljk0OTFdLCBbNDYuNTA2MSwgNC45NDQ1XSwgWzQ2LjUxMjMsIDQuOTYyN10sIFs0Ni40NDIzLCA0Ljg5MjddLCBbNDYuMTk5MiwgNS45NjUxXSwgWzQ2LjM5NzcsIDYuMTE3Ml0sIFs0Ni4zMzk0LCA2LjEzODZdLCBbNDYuMjQxNCwgNi4wNzMxXSwgWzQ2LjI2ODEsIDUuNDkyMV0sIFs0Ni4yMjY0LCA2LjAwNjhdLCBbNDYuMjkyNSwgNS41ODczXSwgWzQ2LjI2NjcsIDUuNzc0Nl0sIFs0NS44MTU4LCA0LjkxOTVdLCBbNDUuODM4NiwgNC45MThdLCBbNDUuODc0NSwgNC45MDQzXSwgWzQ1Ljg3NzUsIDQuODk5Nl0sIFs0NS45MTAyLCA0LjgzODhdLCBbNDUuODk2NiwgNC44MDY5XSwgWzQ1LjkzNDMsIDUuODI1M10sIFs0NS44MDcyLCA1LjEzNjVdLCBbNDYuMjg5MiwgNi4xMDhdLCBbNDYuMjE1OCwgNS45OTEzXSwgWzQ2LjM0MDYsIDUuMzkyNl0sIFs0Ni4zMzUsIDUuNDI5XSwgWzQ2LjUwNywgNS4xNjUzXSwgWzQ2LjUwNjUsIDUuMjAzNl0sIFs0Ni41MDU2LCA1LjIwMzZdLCBbNDYuNDUwMiwgNS4yNTk5XSwgWzQ2LjQyNjYsIDUuMzE1OV0sIFs0Ni40NDczLCA1LjI4NzVdLCBbNDYuMzM5NywgNS40MDAzXSwgWzQ2LjMxMDEsIDUuNzAyMV0sIFs0Ni40MzI5LCA0Ljg5MTNdLCBbNDYuNTE4OSwgNC45NDMzXSwgWzQ2LjI3NDgsIDQuODI2XSwgWzQ2LjQyNTIsIDQuODkxM10sIFs0Ni4xOTIxLCA0Ljc4M10sIFs0Ni4wMjksIDUuODExMl0sIFs0Ni4wODI0LCA0Ljc0OTZdLCBbNDUuODA2LCA1LjE0NzldLCBbNDUuNzg4MywgNS4yNjQzXSwgWzQ2LjAxNjQsIDUuODA2XSwgWzQ2LjQwMTQsIDYuMDQ0NV0sIFs0Ni4zOTcyLCA2LjExNDldLCBbNDYuMzg3NywgNi4xMzYxXSwgWzQ2LjM0MzcsIDYuMTQ5Nl0sIFs0Ni4zMzQyLCA2LjEzOTFdLCBbNDYuMjQ1NCwgNi4wNzk2XSwgWzQ2LjIzNTUsIDYuMDI5M10sIFs0Ni4yMzE4LCA2LjAxNzFdLCBbNDYuMDg4NSwgNS44OTE0XSwgWzQ1Ljc5OTEsIDUuMTE0NF0sIFs0NS44MjY3LCA0LjkyXSwgWzQ2LjMzNDMsIDUuOTU5N10sIFs0NS44Mzk1LCA0LjkxODNdLCBbNDUuODc3NCwgNC45MDE4XSwgWzQ2LjA5MTYsIDUuODkxOF0sIFs0NS44MDU2LCA1LjE1MDVdLCBbNDUuNzcxMywgNS43ODNdLCBbNDUuNjMwMSwgNS42MTI2XSwgWzQ1LjYzOTEsIDUuNjA2Ml0sIFs0NS42OTA3LCA1LjU0NjldLCBbNDUuNjg0MSwgNS41NjgxXSwgWzQ1LjY5MTgsIDUuNTc1OF0sIFs0NS43MTMyLCA1LjU0NjddLCBbNDYuNDI2NywgNS4zMTgyXSwgWzQ2LjM0NjUsIDUuNDIwM10sIFs0Ni41MDQsIDUuMDExOV0sIFs0Ni41MDczLCA1LjE0NjFdLCBbNDYuNDU3NSwgNS4yMzc1XSwgWzQ2LjQ0NTMsIDUuMzA3NV0sIFs0Ni41MTkxLCA1LjE2NzNdLCBbNDYuNTAwMywgNS4yMDI0XSwgWzQ2LjM4NTIsIDUuMzcxN10sIFs0Ni4zMDYsIDUuNDcwNl0sIFs0Ni4yMDExLCA0Ljc5MjVdLCBbNDYuNTExNCwgNC45NDY4XSwgWzQ2LjM2MzIsIDQuODU1Ml0sIFs0Ni40NTAxLCA0Ljg5OTNdLCBbNDYuMzIwNywgNS40NTc3XSwgWzQ2LjI2NjQsIDUuODcyN10sIFs0Ni4wNzcyLCA0Ljc1NzZdLCBbNDYuMDg5MSwgNC43NDcxXSwgWzQ2LjEwNjEsIDQuNzY2OF0sIFs0Ni4xMTg5LCA0Ljc3MjhdLCBbNDYuMzExNiwgNS45NDI5XSwgWzQ1LjgwMzMsIDUuMTA0OV0sIFs0NS44MDgzLCA1LjEzNDFdLCBbNDYuMzk3OCwgNi4wNDA1XSwgWzQ2LjQxNjQsIDYuMDYzMl0sIFs0Ni4zNTQzLCA2LjE1NzhdLCBbNDYuMjM5NiwgNi4xMDldLCBbNDYuMTAzOCwgNS44MzZdLCBbNDUuODEyLCA1LjA4NjZdLCBbNDUuODA1MiwgNS4xNDYxXSwgWzQ1LjkxOTIsIDQuODA5Ml0sIFs0NS45Mjk4LCA0Ljc4NDZdLCBbNDUuOTQ1NSwgNC43MjgzXSwgWzQ1LjkyOCwgNS44MjE4XSwgWzQ1LjkyMSwgNS44Mjc2XSwgWzQ1LjkwMzMsIDUuODI2MV0sIFs0NS43NzQ2LCA1Ljc4MjJdLCBbNDUuNjI0MywgNS42NDQ4XSwgWzQ1LjY4NjQsIDUuNTQ1OV0sIFs0Ni4yNjg5LCA1Ljg3NzNdLCBbNDYuNDQ1MywgNS4zMDY1XSwgWzQ2LjUwMzMsIDUuMDEyMl0sIFs0Ni40OTkyLCA1LjEyNjddLCBbNDYuNTAyNCwgNS4xMzcyXSwgWzQ2LjQ4ODcsIDUuMjA1N10sIFs0Ni4zMzk3LCA1LjQwMDldLCBbNDYuNDYxMywgNS4yMzMxXSwgWzQ2LjQ3OSwgNS4yMTAyXSwgWzQ2LjQxMjcsIDUuMjk4OF0sIFs0Ni4zMzUzLCA1LjQwMjZdLCBbNDYuMzIzMSwgNC44NDkzXSwgWzQ2LjM0MjgsIDQuODUyN10sIFs0Ni4zNjgsIDQuODU4NV0sIFs0Ni4wMzMsIDUuODA5M10sIFs0Ni4yOTAyLCA1LjcxODRdLCBbNDYuMDA2NiwgNC43NDg5XSwgWzQ2LjEzODEsIDQuNzk0N10sIFs0Ni4zMTI5LCA1Ljk0MzldLCBbNDUuODExNSwgNS4xMTc5XSwgWzQ2LjM2NTYsIDYuMTY5XSwgWzQ2LjM0MTYsIDYuMTQ1OV0sIFs0Ni4yNTMxLCA2LjEyMzJdLCBbNDYuMjQ3LCA2LjA4ODFdLCBbNDYuMjI4LCA2LjAxMDRdLCBbNDUuNzU1NywgNS40ODE1XSwgWzQ2LjMwOTQsIDUuOTM5MV0sIFs0Ni4xMzkyLCA0Ljc5NTldLCBbNDUuODA2LCA0LjkyMjNdLCBbNDUuOTM1MywgNC43NjIyXSwgWzQ2LjMzNTMsIDUuOTYxOF0sIFs0NS43OTc4LCA1LjExMDldLCBbNDUuNzA4MSwgNS43MjI4XSwgWzQ1LjY0MTUsIDUuNjg0OV0sIFs0NS42OTMzLCA1LjU3NDldLCBbNDUuODc0MywgNS4zNzI0XSwgWzQ2LjUwMTQsIDUuMjAxN10sIFs0Ni40MDEsIDUuMzQxN10sIFs0Ni40NDU3LCA1LjMxMTVdLCBbNDYuMzk4OCwgNS4zMzFdLCBbNDYuNDg2OSwgNS4wNzY3XSwgWzQ2LjQ5MjUsIDUuMTA3MV0sIFs0Ni40MzEyLCA1LjMxOV0sIFs0Ni41MTE5LCA1LjAwMDNdLCBbNDYuMjY1MSwgNS40NzMxXSwgWzQ2LjI4NjMsIDUuNTYxNV0sIFs0Ni40NTM5LCA0LjkwNDZdLCBbNDYuMjE3NCwgNS45OTM5XSwgWzQ2LjA0OSwgNC43NDAyXSwgWzQ2LjI2MTcsIDUuODNdLCBbNDYuMzU3NCwgNS45ODE3XSwgWzQ2LjIyMjYsIDUuOTk1Nl0sIFs0Ni4zOTgxLCA2LjA0MTNdLCBbNDYuMzM5NiwgNi4xMzg3XSwgWzQ2LjMzMjgsIDYuMTM4N10sIFs0Ni4zMjczLCA2LjEzNF0sIFs0Ni4yOTE4LCA1LjQ2Nl0sIFs0Ni4zMDYsIDYuMTIwNV0sIFs0Ni4yOTk5LCA2LjEyMl0sIFs0Ni4yMzcyLCA2LjAzMTldLCBbNDYuMjg5MiwgNS43MTgzXSwgWzQ1LjgzMjIsIDUuNDMzOF0sIFs0NS44NDEsIDUuM10sIFs0NS44Mjc3LCA1LjI5MzldLCBbNDUuODk4NSwgNC44MTEzXSwgWzQ2LjE5MDgsIDUuOTgyNl0sIFs0Ni4xMjI0LCA1LjkwNjRdLCBbNDUuOTIxNiwgNS44MjcxXSwgWzQ1LjY3NDYsIDUuNjk3NF0sIFs0NS42NzIsIDUuNTU4N10sIFs0NS42ODc5LCA1LjU2MTddLCBbNDUuNzA0OCwgNS41NTQyXSwgWzQ1LjgxMTQsIDUuMDU1NV0sIFs0Ni4zOTk4LCA1LjMzMTVdLCBbNDYuNDM1MiwgNS4zMThdLCBbNDYuNDM0MywgNS4zMThdLCBbNDYuNDE3NiwgNS4zMDczXSwgWzQ2LjQ5NDYsIDUuMTA0NF0sIFs0Ni41MDEyLCA1LjIwMThdLCBbNDYuMzE2NiwgNS40NzE3XSwgWzQ2LjM0NDQsIDUuNjQyNV0sIFs0Ni4yNjU4LCA1Ljc1MDZdLCBbNDYuMjY5MSwgNS44NjY4XSwgWzQ2LjQxLCA0Ljg4ODRdLCBbNDYuNDAzLCA0Ljg4ODJdLCBbNDUuODYyNSwgNS4zMjZdLCBbNDYuMzQyNSwgNS42NDY3XSwgWzQ2LjQwODEsIDYuMDUwOF0sIFs0Ni4zNzI3LCA2LjE2NTFdLCBbNDYuMzM3MywgNi4xMzkyXSwgWzQ2LjI1MjYsIDYuMTIzOF0sIFs0Ni4yNTE3LCA2LjEyMzhdLCBbNDYuMjM5OSwgNi4wNTM4XSwgWzQ1LjgwOTQsIDUuMDYzNV0sIFs0Ni4xNDE5LCA1Ljk2NDZdLCBbNDUuODM4NSwgNC45MTg0XSwgWzQ2LjMwOTIsIDUuOTE4XSwgWzQ1Ljg2MDYsIDUuODA3NV0sIFs0Ni4zNjA4LCA1Ljk4M10sIFs0NS43OTc4LCA1Ljc4NDhdLCBbNDUuNjQ3NywgNS42MDMxXSwgWzQ1LjY4NDgsIDUuNTQ2OF0sIFs0NS43NDE2LCA1LjUwMV0sIFs0NS43NDQ3LCA1LjQ5OF0sIFs0Ni4zOTk3LCA1LjM0N10sIFs0Ni40NzQzLCA1LjIxNjJdLCBbNDYuNDUwNSwgNS4yNjc4XSwgWzQ2LjUwMTUsIDUuMTMzOF0sIFs0Ni41MDQ4LCA1LjEzNTNdLCBbNDYuNTAyNywgNS4xOTkzXSwgWzQ2LjQ0NzgsIDUuMjk4NF0sIFs0Ni40MzE0LCA1LjMxOThdLCBbNDYuNDI4NCwgNS4zMjQzXSwgWzQ2LjI5NDQsIDUuNTc3M10sIFs0Ni4zNzMsIDQuODYyOF0sIFs0Ni41MTQxLCA0Ljk1MjldLCBbNDYuNTA5NCwgNC45Njk2XSwgWzQ2LjEyODgsIDUuOTM2XSwgWzQ2LjE1NjIsIDUuOTczM10sIFs0Ni4xMDU1LCA1LjgzMzFdLCBbNDYuMTM2MSwgNS45NjQ5XSwgWzQ2LjM4OTEsIDYuMTMzNV0sIFs0Ni4zMTU0LCA2LjEyNDFdLCBbNDYuMjk3MSwgNi4xMjExXSwgWzQ2LjI2MDgsIDYuMTE5OF0sIFs0Ni4yNDE3LCA2LjA2NzhdLCBbNDYuMjMyNSwgNi4wMjIyXSwgWzQ2LjEwNTQsIDUuODI3OV0sIFs0NS44MzY4LCA0LjkxODldLCBbNDUuODcyMiwgNC45MDhdLCBbNDUuOTA3NSwgNC44MzJdLCBbNDUuODk2OSwgNC44MDc2XSwgWzQ1Ljk3MDksIDQuNzU0MV0sIFs0NS43NjgxLCA1LjQ2OTJdLCBbNDUuNzQwOCwgNS43Njk3XSwgWzQ1LjY0NzQsIDUuNjg5Ml0sIFs0NS43Mzc0LCA1LjUwNzddLCBbNDUuODM2MywgNS40Mjg1XSwgWzQ1Ljg4MTIsIDUuMzU4NV0sIFs0NS43MTk5LCA1LjUyMzZdLCBbNDUuODA5NiwgNS4wMjg5XSwgWzQ2LjQ2ODMsIDUuMjI1NV0sIFs0Ni40NDU3LCA1LjMwODFdLCBbNDYuMzkxMiwgNS4zNTk5XSwgWzQ2LjQ5NDksIDUuMjA0MV0sIFs0Ni40NTk4LCA1LjIzOTJdLCBbNDYuNTExMSwgNS4wMTA2XSwgWzQ2LjI5MDEsIDUuNDYwM10sIFs0Ni4yNjcxLCA1LjQ4NDldLCBbNDYuMjgyMiwgNS41NTgxXSwgWzQ2LjI4MTgsIDUuNzE1XSwgWzQ2LjUwNzgsIDQuOTcxNl0sIFs0Ni4yNjgxLCA1Ljg3NDddLCBbNDYuMjY0OCwgNS41MDhdLCBbNDYuMzQyMSwgNS40Mjc5XSwgWzQ2LjI4NjIsIDUuOTAxXSwgWzQ2LjE2NDQsIDUuOTc4N10sIFs0Ni4xNzgyLCA1Ljk5MTVdLCBbNDYuMzg3NiwgNi4wM10sIFs0Ni4yNDM3LCA2LjA3NDVdLCBbNDYuMjQxMiwgNi4wNzExXSwgWzQ2LjMwOTUsIDUuNjA1Ml0sIFs0Ni4xMTYxLCA1Ljg5MTJdLCBbNDYuMjY1MSwgNS43MzgzXSwgWzQ1LjkwNjgsIDQuODU1Ml0sIFs0NS45MDc2LCA0LjgzMjNdLCBbNDUuOTM3MiwgNC43NDY5XSwgWzQ2LjI2MjEsIDUuODQ5OF0sIFs0Ni4yMTM5LCA1Ljk3MzVdLCBbNDUuNzU4OCwgNS43Nzk0XSwgWzQ1LjY5NDcsIDUuNTczN10sIFs0Ni4wNTc5LCA1LjgxNF0sIFs0NS43OTUxLCA1LjE2OTRdLCBbNDYuNDQ1MiwgNS4zMDY3XSwgWzQ2LjUwMTUsIDUuMTM0NF0sIFs0Ni41MTM2LCA1LjE3NF0sIFs0Ni40OTI3LCA1LjIwNzhdLCBbNDYuNDM1NiwgNS4zMTc2XSwgWzQ2LjM1MywgNS4zNzM3XSwgWzQ2LjUwOTksIDUuMDA0OV0sIFs0Ni4yODMzLCA1LjQ1OTFdLCBbNDYuMjY4MSwgNS40OTQ0XSwgWzQ2LjI2MjIsIDUuODQ2M10sIFs0Ni4yMjc5LCA0Ljc5OTZdLCBbNDYuMjY1NCwgNC44MTY1XSwgWzQ2LjUwODIsIDQuOTQ0NV0sIFs0Ni41MTA0LCA0Ljk2NTddLCBbNDYuMTk1OCwgNC43ODcyXSwgWzQ2LjIwNDcsIDQuNzkzNF0sIFs0Ni4yMTU3LCA1Ljk3NThdLCBbNDYuMTAxNywgNC43NjE1XSwgWzQ2LjM0NjksIDUuNDIyNF0sIFs0Ni4zNDEsIDUuNjQ5M10sIFs0Ni4wMTc2LCA1LjgwNzldLCBbNDYuMjkxNCwgNS41NjM3XSwgWzQ1LjgxMDIsIDUuMjg4XSwgWzQ2LjM5NzUsIDYuMTEyOV0sIFs0Ni4zNDc4LCA2LjE1NF0sIFs0Ni4zMzU0LCA2LjEzNzNdLCBbNDYuMjc0NSwgNi4xMDk3XSwgWzQ2LjI0NDgsIDYuMDYzOV0sIFs0Ni4wNjM5LCA1LjgwNzZdLCBbNDYuMjA1OSwgNS45NzAyXSwgWzQ2LjM2MTcsIDUuOTgzNV0sIFs0Ni4yNjY1LCA1Ljc0NV0sIFs0NS44Mjc3LCA0LjkxOTddLCBbNDYuMDg3OCwgNS44NTQ0XSwgWzQ1LjgzNzEsIDQuOTE4XSwgWzQ1LjkwMTcsIDQuODcyMl0sIFs0NS43MDk4LCA1LjczNTRdLCBbNDUuNjQyMiwgNS42MDQ0XSwgWzQ1LjY3MjMsIDUuNTYwMV0sIFs0NS42OTU4LCA1LjU3MjVdLCBbNDUuNzY2NiwgNS40NzA0XSwgWzQ1LjgxMzUsIDUuMTAxMl0sIFs0Ni40ODk2LCA1LjIwNjZdLCBbNDYuNDQ2MywgNS4yODU4XSwgWzQ2LjUxNTIsIDUuMTcxNV0sIFs0Ni41MDYxLCA1LjAxMTZdLCBbNDYuNTAyOSwgNS4xMzAyXSwgWzQ2LjM0NzQsIDUuMzc4N10sIFs0Ni40MDE5LCA1LjM0MDhdLCBbNDYuNTEwOSwgNS4wMDM3XSwgWzQ2LjI2NjksIDUuNTA1NF0sIFs0Ni4yNjYzLCA1LjUwODJdLCBbNDYuNTA3NywgNC45NTk4XSwgWzQ2LjIyMDEsIDQuNzk1NF0sIFs0Ni4zMDQsIDQuODM2NV0sIFs0Ni4zMjcxLCA1LjY0NjNdLCBbNDUuODgxMSwgNS4zNDE4XSwgWzQ2LjAyODEsIDQuNzQ2NF0sIFs0Ni4xNjE1LCA0Ljc5NjldLCBbNDYuMDcwNywgNS44MDk1XSwgWzQ2LjM4MzksIDYuMDI0OF0sIFs0Ni4zOTk0LCA2LjEwODddLCBbNDYuMzY2LCA2LjE2OTVdLCBbNDYuMzMzOSwgNi4xMzkxXSwgWzQ2LjMwNTYsIDYuMTE5NF0sIFs0Ni4yODQ3LCA2LjEwMjddLCBbNDYuMzYyLCA1Ljk4MzRdLCBbNDYuMTg4MywgNS45ODY2XSwgWzQ1LjgwODMsIDUuMDIyM10sIFs0Ni4yNzIsIDUuODgwN10sIFs0NS43MDA2LCA1LjcwMTZdLCBbNDUuODU3OSwgNS40MDNdLCBbNDUuODEwOSwgNS4wNTcyXSwgWzQ1LjgxMDUsIDQuOTE4M10sIFs0Ni4zNDU4LCA1Ljk3MTNdLCBbNDUuNzE0NSwgNS43NjAxXSwgWzQ1LjYzODcsIDUuNjU5NV0sIFs0NS43MDczLCA1LjU1NDRdLCBbNDUuNzc4NCwgNS4yNDE5XSwgWzQ1Ljc3MjMsIDUuMTkwM10sIFs0NS44MDM0LCA1LjE1OF0sIFs0Ni40OTYsIDUuMjAzOV0sIFs0Ni40MjM2LCA1LjMxMDVdLCBbNDYuMzk3OCwgNS4zMzM2XSwgWzQ2LjQzMTIsIDUuMzE5OV0sIFs0Ni4zODc4LCA1LjM2ODVdLCBbNDYuMzQxNywgNS4zODk5XSwgWzQ2LjMzMjEsIDUuNDE1Nl0sIFs0Ni41LCA1LjA5NzFdLCBbNDYuNDk5NSwgNS4xMjc1XSwgWzQ2LjUwODksIDUuMTM2OV0sIFs0Ni4yMjk1LCA0LjgwMDRdLCBbNDYuNDM4NiwgNC44OTE4XSwgWzQ2LjQwNDgsIDQuODg4OF0sIFs0Ni40ODAxLCA0LjkxNDVdLCBbNDYuNTE0NCwgNC45NTEzXSwgWzQ2LjIyMDUsIDQuNzk1N10sIFs0Ni4zMDcyLCA1LjQ3MTldLCBbNDYuMzg4MywgNi4wMzExXSwgWzQ2LjM5OTMsIDYuMTA3M10sIFs0Ni4zMzc0LCA2LjEzOTRdLCBbNDYuMzM2MywgNi4xMzc5XSwgWzQ2LjI2OTksIDUuODc5MV0sIFs0Ni4zMzEsIDYuMTM2NF0sIFs0Ni4zMSwgNi4xMTk3XSwgWzQ2LjI3ODMsIDYuMTA0M10sIFs0Ni4yNDM1LCA2LjA3NTZdLCBbNDYuMjI2NiwgNi4wMDY5XSwgWzQ2LjA3ODQsIDUuODExNF0sIFs0NS44MDk4LCA1LjAzOTldLCBbNDYuMjc4NCwgNS41NTE1XSwgWzQ1LjgyODEsIDQuOTIwM10sIFs0NS44NjQ4LCA0LjkwMzRdLCBbNDUuOTYyLCA0Ljc0OF0sIFs0NS43NzM0LCA1LjIzMzZdLCBbNDUuODA4MywgNS43ODY1XSwgWzQ1LjY3MzQsIDUuNjk1M10sIFs0NS42NjkyLCA1LjY4OTFdLCBbNDUuNjg0OSwgNS41NzE2XSwgWzQ1LjcxNTUsIDUuNTI3M10sIFs0Ni4wNjA2LCA1LjgwODNdLCBbNDUuODc1NywgNS4zNjg5XSwgWzQ2LjQ1ODYsIDUuMjM0Nl0sIFs0Ni40NTc4LCA1LjIzNjNdLCBbNDYuMzQ0MywgNS4zODRdLCBbNDYuNTAyNSwgNS4xMzU1XSwgWzQ2LjUwNzksIDUuMTQzNF0sIFs0Ni4zMzU2LCA1LjQyODNdLCBbNDYuMjY4MSwgNS40OTFdLCBbNDYuMjYzNSwgNS43MjA5XSwgWzQ2LjI2MzMsIDUuNzMxOF0sIFs0Ni4yNjYyLCA1Ljc0NjhdLCBbNDYuNTA4MywgNC45NzEzXSwgWzQ2LjUwNTMsIDQuOTU2M10sIFs0Ni4yOTQ3LCA0LjgzMTNdLCBbNDYuMjYxOCwgNS44MjM1XSwgWzQ2LjExOTEsIDUuODkzXSwgWzQ2LjExOTksIDUuODk3Ml0sIFs0NS44NTM3LCA1LjQwODZdLCBbNDUuODk1NiwgNC44NzU2XSwgWzQ1Ljg2MDEsIDUuMzE4Ml0sIFs0Ni40MDQ2LCA2LjEwMDNdLCBbNDYuMzMwNywgNi4xMzY5XSwgWzQ2LjA5MDUsIDUuODUwN10sIFs0Ni4zMTk1LCA1LjY3NDVdLCBbNDYuMTQ0NCwgNS45NjQ2XSwgWzQ1LjkzNzEsIDQuNzc5MV0sIFs0NS45NzIzLCA0Ljc1NDVdLCBbNDUuNzM0LCA1Ljc3MzNdLCBbNDUuNzIzNiwgNS43NzMzXSwgWzQ1LjcyMjgsIDUuNzcxNl0sIFs0NS43MTAyLCA1LjczNjddLCBbNDUuNzM0NCwgNS41MTI2XSwgWzQ1LjgyMiwgNS40MjEyXSwgWzQ1LjgzMjUsIDUuNDMzNF0sIFs0Ni4zMTU3LCA1LjQzNzhdLCBbNDYuMzE4MSwgNS40NDddLCBbNDYuNDI2NiwgNS4zMTc1XSwgWzQ2LjQ1MDEsIDUuMjcxN10sIFs0Ni4yODg2LCA1LjQ1OTRdLCBbNDYuMzMyNCwgNS42MzQxXSwgWzQ2LjMyMzgsIDUuNjY5NF0sIFs0Ni4zMDkyLCA1LjcxMzldLCBbNDYuMzYyNCwgNS45ODM2XSwgWzQ2LjM2NDQsIDUuOTg4MV0sIFs0Ni4zMTc4LCA0Ljg0NTNdLCBbNDYuMzQ0OCwgNS42NDMxXSwgWzQ2LjEwMjksIDQuNzYzMV0sIFs0Ni40MTU4LCA2LjA1NjNdLCBbNDYuMzc5LCA2LjE1OTldLCBbNDYuMzMwOSwgNS40MzIxXSwgWzQ2LjMyODksIDYuMTM1NV0sIFs0Ni4zMDkxLCA1LjcxNDVdLCBbNDYuMjQxNSwgNi4wNzMyXSwgWzQ2LjI2NDIsIDUuNTIwM10sIFs0NS44OTM3LCA0Ljg3MzhdLCBbNDUuOTI0LCA0Ljc4ODZdLCBbNDYuMzEyOSwgNS45NDQ2XSwgWzQ2LjAwOTksIDUuODEwOV0sIFs0Ni4zNDU0LCA1Ljk3XSwgWzQ1Ljk0MDMsIDUuODI4NF0sIFs0NS43MTk1LCA1Ljc2NDRdLCBbNDUuNzE4MywgNS43NjMxXSwgWzQ1LjY2MiwgNS42ODM3XSwgWzQ2LjM3NDUsIDYuMTYxM10sIFs0Ni4zMDI0LCA2LjExODddLCBbNDUuNjMyMiwgNS42NDg4XSwgWzQ2LjQwMjUsIDUuMzNdLCBbNDYuNDU2MiwgNS4yNTIzXSwgWzQ2LjQ5ODcsIDUuMDIwNV0sIFs0Ni41MDI4LCA1LjIwMDVdLCBbNDYuNDg2MiwgNS4yMDY3XSwgWzQ2LjQ3NjgsIDUuMjEyN10sIFs0Ni40MTU0LCA1LjMxMDFdLCBbNDYuMjY2NCwgNS43NTUzXSwgWzQ2LjI2MjYsIDUuODQyMl0sIFs0Ni4zNDkzLCA1Ljk3NDddLCBbNDYuNDE1NSwgNC44ODg0XSwgWzQ2LjUxNjMsIDQuOTRdLCBbNDYuNTE3MiwgNC45NF0sIFs0Ni41MDI5LCA0Ljk1MjRdLCBbNDUuODgwNywgNS4zNTk5XSwgWzQ1LjgwMzUsIDUuMjc3N10sIFs0Ni4wMjksIDQuNzQ2N10sIFs0Ni4wNjA1LCA1LjgwODRdLCBbNDYuMzY5MiwgNS4zNjgyXSwgWzQ2LjM1OSwgNi4xNjA2XSwgWzQ2LjI4NjIsIDYuMTA0MV0sIFs0Ni4zMjQ4LCA1LjY2MjJdLCBbNDYuMjUzMiwgNi4xMjI1XSwgWzQ2LjI0NDUsIDYuMDc4Ml0sIFs0Ni4yNDQzLCA2LjA3NjddLCBbNDYuMjE2NSwgNS45Nzc0XSwgWzQ2LjMxMTMsIDUuOTQxN10sIFs0Ni4xNjI2LCA1Ljk3NzFdLCBbNDUuODcxNiwgNC45MDc3XSwgWzQ2LjE5OCwgNS45NjQyXSwgWzQ1LjkxMDgsIDQuODUxNF0sIFs0NS45NTYsIDQuNzM4Nl0sIFs0Ni4xMzI1LCA1Ljk1NjRdLCBbNDUuNzEwMSwgNS43MzEzXSwgWzQ1LjY2NDgsIDUuNjg0Ml0sIFs0NS42NTUxLCA1LjY4N10sIFs0NS42MTEsIDUuNjI3NV0sIFs0NS44MTg5LCA1LjQyMDVdLCBbNDYuMDg1MSwgNS44ODQ3XSwgWzQ1Ljg4MTQsIDUuMzU4XSwgWzQ2LjQ0NjcsIDUuMjhdLCBbNDYuMzQyNCwgNS4zODg1XSwgWzQ2LjMxNzUsIDUuNDQ2MV0sIFs0Ni4zMjMxLCA1LjQ2XSwgWzQ2LjQ1OTUsIDUuMjQ2Nl0sIFs0Ni41MDQ3LCA1LjIwMjNdLCBbNDYuMjY3MywgNS40NzIyXSwgWzQ2LjMwMjcsIDUuNjAwNF0sIFs0Ni4zMTMyLCA1LjYwNjJdLCBbNDYuMzI0NCwgNS42Njg0XSwgWzQ2LjI1NDUsIDQuODEwOF0sIFs0Ni4yOTgzLCA0LjgzMjRdLCBbNDYuNTA4MiwgNC45NjE3XSwgWzQ2LjMxNSwgNS40NzUxXSwgWzQ2LjAzMTUsIDQuNzQ3XSwgWzQ2LjA4NTQsIDQuNzQ3XSwgWzQ2LjExNDEsIDUuODg5M10sIFs0Ni4wOTYzLCA0Ljc1NDVdLCBbNDYuMzc4NCwgNi4wMTc3XSwgWzQ2LjMzOTIsIDYuMTM5NV0sIFs0Ni4zMzg2LCA2LjEzOF0sIFs0Ni4zMTQ2LCA2LjEyMjZdLCBbNDYuMjk2OCwgNi4xMjExXSwgWzQ2LjI3MDksIDYuMTEwNl0sIFs0NS44NjksIDUuMzMzNl0sIFs0NS44MTkyLCA0LjkyMTldLCBbNDUuOTA2NSwgNC44MzAzXSwgWzQ2LjI3MDIsIDUuNzIwM10sIFs0NS44ODg1LCA1LjgyXSwgWzQ1LjgwOCwgNS43ODY2XSwgWzQ1LjY5OTIsIDUuNzAyN10sIFs0NS42Njc1LCA1LjU4NTRdLCBbNDUuNjcyMywgNS41NTMzXSwgWzQ1Ljg2MDMsIDUuMzk4Nl0sIFs0NS43OTQsIDUuMjcyN10sIFs0Ni40Njg3LCA1LjIyMV0sIFs0Ni40OTk1LCA1LjA5Nl0sIFs0Ni40OTU2LCA1LjEwMDVdLCBbNDYuNDQ5OCwgNS4yOTI3XSwgWzQ2LjI2ODksIDUuNDY4XSwgWzQ2LjI2NDUsIDUuNzE5N10sIFs0Ni4xNzY2LCA1Ljk5MTRdLCBbNDYuMTMsIDUuOTI1OV0sIFs0Ni4xMjk0LCA1LjkxNjldLCBbNDYuMTAxOSwgNS44MjE2XSwgWzQ2LjQxOTEsIDQuODg5Ml0sIFs0Ni40MDYxLCA0Ljg4OV0sIFs0Ni4zNzM0LCA0Ljg2MzNdLCBbNDYuMDYwMiwgNC43NThdLCBbNDYuMzI3MSwgNS40MzMzXSwgWzQ2LjA1OTIsIDQuNzU3XSwgWzQ1Ljg2MiwgNS4zMjQyXSwgWzQ1Ljc4ODcsIDUuMjY1NF0sIFs0NS45MzI3LCA0Ljc4MjddLCBbNDYuMDg5MSwgNS44NTNdLCBbNDUuNzc0NywgNS4xODhdLCBbNDYuMjY5MiwgNS43MjA2XSwgWzQ2LjM5OTQsIDYuMTA5Ml0sIFs0Ni4zMDA1LCA2LjEyMTZdLCBbNDYuMjkzMiwgNi4xMTI2XSwgWzQ2LjI2NDgsIDYuMTIwMV0sIFs0Ni4yNDQ1LCA2LjA3NzVdLCBbNDYuMjQyMiwgNi4wNTc0XSwgWzQ2LjIyMDksIDYuMDAyNl0sIFs0NS44MTEyLCA1LjEyMTddLCBbNDUuODA3OCwgNS4xMTE1XSwgWzQ1LjgxNDEsIDQuOTE5Ml0sIFs0Ni4yODYxLCA1LjkwMTddLCBbNDUuODQzMywgNC45MTc3XSwgWzQ1LjkwOTIsIDQuODM1NV0sIFs0Ni4xNTE1LCA1Ljk2ODldLCBbNDUuOTA2NSwgNC44MDk2XSwgWzQ1LjkzNiwgNC43NTAxXSwgWzQ1Ljk0NzEsIDUuODMyN10sIFs0Ni4xMzEyLCA1LjkyMDNdLCBbNDUuNzA4MSwgNS43MTY5XSwgWzQ1LjY3MzEsIDUuNTY3M10sIFs0NS42NzkxLCA1LjU1MzZdLCBbNDUuNjk4MywgNS41NTIxXSwgWzQ1LjY5OTYsIDUuNTYzXSwgWzQ2LjUwNTIsIDUuMjAzM10sIFs0Ni41MDE2LCA1LjIwMDFdLCBbNDYuNDQ3MiwgNS4yODFdLCBbNDYuMzIyNSwgNS40NjIxXSwgWzQ2LjUwODksIDUuMTkyNl0sIFs0Ni40NTc5LCA1LjIzNTJdLCBbNDYuNTEyOCwgNS4xNzQyXSwgWzQ2LjQ5NTQsIDUuMDI2M10sIFs0Ni40ODQ5LCA1LjA1MjRdLCBbNDYuNDkxOSwgNS4wODczXSwgWzQ2LjUxMjQsIDQuOTMzNl0sIFs0Ni41MDU1LCA0Ljk3MDRdLCBbNDYuNDEzMywgNC44ODhdLCBbNDYuNTE0NCwgNC45NDQ1XSwgWzQ2LjEyMDIsIDUuOTA0M10sIFs0NS43NzE1LCA1LjIwMDhdLCBbNDUuODA1NSwgNC45ODA1XSwgWzQ1LjgwNzIsIDQuOTcxM10sIFs0NS44MDc2LCA0Ljk2OTldLCBbNDUuODEwOSwgNC45NjM5XSwgWzQ1LjgwODgsIDQuOTUxNV0sIFs0NS44MDk1LCA0Ljk0MzhdLCBbNDUuODA4NywgNC45NDFdLCBbNDYuMjY3NywgNS41MzMzXSwgWzQ1Ljc5NzYsIDUuMTY2Ml0sIFs0Ni40MTExLCA2LjA4N10sIFs0Ni4zNDg3LCA2LjE1NTVdLCBbNDYuMzQyNCwgNi4xNDhdLCBbNDYuMzM5MiwgNi4xNDAxXSwgWzQ2LjMxMzgsIDYuMTIxOV0sIFs0Ni4yOTY0LCA2LjEyMDRdLCBbNDYuMjkxNywgNi4xMTE0XSwgWzQ1LjgxMTQsIDUuMTA0NF0sIFs0Ni4wNDEsIDUuODA4MV0sIFs0NS44OTQxLCA1LjgyMjNdLCBbNDUuODg3NSwgNS44MTk1XSwgWzQ1Ljg0NTgsIDUuODAxMV0sIFs0NS43OTUxLCA1Ljc4NDJdLCBbNDUuNzgwOCwgNS43ODE0XSwgWzQ1LjcxNjEsIDUuNzYxM10sIFs0NS42MTYsIDUuNjM2M10sIFs0Ni4zMjA3LCA1LjQzNTJdLCBbNDYuMzE5NSwgNS40MzU0XSwgWzQ2LjQxNTksIDUuMjk5N10sIFs0Ni4zMTg2LCA1LjQ0NDJdLCBbNDYuNTAyOSwgNS4xOTg5XSwgWzQ2LjQ4NjMsIDUuMjA3OV0sIFs0Ni40OTAxLCA1LjA0NDhdLCBbNDYuNTEzNCwgNS4xNzNdLCBbNDYuNDAzNCwgNS4zMjQxXSwgWzQ2LjM5OTcsIDUuMzQ1MV0sIFs0Ni41MTUxLCA0Ljk3OTldLCBbNDUuODA1MywgNS4yOF0sIFs0Ni4wMjc4LCA0Ljc0NjRdLCBbNDYuMDk5NiwgNC43NTg2XSwgWzQ2LjMwOTUsIDUuNzA5Nl0sIFs0Ni4wOTkxLCA1Ljg5MjldLCBbNDYuMzI2OCwgNS42NDUyXSwgWzQ2LjM4NjgsIDYuMDI5NV0sIFs0Ni4zNDczLCA2LjE1MjhdLCBbNDYuMzE5LCA2LjEyNTJdLCBbNDYuMjQxLCA2LjEwNzJdLCBbNDYuMjMxLCA2LjAxNDFdLCBbNDUuODU0OSwgNS4zMDkyXSwgWzQ1Ljc5ODQsIDUuMTA4M10sIFs0NS42OTg3LCA1LjU2NTRdLCBbNDUuODU1LCA0LjkwMzFdLCBbNDYuMTA5NywgNS44ODYzXSwgWzQ2LjE4NjYsIDUuOTkyMl0sIFs0NS45MzcyLCA0Ljc2NjFdLCBbNDUuOTM3NCwgNC43NDQ1XSwgWzQ1LjcwNjMsIDUuNzUyNl0sIFs0NS42MjY2LCA1LjYxNDFdLCBbNDUuNzAwNiwgNS41NTQ2XSwgWzQ2LjEwMiwgNS44NDAxXSwgWzQ1LjcxMDQsIDUuNTUxNl0sIFs0NS43MTY3LCA1LjUyNTddLCBbNDUuODI0MywgNS40MzA5XSwgWzQ2LjQyNjIsIDUuMzEzN10sIFs0Ni4zNjQ3LCA1LjM3NDddLCBbNDYuNDg4NCwgNS4yMDU2XSwgWzQ2LjQ3NCwgNS4yMTYxXSwgWzQ2LjQ5MzEsIDUuMjA2OV0sIFs0Ni40MTY4LCA1LjMwNzddLCBbNDYuMzczMiwgNS4zNjUzXSwgWzQ2LjUwMDksIDUuMDEzNF0sIFs0Ni40OTAzLCA1LjA4MzRdLCBbNDYuNDkxNSwgNS4xMDkzXSwgWzQ2LjI1NjksIDQuODEwOV0sIFs0Ni4wNTk3LCA0Ljc1NzZdLCBbNDYuMzEzNCwgNS45MjddLCBbNDYuMDYxMiwgNC43NTkxXSwgWzQ1LjgwNjUsIDUuMjgxM10sIFs0Ni4yODc2LCA1LjQ1OTddLCBbNDUuOTM1OCwgNC43NTA2XSwgWzQ2LjA2MDcsIDUuODA4Ml0sIFs0Ni4zOTk0LCA2LjEwNThdLCBbNDYuMzQ5NSwgNi4xNTYxXSwgWzQ2LjMxMDMsIDYuMTE5NV0sIFs0Ni4yODA5LCA2LjEwNDVdLCBbNDYuMjcyNiwgNi4xMTM1XSwgWzQ2LjIzNzUsIDYuMTAxNV0sIFs0Ni4yNDQ3LCA2LjA3ODZdLCBbNDYuNTE0NywgNS4xNjY4XSwgWzQ2LjUxNTYsIDUuMTY2OF0sIFs0Ni40NDQ1LCA1LjMxNDldLCBbNDYuNDU2MiwgNS4yNTRdLCBbNDYuNDU4OSwgNS4yMzddLCBbNDYuNDQ2OSwgNS4yNzk4XSwgWzQ2LjQyOTEsIDUuMzI0MV0sIFs0Ni4zNDE1LCA1LjQyNDddLCBbNDYuNDAwMSwgNS4zMzE2XSwgWzQ2LjMyMDMsIDUuNDA0Nl0sIFs0Ni4yMTUzLCA1Ljk3NTFdLCBbNDYuMDQxNCwgNS44MDc4XSwgWzQ1Ljg3NzMsIDQuODk2MV0sIFs0Ni4yOTM3LCA1LjU5MjNdLCBbNDYuMTE4NSwgNS44OTI0XSwgWzQ1LjgyODQsIDUuNzkyN10sIFs0NS43NjA2LCA1Ljc3OV0sIFs0NS42NTkzLCA1LjY4NDRdLCBbNDUuNjU2NCwgNS42ODU5XSwgWzQ1LjY0MjIsIDUuNjg2MV0sIFs0NS43Nzg1LCA1LjQ2MDNdLCBbNDYuNDg0NSwgNS4yMTM2XSwgWzQ2LjQwMTYsIDUuMzMwOV0sIFs0Ni4zMjI1LCA1LjQ1ODddLCBbNDYuNDQ1NSwgNS4yODM2XSwgWzQ2LjQ2ODQsIDUuMjE3OV0sIFs0Ni40ODYzLCA1LjIwNTldLCBbNDYuNDIzMSwgNS4zMTFdLCBbNDYuNTAyNiwgNS4xMzU3XSwgWzQ2LjUwODQsIDUuMTQxOV0sIFs0Ni41MTQ5LCA1LjE3MjFdLCBbNDYuNDkxOCwgNC45MTgyXSwgWzQ2LjM2MTMsIDUuOTgyOV0sIFs0Ni4xMjgzLCA1Ljk0Ml0sIFs0Ni4xMjc5LCA1LjkyNl0sIFs0Ni40ODk2LCA1LjIwNjJdLCBbNDYuMTU2OSwgNC44MDI0XSwgWzQ1Ljg4MzMsIDUuMzUzOF0sIFs0Ni4zNDUzLCA1LjM4MTldLCBbNDYuMzIzNywgNi4xMzA5XSwgWzQ2LjMwNDYsIDYuMTJdLCBbNDYuMjQ0NiwgNi4wNzcyXSwgWzQ2LjI0MywgNi4wNzI5XSwgWzQ2LjI0MSwgNi4wNjk3XSwgWzQ2LjIzOSwgNi4wNTI4XSwgWzQ2LjA4NTYsIDUuODg2M10sIFs0NS43NzM5LCA1LjE4ODVdLCBbNDUuODQyLCA0LjkxNzZdLCBbNDUuOTIyMSwgNC43OTU2XSwgWzQ1Ljk2MjQsIDQuNzQ4NV0sIFs0NS44MTUxLCA1Ljc4NF0sIFs0NS43NjUsIDUuNzgxXSwgWzQ1LjcwNjUsIDUuNjk5OV0sIFs0NS42MTMzLCA1LjYyMzddLCBbNDUuNjI1NCwgNS42MTQ5XSwgWzQ1LjY3MjQsIDUuNTU2OV0sIFs0NS43NzAzLCA1LjIxMjNdLCBbNDYuNDI1NSwgNS4zMTU4XSwgWzQ2LjMxNjgsIDUuNDQwOF0sIFs0Ni4zODE0LCA1LjM3N10sIFs0Ni40ODM5LCA1LjIxMzddLCBbNDYuNDgzLCA1LjIxMzddLCBbNDYuNDQxNiwgNS4zMTQzXSwgWzQ2LjMxNTUsIDUuNDc0Nl0sIFs0Ni4yODk0LCA1LjkxMzRdLCBbNDYuMzE4NiwgNS45NDg1XSwgWzQ2LjMyMzIsIDUuOTUxNV0sIFs0Ni4wNTc1LCA0Ljc1NTJdLCBbNDYuMTA1MiwgNC43NjU5XSwgWzQ1LjgwMTYsIDUuMTYxMV0sIFs0Ni4zODMsIDYuMDIxNF0sIFs0Ni40MTc0LCA2LjA2MV0sIFs0Ni4zMjM1LCA1LjYxMDRdLCBbNDYuMzA5NSwgNS43MTEyXSwgWzQ2LjI2NjMsIDUuNzIwMl0sIFs0Ni4zNDQ3LCA2LjE1MDldLCBbNDYuMzIxMiwgNi4xMjY3XSwgWzQ2LjI5OTUsIDYuMTIyXSwgWzQ2LjIzMTgsIDYuMDE2N10sIFs0Ni4wOTA4LCA1LjgyMjJdLCBbNDUuNjMxNCwgNS42NDg2XSwgWzQ1LjY1NDMsIDUuNl0sIFs0NS42OTY1LCA1LjU1N10sIFs0Ni4zMDk0LCA1LjYwMzZdLCBbNDYuMzQwMywgNS42NDA0XSwgWzQ2LjMxMywgNi4xMjAyXSwgWzQ1LjgzNDcsIDUuMjk5N10sIFs0Ni41MDg4LCA1LjE4NjZdLCBbNDYuNDYxMiwgNS4yNDE4XSwgWzQ2LjQ5NDEsIDUuMjA1Ml0sIFs0Ni40ODk4LCA1LjIwOTVdLCBbNDYuNDUwNywgNS4yNjNdLCBbNDYuMzIyNCwgNS40NjQyXSwgWzQ2LjMwNTUsIDUuNDcwNF0sIFs0Ni4zMTU3LCA1LjYwNzRdLCBbNDYuMzE4MSwgNS42MDg5XSwgWzQ2LjMzMDIsIDUuNjMwNV0sIFs0Ni4zMjkyLCA1Ljk1NzVdLCBbNDUuNzg0MywgNS4yNTU2XSwgWzQ1Ljk0MTgsIDQuNzMwOV0sIFs0Ni4zMzM1LCA1Ljk1OTNdLCBbNDYuMzM3MSwgNi4xMzc3XSwgWzQ2LjI2NTgsIDYuMTE3OF0sIFs0Ni4yNDY5LCA2LjA4NDRdLCBbNDYuMjM4LCA2LjA1MjNdLCBbNDYuMDE0MywgNS44MDU2XSwgWzQ1Ljc3MTQsIDUuMTkyOV0sIFs0NS44MTE1LCA1LjA4OTFdLCBbNDYuMDEwOSwgNS44MTAyXSwgWzQ1LjgxMTcsIDUuMDUzNF0sIFs0Ni41MDQ2LCA1LjE2MzFdLCBbNDUuODYyMiwgNC45MDE1XSwgWzQ1Ljg5NzYsIDQuODEwM10sIFs0NS43NTM4LCA1Ljc4MzNdLCBbNDUuNjQwMiwgNS42MDYzXSwgWzQ1LjY3MjEsIDUuNTU3N10sIFs0Ni4yMTU2LCA1Ljk3NThdLCBbNDUuNjg5NCwgNS41NzU5XSwgWzQ1LjcyODEsIDUuNTE5Nl0sIFs0NS43NzMxLCA1LjQ2NDRdLCBbNDYuNTA1OSwgNS4wMTJdLCBbNDYuNDk0NSwgNS4wMjddLCBbNDYuNTA1LCA1LjEzNTFdLCBbNDYuNTA5MywgNS4xMzg1XSwgWzQ2LjUwNDYsIDUuMTY3Ml0sIFs0Ni40NzM3LCA1LjIxNl0sIFs0Ni4zMTc2LCA1LjQ1NTVdLCBbNDYuNDQ2OCwgNS4zMTA2XSwgWzQ2LjM0MjIsIDUuNDI3OV0sIFs0Ni4zMTk4LCA1LjYxMDldLCBbNDYuMzA5NSwgNS45MzddLCBbNDUuODExNiwgNS4xMjAzXSwgWzQ1Ljg3NSwgNS4zNzA5XSwgWzQ2LjA3MTYsIDQuNzYwNV0sIFs0Ni4yNzMxLCA1LjcxODldLCBbNDUuOTM5NywgNC43MzM5XSwgWzQ2LjEwMzcsIDUuODIzNl0sIFs0Ni4yODY2LCA1Ljg5NDZdLCBbNDUuNzc3MSwgNS4xODc0XSwgWzQ2LjMxMjQsIDUuOTQzNV0sIFs0Ni4zNDE1LCA2LjE0NF0sIFs0Ni4yNTY3LCA2LjEyMjZdLCBbNDYuMjMxNiwgNi4wMTc1XSwgWzQ2LjIzMDMsIDYuMDEyOF0sIFs0Ni4xMzU3LCA1Ljk2MzldLCBbNDUuNjY5MSwgNS41Nzg2XSwgWzQ1Ljc4NjcsIDUuNDQ2NF0sIFs0NS44MTk4LCA0LjkyMTldLCBbNDUuODIwMywgNS4yOTA2XSwgWzQ1Ljg2MzIsIDQuOTAyXSwgWzQ1LjkwNjgsIDQuODUzMl0sIFs0NS45MTEzLCA0Ljg0NF0sIFs0NS45MjI1LCA0Ljc5MDldLCBbNDUuOTUzNCwgNC43MzQ0XSwgWzQ2LjE0NzUsIDUuOTY2OF0sIFs0NS45MTQ0LCA1LjgyOTRdLCBbNDUuOTA4MSwgNS44Mjc5XSwgWzQ1LjYzODEsIDUuNjY0OF0sIFs0NS42MzU1LCA1LjY1MTFdLCBbNDUuNjU1NiwgNS41OTc2XSwgWzQ1LjcxNDYsIDUuNTI5MV0sIFs0NS44NDQ4LCA1LjQxNjFdLCBbNDYuNDE2LCA1LjMxMjRdLCBbNDYuNDk2MiwgNS4wMjZdLCBbNDYuNTEyOCwgNS4xNzM3XSwgWzQ2LjUxMjIsIDUuMTc1Ml0sIFs0Ni41MTE1LCA1LjE3NjddLCBbNDYuNDU5NywgNS4yNDU2XSwgWzQ2LjQ3ODksIDUuMjEwM10sIFs0Ni40NDYyLCA1LjI4MjJdLCBbNDYuMjg5NSwgNS40NjJdLCBbNDYuMjIyMSwgNS45OTY5XSwgWzQ2LjUxMjEsIDQuOTMzM10sIFs0Ni4zMjEsIDQuODQ3OV0sIFs0Ni4yNjMyLCA1Ljg1NDhdLCBbNDYuMDQ4MiwgNC43Mzk4XSwgWzQ2LjA4NTksIDUuODU3Nl0sIFs0NS42ODcsIDUuNTYxMl0sIFs0Ni4zNjc1LCA2LjE3MDRdLCBbNDYuMjk0NSwgNi4xMTQxXSwgWzQ2LjI3ODcsIDYuMTAzNF0sIFs0Ni4yNDY4LCA2LjA4ODJdLCBbNDYuMjQ0NiwgNi4wNzc1XSwgWzQ1LjgwNDksIDUuMTQzM10sIFs0Ni4xOTcsIDUuOTYzN10sIFs0NS44NDQxLCA0LjkxNzVdLCBbNDUuODY1NCwgNC45MDRdLCBbNDUuODkzNSwgNC44NzM0XSwgWzQ1Ljg5NywgNC44MDQ3XSwgWzQ1Ljk4NDQsIDQuNzQ5OV0sIFs0Ni4zMjQzLCA1LjY2N10sIFs0NS42MjY4LCA1LjY0ODJdLCBbNDYuMjY1OCwgNS43NTFdLCBbNDUuNzU2NywgNS40ODA2XSwgWzQ1Ljc4NiwgNS4xODMzXSwgWzQ1Ljc5MDYsIDUuMTgwM10sIFs0NS44MTM0LCA1LjEwMTFdLCBbNDYuMzIyOSwgNS40NjA2XSwgWzQ2LjMxMTQsIDUuNDA0NV0sIFs0Ni40ODU3LCA1LjA2NTldLCBbNDYuNTA0NSwgNS4xNjM1XSwgWzQ2LjQwMjEsIDUuMzI4M10sIFs0Ni4zOTI0LCA1LjM2M10sIFs0Ni40NDkxLCA1LjI5NDddLCBbNDYuMzg5MiwgNS4zNjMyXSwgWzQ2LjI3MDUsIDUuNzE5OF0sIFs0Ni4yNjUsIDUuODY5Ml0sIFs0Ni4xNjA2LCA1Ljk3NjJdLCBbNDYuMTcwNSwgNC43ODI5XSwgWzQ2LjE3MDQsIDUuOTg3NF0sIFs0Ni4zMjg0LCA2LjEzNThdLCBbNDYuMjQ3OCwgNi4xMjA0XSwgWzQ1LjgyNzIsIDUuNDM2M10sIFs0Ni4zMjk1LCA1LjYyNTNdLCBbNDUuODU3NiwgNC45MDEzXSwgWzQ2LjI4MzksIDUuOTA5Ml0sIFs0NS44OTg5LCA0LjgwMzldLCBbNDUuOTMwNSwgNC43ODRdLCBbNDUuOTA1NSwgNS44MjddLCBbNDUuNzI3MywgNS43NzY1XSwgWzQ1LjY2MzcsIDUuNjgzOF0sIFs0Ni40OTE4LCA1LjAzNTFdLCBbNDUuNzM2NiwgNS41MDkzXSwgWzQ1Ljc3MTgsIDUuMjMxMV0sIFs0NS44MDI5LCA1LjE1OTRdLCBbNDYuNDg5NCwgNS4wODAxXSwgWzQ2LjUwNzYsIDUuMTQzOV0sIFs0Ni40MzEyLCA1LjMxOTJdLCBbNDYuNDQ3MSwgNS4yODExXSwgWzQ2LjQ1ODYsIDUuMjM3XSwgWzQ2LjM5ODQsIDUuMzMxNl0sIFs0Ni4yODY4LCA1LjU2MTddLCBbNDYuMjk0MSwgNS41NjY0XSwgWzQ2LjI2OCwgNS43Njg5XSwgWzQ2LjMxMjksIDUuOTQ1N10sIFs0Ni41MTM5LCA0Ljk0NzZdLCBbNDYuNDgzOSwgNC45MTQyXSwgWzQ2LjE4MTIsIDQuNzgwMl0sIFs0Ni4xNzcxLCA0Ljc4MDJdLCBbNDUuODA3NiwgNS4yODI1XSwgWzQ2LjE3MzIsIDQuNzgxNV0sIFs0Ni4wODY4LCA1Ljg1NTddLCBbNDYuMzk4NCwgNi4xMTYyXSwgWzQ2LjM2NzksIDYuMTY5N10sIFs0Ni4yNDM1LCA2LjA3NDldLCBbNDYuMjY2NSwgNS43NTY3XSwgWzQ2LjI5MTgsIDUuNDY0OV0sIFs0NS45MDk3LCA0LjgzNjNdLCBbNDYuMTg3OSwgNS45OV0sIFs0NS45NTYyLCA1LjgzMzVdLCBbNDUuNjIxOCwgNS42MzddLCBbNDUuNjg0NywgNS41NjM4XSwgWzQ1Ljc4NDEsIDUuNDUwOF0sIFs0NS44MjQ0LCA1LjQyOTZdLCBbNDYuMDUxOSwgNS44MTI4XSwgWzQ1LjgyNDcsIDUuNDM0MV0sIFs0Ni40ODk2LCA1LjA4MDZdLCBbNDYuNDkyNywgNS4xMDY1XSwgWzQ2LjQyMjYsIDUuMzA3N10sIFs0Ni40OTI3LCA1LjIwODRdLCBbNDYuNTExNywgNS4xNzY1XSwgWzQ2LjQyNzIsIDUuMzE4NF0sIFs0Ni4yNzQ5LCA1LjU0N10sIFs0Ni4yOTM1LCA1LjU2NTJdLCBbNDYuMzM0OSwgNS42MzY3XSwgWzQ2LjI2MTUsIDUuODUzMV0sIFs0Ni40Mzk5LCA0Ljg5MThdLCBbNDYuNTAwNCwgNC45NTExXSwgWzQ2LjUxMTgsIDQuOTk1NF0sIFs0Ni4xODA5LCA1Ljk5NF0sIFs0NS44Njc5LCA1LjMzMjZdLCBbNDYuMzE3MywgNi4xMjU3XSwgWzQ2LjMxNjEsIDYuMTI0Ml0sIFs0Ni4zMTQyLCA2LjEyMjddLCBbNDYuMzAzOCwgNi4xMTk1XSwgWzQ2LjI5NDMsIDYuMTE5NV0sIFs0Ni4yNDMsIDYuMDkzOF0sIFs0Ni4xNTcxLCA1Ljk3NDJdLCBbNDYuMTMwNSwgNS45MjU0XSwgWzQ2LjA4MDYsIDUuODE1Ml0sIFs0Ni4yMjExLCA1Ljk5MTNdLCBbNDUuODY2MSwgNC45MDUxXSwgWzQ1Ljg3NjksIDQuOTAxOV0sIFs0NS44OTcyLCA0Ljg4MDddLCBbNDYuMzEwOCwgNS45NDE2XSwgWzQ1LjkwNzgsIDQuODUzMV0sIFs0NS45MTA2LCA0Ljg0MDldLCBbNDUuOTI3NSwgNC43ODYzXSwgWzQ1LjgwODcsIDUuNzg2NV0sIFs0NS43OTgxLCA1Ljc4NV0sIFs0NS43MzczLCA1Ljc3MTNdLCBbNDUuNzM3MiwgNS43NzE1XSwgWzQ1LjcxOTEsIDUuNzYzOF0sIFs0NS42NzE0LCA1LjU3MThdLCBbNDUuNjc4MywgNS41NTQ3XSwgWzQ2LjUwODgsIDUuMTg3NV0sIFs0Ni40ODc0LCA1LjA3NjJdLCBbNDYuNDk3MiwgNS4wOTg5XSwgWzQ2LjQ1MTMsIDUuMjY1Ml0sIFs0Ni4zMjg2LCA1LjQzMjhdLCBbNDYuNDkzNSwgNS4yMDU3XSwgWzQ2LjMxMDgsIDUuNDc0MV0sIFs0Ni4zMjAxLCA1LjY3MzZdLCBbNDYuMzA4OCwgNS43MTQ3XSwgWzQ2LjMwMTQsIDUuNzE3Ml0sIFs0Ni4zNDAzLCA0Ljg1MjVdLCBbNDYuNDk3NCwgNC45MjU3XSwgWzQ2LjUwMjEsIDQuOTQ4NF0sIFs0Ni4zMzg5LCA0Ljg1MjddLCBbNDYuNTA1NSwgNC45NDQxXSwgWzQ2LjA5NzUsIDUuODIzN10sIFs0Ni4zMDkzLCA1Ljk0MTVdLCBbNDYuMDYzNywgNC43NjA5XSwgWzQ2LjM3MDQsIDYuMDAxN10sIFs0Ni4zNzExLCA2LjAwMzJdLCBbNDYuMzcyLCA2LjAwNjFdLCBbNDYuMzc2OCwgNi4wMTUyXSwgWzQ2LjM3NjksIDYuMDE1Ml0sIFs0Ni4zNzc5LCA2LjAxNjddLCBbNDYuMzc4MiwgNi4wMTY4XSwgWzQ2LjM3ODcsIDYuMDE2Nl0sIFs0Ni4zNzkzLCA2LjAxNjddLCBbNDYuMzgxMiwgNi4wMTk5XSwgWzQ2LjM4NzksIDYuMDMwMV0sIFs0Ni40MTE0LCA2LjA1MjhdLCBbNDYuMzEzMiwgNi4xMjE1XSwgWzQ2LjMxMTYsIDYuMTJdLCBbNDYuMjc2NiwgNi4xMDYzXSwgWzQ2LjI2NiwgNi4xMTU1XSwgWzQ1Ljc4MjgsIDUuMTg2Ml0sIFs0NS44MTczLCA0LjkxOTFdLCBbNDUuODU1NywgNC45MDExXSwgWzQ1LjkwMzEsIDQuODcwNV0sIFs0NS45Mzc4LCA0Ljc2ODJdLCBbNDUuOTQyNSwgNC43MzAxXSwgWzQ1LjkzNTgsIDUuODI2Nl0sIFs0NS44NTU2LCA1LjgwMzddLCBbNDUuNzEwMywgNS43MzgyXSwgWzQ1LjcwOTMsIDUuNzI3N10sIFs0NS42MjQ4LCA1LjY0NjZdLCBbNDUuODA3MywgNS40MjI1XSwgWzQ1LjgxNzgsIDUuMjkxXSwgWzQ2LjQ5NjYsIDUuMDI0OV0sIFs0Ni40OTQyLCA1LjAyNzddLCBbNDYuNDkyLCA1LjAzMjRdLCBbNDYuNDk2NywgNS4yMDMyXSwgWzQ2LjQwMTQsIDUuMzM3Ml0sIFs0Ni4zOTksIDUuMzQ5NF0sIFs0Ni40NTc3LCA1LjI0ODhdLCBbNDYuMzkyNCwgNS4zNjE2XSwgWzQ2LjM5OTQsIDUuMzQ4MV0sIFs0Ni4zMjMyLCA1LjQ1OTRdLCBbNDYuMjEzMSwgNC43OTMzXSwgWzQ2LjM1MDgsIDQuODUxM10sIFs0Ni41MTUxLCA0Ljk0MjldLCBbNDYuMDM3NywgNC43NDQ1XSwgWzQ2LjExNzYsIDQuNzcyMV0sIFs0Ni4xNTY0LCA0LjgwMjVdLCBbNDYuMzUzNSwgNS45Nzg5XSwgWzQ2LjM5MTIsIDYuMDM1MV0sIFs0Ni40MTMsIDYuMDUzNV0sIFs0Ni4zNzUyLCA2LjE2MTZdLCBbNDYuMjQ1NSwgNi4wOTAxXSwgWzQ2LjIzMTksIDYuMDE5OV0sIFs0NS43MzExLCA1LjUxNzddLCBbNDUuODExMSwgNS4yODg5XSwgWzQ2LjA4NTIsIDUuODYzOF0sIFs0NS44NDU1LCA1LjQxNl0sIFs0Ni4zMzI4LCA1Ljk1ODldLCBbNDUuODQ3MSwgNC45MTM0XSwgWzQ2LjA5OTcsIDUuODIzMV0sIFs0NS44Nzc4LCA1LjMzODFdLCBbNDUuNzIwOSwgNS43NjYxXSwgWzQ1LjcwNjUsIDUuNzQzMl0sIFs0NS42Nzc0LCA1LjcwMjFdLCBbNDUuNjc4NiwgNS41NTQyXSwgWzQ1Ljc5NTEsIDUuMTY4M10sIFs0Ni40MDk1LCA1LjMxNDhdLCBbNDYuNDg4NywgNS4wNDY0XSwgWzQ2LjQ5OSwgNS4wOTUyXSwgWzQ2LjM0NiwgNS40MTg0XSwgWzQ2LjQxNTgsIDUuMzA0MV0sIFs0Ni40ODE3LCA1LjIxNDJdLCBbNDYuNDg2MSwgNS4yMDgyXSwgWzQ2LjI2NTYsIDUuNTA4M10sIFs0Ni4yNjQ2LCA1LjUwODNdLCBbNDYuMzIyNywgNS42MTA0XSwgWzQ2LjIyMjQsIDQuNzk2OF0sIFs0Ni4xNDIzLCA0Ljc5ODddLCBbNDYuMTI5NCwgNS45NTA3XSwgWzQ2LjQwMiwgNi4wNDQ0XSwgWzQ2LjM0MDksIDYuMTQyMl0sIFs0Ni4zMzk2LCA2LjEzOTJdLCBbNDYuMjg0MywgNi4xMDM5XSwgWzQ2LjM1MywgNS45Nzg0XSwgWzQ2LjI0MzUsIDYuMDc1Ml0sIFs0Ni4xNzEzLCA1Ljk4ODldLCBbNDUuODEzNywgNS4xMDMyXSwgWzQ2LjI3OTksIDUuNzE2MV0sIFs0Ni4xNzk4LCA1Ljk5MjVdLCBbNDUuODY3NCwgNC45MDY0XSwgWzQ1Ljk5OTMsIDUuODEwNF0sIFs0NS45OTM0LCA1LjgxMDJdLCBbNDUuOTkyMywgNS44MTAyXSwgWzQ1Ljk4NzEsIDUuODExN10sIFs0NS45ODU5LCA1LjgxMzJdLCBbNDUuOTg0NiwgNS44MTQ4XSwgWzQ1Ljk3OTcsIDUuODI0MV0sIFs0NS45NzY1LCA1LjgzXSwgWzQ1Ljk3MzksIDUuODMzMl0sIFs0NS45NjQ4LCA1LjgzM10sIFs0NS45NTIxLCA1LjgzNDldLCBbNDUuOTUxOCwgNS44MzUxXSwgWzQ1LjcwOTcsIDUuNzExNl0sIFs0NS42OTc2LCA1LjU1Nl0sIFs0Ni4wOTk4LCA1Ljg0MTldLCBbNDUuNjkzOSwgNS41NjA1XSwgWzQ2LjQ5NjUsIDUuMjA0XSwgWzQ2LjQzOCwgNS4zMTY2XSwgWzQ2LjM0NTgsIDUuNDI0OV0sIFs0Ni40OTIsIDUuMDI4N10sIFs0Ni41MDE2LCA1LjEzMjNdLCBbNDYuNTA5LCA1LjEzNTFdLCBbNDYuNDE5OSwgNS4zMDg5XSwgWzQ2LjM5NDEsIDUuMzUxOV0sIFs0Ni4zNzg4LCA1LjM3MzFdLCBbNDYuNDg1NSwgNS4yMV0sIFs0Ni41MDI3LCA0LjkyODVdLCBbNDYuMzY0NiwgNS45ODldLCBbNDYuMDI0MiwgNC43NDUzXSwgWzQ2LjEzMjgsIDQuNzg5Nl0sIFs0Ni4xNjQ1LCA0Ljc4OThdLCBbNDUuODgzMywgNS4zNDk5XSwgWzQ2LjI2ODEsIDUuNDkzNV0sIFs0Ni4zNDU4LCA2LjE1MTddLCBbNDYuMzQwNiwgNi4xNDU1XSwgWzQ2LjMzNzgsIDYuMTM5M10sIFs0Ni4zMTIyLCA2LjExOThdLCBbNDYuMjY4NywgNi4xMTIxXSwgWzQ2LjI0NTcsIDYuMDg5Ml0sIFs0Ni4yMTUxLCA1Ljk3NDddLCBbNDUuOTAxNSwgNC44MTY4XSwgWzQ2LjA0NTIsIDUuODA3NF0sIFs0NS42OTY2LCA1LjU0NTZdLCBbNDUuNzY3OCwgNS40Njk0XSwgWzQ1Ljg3NjUsIDUuMzY3NV0sIFs0NS44MTY0LCA1LjI5MTFdLCBbNDYuNTAzNiwgNS4xMzU2XSwgWzQ2LjQ0MjQsIDUuMzE0MV0sIFs0Ni40MTY0LCA1LjMxMTFdLCBbNDYuMzk0MywgNS4zNjI3XSwgWzQ2LjQyMjgsIDUuMzA4MV0sIFs0Ni40MTkyLCA1LjMwODFdLCBbNDYuMzQyNywgNS4zODczXSwgWzQ2LjQzOTYsIDUuMzE1Nl0sIFs0Ni4yOTI2LCA1LjU4NTVdLCBbNDYuMzMxNiwgNS42NDkzXSwgWzQ2LjQ1ODcsIDQuOTEyMV0sIFs0Ni4yNzMxLCA0LjgyNV0sIFs0Ni4xOTg2LCA0Ljc4OTldLCBbNDYuMDk0OCwgNC43NTJdLCBbNDYuMTA2NiwgNC43NjcyXSwgWzQ2LjEzMjEsIDUuOTU2MV0sIFs0NS43NzYsIDUuMjM3Nl0sIFs0Ni40MDM0LCA2LjEwMTddLCBbNDYuMzcyOCwgNi4xNjQ0XSwgWzQ2LjMwMTEsIDYuMTIwMV0sIFs0Ni4yMjY2LCA2LjAwNzFdLCBbNDYuMzAwMSwgNS40NjkyXSwgWzQ1LjY5ODIsIDUuNTY2Ml0sIFs0Ni4yNjc3LCA1LjQ2OTddLCBbNDYuMDQ5LCA1LjgxMDldLCBbNDUuODA4MywgNS4wMzc4XSwgWzQ2LjI2NDQsIDUuNTExNF0sIFs0NS45MTA5LCA0Ljg0MjhdLCBbNDYuMDUyOSwgNS44MTMxXSwgWzQ1LjkwNjYsIDQuODMwOF0sIFs0NS44MTIxLCA1LjA0OTNdLCBbNDYuMjg1NCwgNS45MTAzXSwgWzQ1LjcwNTMsIDUuNzQ4OF0sIFs0NS42MTE4LCA1LjYzM10sIFs0NS42ODkzLCA1LjU2MTVdLCBbNDUuODY1NCwgNS4zMzFdLCBbNDUuODYzOCwgNS4zMjk1XSwgWzQ2LjI4OCwgNS45MTIxXSwgWzQ1Ljc5MTcsIDUuMjcwMl0sIFs0Ni4zODY4LCA1LjM3MDldLCBbNDYuMzQyNywgNS40MTY3XSwgWzQ2LjMxNjcsIDUuNDEzNV0sIFs0Ni40OTg2LCA1LjA5NDhdLCBbNDYuNTA1NiwgNS4xNjY1XSwgWzQ2LjMzMjgsIDUuNDA0M10sIFs0Ni4yNjc4LCA1LjQ4NjVdLCBbNDYuMzEwNiwgNS42MDcyXSwgWzQ2LjMxODgsIDUuNjgwNF0sIFs0Ni4yNjYxLCA1Ljc4MV0sIFs0Ni41MTk2LCA0Ljk0M10sIFs0Ni4zMjYxLCA0Ljg1MTRdLCBbNDYuMjIwMSwgNC43OTU1XSwgWzQ2LjIzNDcsIDQuODA2XSwgWzQ2LjMxMTgsIDQuODQxMV0sIFs0Ni40MjIsIDQuODg5N10sIFs0Ni40NjU0LCA0LjkxNThdLCBbNDYuNDk1MSwgNC45MjMzXSwgWzQ2LjUxMiwgNC45NDAyXSwgWzQ2LjUxMzIsIDQuOTY0Nl0sIFs0Ni40MTQzLCA0Ljg4ODNdLCBbNDYuNDg1OSwgNC45MTQ0XSwgWzQ2LjI2NjIsIDUuODY5MV0sIFs0NS44NTMyLCA1LjQwOTZdLCBbNDYuMTA1OSwgNS44Mjg3XSwgWzQ2LjQwNjMsIDYuMDk5Ml0sIFs0Ni4zNDk5LCA2LjE1NzJdLCBbNDYuMzIyNywgNi4xMjk2XSwgWzQ2LjMxNTEsIDYuMTIzNl0sIFs0Ni4yOTM0LCA1LjU3MTNdLCBbNDYuMjQ2MSwgNi4wODU1XSwgWzQ1LjY1NjIsIDUuNTk1OV0sIFs0Ni4yNjcyLCA1Ljc3MTZdLCBbNDUuODQ1NiwgNC45MTUyXSwgWzQ1Ljg4NTYsIDQuODgyOV0sIFs0NS45MTE3LCA0Ljg0NV0sIFs0NS42OTAxLCA1LjU0NTVdLCBbNDUuNzEwMSwgNS43MzA5XSwgWzQ1LjYzODUsIDUuNjU3OV0sIFs0NS42ODgzLCA1LjU2MThdLCBbNDUuNjg2NCwgNS41NzRdLCBbNDUuNzIwNiwgNS41MjM1XSwgWzQ1Ljc5OTYsIDUuMjc1XSwgWzQ1LjgwNDYsIDUuMTQ0Ml0sIFs0Ni40MjMyLCA1LjMxMTddLCBbNDYuMzQ0OSwgNS40MjZdLCBbNDYuNDkzMSwgNS4wODc2XSwgWzQ2LjUwMTksIDUuMTMwMl0sIFs0Ni41MDM2LCA1LjE2N10sIFs0Ni40MzAzLCA1LjMyMDldLCBbNDYuNDI3NiwgNS4zMjA5XSwgWzQ2LjMyNTQsIDUuNDEzOF0sIFs0Ni41MDUsIDUuMjAzNF0sIFs0Ni40ODY0LCA1LjIwNjZdLCBbNDYuNTExMSwgNC45NDc2XSwgWzQ1LjgwMjQsIDUuMTA1NF0sIFs0NS43OTgxLCA1LjE2NTJdLCBbNDUuODAzOCwgNS4xNTQ1XSwgWzQ2LjAzNjYsIDQuNzQ0OV0sIFs0Ni4wMzk5LCA0Ljc0MzRdLCBbNDYuMDUxNywgNC43NDM0XSwgWzQ2LjA5MzYsIDQuNzQ5Nl0sIFs0Ni4zOTMsIDYuMDM3XSwgWzQ2LjQwNzQsIDYuMDk5M10sIFs0Ni4zNzc3LCA2LjE2MDVdLCBbNDUuODUwNiwgNS40MTQ4XSwgWzQ2LjM0NjEsIDUuOTcxXSwgWzQ1LjY3MTYsIDUuNTU0N10sIFs0NS44MywgNC45Ml0sIFs0NS45MDI3LCA0LjgyMDldLCBbNDUuOTAyNSwgNS44MjU4XSwgWzQ2LjI3NzQsIDUuODg2N10sIFs0NS43MjAzLCA1Ljc2NDhdLCBbNDUuNjk2OCwgNS43MDUzXSwgWzQ1LjYzMywgNS42MDY0XSwgWzQ1LjcyMzgsIDUuNTIyM10sIFs0NS43ODIsIDUuNDU1NV0sIFs0Ni40NTgxLCA1LjIzNzNdLCBbNDYuNDQ1OCwgNS4yODMzXSwgWzQ2LjQwMTcsIDUuMzI3NF0sIFs0Ni4zMTg5LCA1LjQ1NjldLCBbNDYuNDkwMSwgNS4wODE5XSwgWzQ2LjQyMzQsIDUuMzEwNV0sIFs0Ni4zMTY0LCA1LjQzNzJdLCBbNDYuNTA4MSwgNS4yMDA5XSwgWzQ2LjUwMjgsIDUuMjAwN10sIFs0Ni4zMTcsIDUuNDM3XSwgWzQ2LjI3MjcsIDQuODI0Nl0sIFs0Ni40Mjk2LCA0Ljg5MTZdLCBbNDYuMjA3NSwgNC43OTI3XSwgWzQ2LjIyNjQsIDQuNzk4OV0sIFs0Ni4wOTIxLCA0Ljc0ODRdLCBbNDUuODEzMSwgNS4wOTk5XSwgWzQ2LjMwODIsIDUuNDcyNl0sIFs0Ni4zNzQzLCA2LjE2MjVdLCBbNDYuMzU3NSwgNi4xNTkzXSwgWzQ2LjM0NDIsIDYuMTUwM10sIFs0Ni4yODc5LCA2LjEwNl0sIFs0Ni4xMjg0LCA1Ljk0ODFdLCBbNDUuODc2LCA0LjkwMjFdLCBbNDUuOTEyMiwgNC44NDU4XSwgWzQ1LjkxMTYsIDQuODQ0M10sIFs0NS43MTQzLCA1LjUzMDRdLCBbNDUuOTM4MiwgNC43MzczXSwgWzQ1LjYzMzYsIDUuNjA1Ml0sIFs0Ni4zMTI2LCA1LjkyOTVdLCBbNDUuNjk4LCA1LjU2NjldLCBbNDYuMTc4OSwgNS45OTEzXSwgWzQ2LjUwODMsIDUuMjAxNF0sIFs0Ni41MDkyLCA1LjE4Nl0sIFs0Ni41MDE1LCA1LjEzMTJdLCBbNDYuNTA2NywgNS4xNTg2XSwgWzQ2LjQwNjcsIDUuMzE4NV0sIFs0Ni40NDY0LCA1LjMwOTVdLCBbNDYuMzE4NywgNS40NjgxXSwgWzQ2LjI2NDgsIDUuNTIyOV0sIFs0Ni4yOTcyLCA1LjU5NzRdLCBbNDYuMzE4OCwgNS42NzddLCBbNDYuMjM1NiwgNC44MDY3XSwgWzQ2LjE3MzIsIDUuOTgyM10sIFs0Ni4yNjIzLCA1Ljg0MTZdLCBbNDYuMTA2NSwgNC43NjcxXSwgWzQ2LjAxOTQsIDUuODA5OF0sIFs0Ni4wMjQsIDUuODEyNF0sIFs0Ni4yNjMxLCA1LjczMTRdLCBbNDYuMzg0MSwgNi4wMjU0XSwgWzQ2LjM3NzMsIDYuMTUwNF0sIFs0Ni4zNDI2LCA2LjE0OTFdLCBbNDYuMzI5MywgNi4xMzUyXSwgWzQ2LjMxMSwgNi4xMl0sIFs0Ni4zMDc0LCA2LjEyMDJdLCBbNDYuMzA1MSwgNi4xMl0sIFs0Ni4yNTM4LCA2LjEyMTVdLCBbNDYuMTA1NCwgNS44MzMyXSwgWzQ1LjgwNjEsIDUuMDE5XSwgWzQ1LjgyODEsIDUuNDM2Ml0sIFs0Ni4yODY3LCA1LjcxNjldLCBbNDUuNzk1LCA1LjE3MjldLCBbNDYuMzM0NywgNS45NjEzXSwgWzQ1LjcxMzQsIDUuNzU5NF0sIFs0NS43MDYyLCA1Ljc0NDRdLCBbNDUuNzA4NCwgNS43NDEyXSwgWzQ1LjYzNDgsIDUuNjA0Ml0sIFs0NS43ODc3LCA1LjQ0NTRdLCBbNDYuMDkzNiwgNS44NDY0XSwgWzQ1Ljg1NDcsIDUuNDA3NV0sIFs0Ni40MzEzLCA1LjMxOV0sIFs0Ni41MDA2LCA1LjAxNDJdLCBbNDYuNTA2OSwgNS4xMzQ3XSwgWzQ2LjM0LCA1LjM5NjddLCBbNDYuMzQ3MiwgNS40MjI4XSwgWzQ2LjQ0NTgsIDUuMzExM10sIFs0Ni4yNzA0LCA1LjUwNDhdLCBbNDYuMjk0LCA1LjU2NzVdLCBbNDYuMzI4MiwgNS42MTQ4XSwgWzQ2LjI2ODQsIDUuODYwM10sIFs0Ni4yMTk0LCA0Ljc5NV0sIFs0Ni4xOTc0LCA0Ljc4ODhdLCBbNDYuMzY4NiwgNC44NTldLCBbNDYuNTEwMiwgNC45NDQyXSwgWzQ2LjUwOTYsIDQuOTY4OF0sIFs0Ni4xOTA0LCA1Ljk4MjJdLCBbNDYuMDg1NSwgNS44NjYzXSwgWzQ1Ljg3MTcsIDUuMzM0OV0sIFs0Ni4xNjM1LCA0Ljc5MThdLCBbNDYuMzExNSwgNS45NDJdLCBbNDYuMzk3OSwgNi4wNDExXSwgWzQ2LjM3NDMsIDYuMTYxNF0sIFs0Ni4zNTk4LCA2LjE2MTRdLCBbNDYuMzMzLCA2LjEzODldLCBbNDYuMjQ3OSwgNi4xMjA1XSwgWzQ2LjM2ODUsIDUuOTk3Nl0sIFs0NS44MDg5LCA1LjAwNDRdLCBbNDUuOTQ5MSwgNC43MjkxXSwgWzQ2LjIwMDksIDUuOTY5Ml0sIFs0NS44MTA5LCA1LjExNDNdLCBbNDUuNzEwOCwgNS43MDY2XSwgWzQ1LjYzNTksIDUuNjA0M10sIFs0NS42ODUyLCA1LjU0NjVdLCBbNDUuNywgNS41NjE3XSwgWzQ1LjgwOTMsIDUuNDIxNV0sIFs0Ni4yMTQ3LCA1Ljk3NDRdLCBbNDUuODU0NCwgNS4zMDg3XSwgWzQ2LjQ5MTcsIDUuMTA3NF0sIFs0Ni41MDI3LCA1LjE5OV0sIFs0Ni40ODQ3LCA1LjIxMjddLCBbNDYuMzE2OSwgNS40NDNdLCBbNDYuMzg5LCA1LjM2MzRdLCBbNDYuMzIyNiwgNS40Njc0XSwgWzQ2LjMwOTYsIDUuNjA1OV0sIFs0Ni4zNjQ0LCA1Ljk4ODZdLCBbNDYuMzY0OSwgNS45OTAxXSwgWzQ2LjEyNDEsIDUuOTA5NF0sIFs0Ni4zNjkyLCA0Ljg1OTVdLCBbNDYuNDU3NywgNC45MTExXSwgWzQ2LjA5MjEsIDUuODQ4OF0sIFs0Ni4xMDExLCA1Ljg5MTRdLCBbNDYuMzgxMSwgNi4wMTg1XSwgWzQ2LjMzNDcsIDYuMTM5Ml0sIFs0Ni4yNDU3LCA2LjA4MV0sIFs0Ni4wOTY0LCA1Ljg0MzJdLCBbNDUuODA5NywgNS4wMjg1XSwgWzQ2LjEzMTUsIDUuOTIxM10sIFs0NS44MDk2LCA1LjA2MDRdLCBbNDUuODY0MywgNC45MDMyXSwgWzQ1LjY4OTIsIDUuNTQ1NV0sIFs0NS45NjYyLCA1LjgzMzRdLCBbNDUuOTMxOCwgNS44MjI5XSwgWzQ1LjgyOTYsIDUuNzk1M10sIFs0NS43NzI5LCA1Ljc4MzFdLCBbNDUuODY3MiwgNS4zODA5XSwgWzQ2LjQ5MDQsIDUuMjFdLCBbNDYuMzQ1OCwgNS4zODA2XSwgWzQ2LjQzOTksIDUuMzE1M10sIFs0Ni40OTkxLCA1LjEyNjNdLCBbNDYuNTEwNSwgNS4xNzk2XSwgWzQ2LjUwMjUsIDUuMjAwOF0sIFs0Ni4zNDMxLCA1LjM4NjVdLCBbNDYuMzMzNiwgNS40MzA5XSwgWzQ2LjQ4NzUsIDUuMjA1NV0sIFs0Ni40Mjg1LCA1LjMyNDVdLCBbNDYuMjgxMiwgNC44Mjc5XSwgWzQ2LjUwMTMsIDQuOTUyOV0sIFs0Ni40Nzk2LCA0LjkxNDZdLCBbNDYuNTA5NywgNS4wMDU3XSwgWzQ2LjE2NSwgNS45NzkzXSwgWzQ1Ljg2MjcsIDUuMzI2OV0sIFs0Ni4wMDE5LCA0Ljc0ODVdLCBbNDYuMDAyOCwgNC43NDg1XSwgWzQ2LjA1NjMsIDQuNzUzMl0sIFs0Ni4wNTg1LCA0Ljc1NjJdLCBbNDYuMzk1NywgNi4wMzg3XSwgWzQ2LjM4OTgsIDYuMTMyXSwgWzQ2LjM1MTEsIDUuOTc2Ml0sIFs0Ni4zNDcyLCA2LjE1MTVdLCBbNDYuMjk0MywgNi4xMTM2XSwgWzQ2LjI0MzYsIDYuMDc1M10sIFs0NS44NDA1LCA0LjkxNzRdLCBbNDUuODQ1NiwgNC45MTU3XSwgWzQ1Ljg5NjgsIDQuODc3OF0sIFs0NS44MzUyLCA1LjQzXSwgWzQ1LjgwMzksIDUuMTUzOV0sIFs0NS45MTMsIDQuODQ4N10sIFs0NS45NTAxLCA0LjcyOTldLCBbNDUuOTkwNSwgNC43NDk4XSwgWzQ1Ljk0MDcsIDUuODI5Ml0sIFs0NS43NDMxLCA1Ljc4MTldLCBbNDUuNzQyOSwgNS43ODA0XSwgWzQ1LjY1MjIsIDUuNjAyM10sIFs0NS42NTkyLCA1LjU4ODRdLCBbNDUuODUwNCwgNS4zMDY1XSwgWzQ1Ljc2ODcsIDUuMjE3OV0sIFs0Ni40NzYzLCA1LjIxMzNdLCBbNDYuNDksIDUuMjA3M10sIFs0Ni40OTY2LCA1LjAyNDNdLCBbNDYuNDg4NSwgNS4wNzYxXSwgWzQ2LjQ5MTYsIDUuMTA5N10sIFs0Ni41MDk2LCA1LjEzODhdLCBbNDYuNDkxMywgNS4yMTAzXSwgWzQ2LjQ0NjEsIDUuMzA5NF0sIFs0Ni40MDIsIDUuMzI2MV0sIFs0Ni4zMTQ2LCA1LjQwNF0sIFs0Ni41MDc5LCA0Ljk2MzddLCBbNDYuMzQ0MSwgNC44NTI2XSwgWzQ2LjMwOTksIDUuOTM1N10sIFs0Ni4zNjM0LCA1Ljk4MzldLCBbNDUuODU4NCwgNS40MDIxXSwgWzQ2LjAzNDgsIDQuNzQ1OF0sIFs0NS44MTIzLCA1LjI4OThdLCBbNDUuODk2MiwgNC44NzU4XSwgWzQ2LjMxNzcsIDUuNDY4Nl0sIFs0Ni4zMzA3LCA1Ljk1ODRdLCBbNDYuMzg0MSwgNi4wMjU3XSwgWzQ2LjM5OTIsIDYuMDQyNF0sIFs0Ni4zNTExLCA2LjE1ODJdLCBbNDYuMzQ2MiwgNi4xNTJdLCBbNDYuMjYyOCwgNS44NDM5XSwgWzQ2LjMxMTgsIDUuOTQzM10sIFs0Ni4zNDQ1LCA1Ljk2OTJdLCBbNDYuMzI2OSwgNi4xMzM2XSwgWzQ2LjI5ODcsIDYuMTIxNF0sIFs0Ni4wODUzLCA1Ljg1OTNdLCBbNDUuODMxMSwgNS40MzQ5XSwgWzQ1LjgxOTQsIDQuOTIyMl0sIFs0NS44NTU5LCA0LjkwMV0sIFs0NS44NzA3LCA0LjkwODVdLCBbNDUuODk5OSwgNC44MDMyXSwgWzQ1LjkzODUsIDQuNzM2Ml0sIFs0NS45NDgsIDQuNzI4NV0sIFs0Ni4zMjQyLCA1LjYxMDVdLCBbNDYuMzEzNCwgNS45NDU5XSwgWzQ1LjgyMTEsIDUuNzg1Nl0sIFs0NS42NjE2LCA1LjU4NzJdLCBbNDUuNjY4NiwgNS41ODFdLCBbNDUuODEzOSwgNS40MjExXSwgWzQ2LjMyNTIsIDUuNjQ0Ml0sIFs0Ni4zMTkyLCA1LjQxMzVdLCBbNDYuNDQ2MSwgNS4zMTI3XSwgWzQ2LjQ5MDQsIDUuMDg1Nl0sIFs0Ni40OTY1LCA1LjA5OTVdLCBbNDYuNDQ5MiwgNS4yODg1XSwgWzQ2LjQzOCwgNS4zMTc0XSwgWzQ2LjI2ODEsIDUuNTAwNF0sIFs0Ni4zMTM2LCA1LjYwNTddLCBbNDYuMzExMywgNS42MDc1XSwgWzQ2LjI2NTMsIDUuNzk2Ml0sIFs0Ni41MDQ3LCA0Ljk0NDVdLCBbNDUuNzYwOSwgNS40NzY3XSwgWzQ2LjEwOTcsIDQuNzcwNV0sIFs0Ni4yNjgzLCA1Ljc2NTddLCBbNDUuODEsIDUuMDAzMV0sIFs0Ni4zOTU0LCA2LjAzOF0sIFs0Ni40MTcsIDYuMDU5Nl0sIFs0Ni4zNDE4LCA2LjE0NjNdLCBbNDYuMjU3NCwgNi4xMjE5XSwgWzQ2LjI0ODYsIDYuMTIwNl0sIFs0Ni4yMzksIDYuMDk5Ml0sIFs0Ni4wMTEyLCA1LjgwOTRdLCBbNDUuNzk0MiwgNS4xNzU3XSwgWzQ2LjIwNDcsIDUuOTcxMV0sIFs0Ni4xNzI1LCA1Ljk4MThdLCBbNDUuODA1MiwgNS4xNDI2XSwgWzQ1LjgyNzYsIDQuOTE5N10sIFs0NS44MTQyLCA1LjI5MDZdLCBbNDUuODM3MiwgNC45MThdLCBbNDUuODYzOCwgNC45MDI4XSwgWzQ1Ljg5NywgNC44Nzg2XSwgWzQ1LjkwMTcsIDQuODAzN10sIFs0NS42MTA4LCA1LjYyODhdLCBbNDUuNjMyMywgNS42MDkxXSwgWzQ1Ljg1MjgsIDUuNDEwOV0sIFs0Ni40OTE2LCA1LjA4NjddLCBbNDYuMzEyMywgNS40NzQxXSwgWzQ2LjA4NTgsIDUuODY3NV0sIFs0NS44MDI1LCA1LjI3NjddLCBbNDYuMzE0MywgNS40MTIzXSwgWzQ2LjM0NTMsIDUuNDE2OF0sIFs0Ni40ODM2LCA1LjIxNDNdLCBbNDYuNDgxOCwgNS4yMTQzXSwgWzQ2LjM0MzIsIDUuMzg2NF0sIFs0Ni40OTIxLCA1LjEwNzNdLCBbNDYuNDkxOSwgNS4xMTA1XSwgWzQ2LjQ5NDEsIDUuMTE1Ml0sIFs0Ni41MDM5LCA1LjIwMDRdLCBbNDYuMzAyMSwgNS40NzAzXSwgWzQ2LjIyODgsIDQuNzk5OV0sIFs0Ni4xNTY0LCA1Ljk3MzZdLCBbNDUuNzY4OSwgNS4yMTYyXSwgWzQ2LjA2NzQsIDQuNzYxOF0sIFs0NS44MTAyLCA1XSwgWzQ1LjgwNDYsIDUuMTQ1XSwgWzQ1LjgwMTgsIDUuMTA1Nl0sIFs0Ni4zNzY3LCA2LjE2MDVdLCBbNDYuMzE4NSwgNi4xMjU0XSwgWzQ2LjI3MDUsIDYuMTFdLCBbNDYuMjQxMSwgNi4xMDddLCBbNDYuMjg4MiwgNS43MTc1XSwgWzQ2LjMxMzcsIDUuOTI2NF0sIFs0Ni4yNDE1LCA2LjA3MDZdLCBbNDYuMjE1NiwgNS45OTM0XSwgWzQ1LjgyMjUsIDQuOTJdLCBbNDUuODIzNCwgNC45Ml0sIFs0NS45MjIxLCA0Ljc5MzVdLCBbNDUuODYyOCwgNS44MDkxXSwgWzQ1Ljc3OCwgNS43OF0sIFs0NS43NTU1LCA1Ljc4MTVdLCBbNDUuNjg2NSwgNS43MDk4XSwgWzQ1Ljc4MDIsIDUuNDU4NV0sIFs0NS43OTU0LCA1LjQzODZdLCBbNDUuODY0NCwgNS4zODY4XSwgWzQ2LjQ4MDcsIDUuMjExNF0sIFs0Ni40NTY1LCA1LjI1MV0sIFs0Ni40ODc0LCA1LjIwNTZdLCBbNDYuNDE2NiwgNS4zMDldLCBbNDYuNDk5OSwgNS4yMDI0XSwgWzQ2LjM5ODQsIDUuMzM0OV0sIFs0Ni40OTE0LCA1LjA0MDZdLCBbNDYuNTA1MiwgNS4xNjEzXSwgWzQ2LjQ0MDMsIDUuMzE1Ml0sIFs0Ni41MDkxLCA1LjE5MzJdLCBbNDYuNDczNCwgNC45MTZdLCBbNDYuMzE3MSwgNC44NDQ3XSwgWzQ2LjQ1MjYsIDQuOTAyNV0sIFs0Ni4zMTAyLCA1LjY5MzVdLCBbNDYuMjY2OSwgNS43NzI3XSwgWzQ2LjA5MzMsIDUuODkyOV0sIFs0Ni4wOTY2LCA1Ljg0MzJdLCBbNDYuMDE5NiwgNC43NDM5XSwgWzQ2LjEwNjMsIDUuODMwNV0sIFs0NS44MTE5LCA1LjQyMTRdLCBbNDUuODY2OCwgNS4zMzE3XSwgWzQ2LjM3OTQsIDYuMDE3Nl0sIFs0Ni4zOTk5LCA2LjExMzddLCBbNDYuMzQxNCwgNi4xNDU2XSwgWzQ2LjMxNTcsIDYuMTI0Ml0sIFs0Ni4zMDE1LCA2LjExOTVdLCBbNDYuMjQ1NiwgNi4wNjM0XSwgWzQ2LjI0NTcsIDYuMDYzMl0sIFs0Ni4xLCA1Ljg5MjRdLCBbNDYuMDg2NywgNS44NTZdLCBbNDYuMzU5LCA1Ljk4MTZdLCBbNDUuODc5MywgNC44ODk3XSwgWzQ1LjgwNjUsIDUuMTM4Ml0sIFs0NS45MDA0LCA0LjgxMzddLCBbNDUuNjEyOSwgNS42MzQzXSwgWzQ1LjY3MjUsIDUuNTYwOV0sIFs0NS43MjU1LCA1LjUyMTVdLCBbNDUuODMyOSwgNS40MzMxXSwgWzQ1Ljc3NjEsIDUuMTg3Nl0sIFs0NS44MDc5LCA1LjAzNjddLCBbNDYuNTEyNiwgNS4xNjc4XSwgWzQ2LjQwMSwgNS4zMzY5XSwgWzQ2LjQzMDQsIDUuMzIwMl0sIFs0Ni40ODQzLCA1LjA1NDhdLCBbNDYuNDQyNSwgNS4zMTQyXSwgWzQ2LjI2NDMsIDUuNTIxNF0sIFs0Ni4zNDE4LCA1LjY0NzddLCBbNDYuMzMwOCwgNS42NDk0XSwgWzQ2LjM0ODcsIDUuOTczOV0sIFs0Ni4xMiwgNS45MDM1XSwgWzQ2LjUxNTQsIDQuOTgzNV0sIFs0Ni41MDA4LCA0Ljk1MDFdLCBbNDYuNTA0LCA0Ljk1MzNdLCBbNDYuMjI5OCwgNC44MDA3XSwgWzQ2LjEwMTgsIDUuODkwNV0sIFs0Ni4xMDQsIDUuODM1MV0sIFs0NS44NDI1LCA1LjQxNjhdLCBbNDYuMzA5NCwgNS43MTAzXSwgWzQ2LjE1NDQsIDUuOTcxOF0sIFs0Ni4zODM0LCA2LjAyMjZdLCBbNDYuMzc3OSwgNi4xNDkxXSwgWzQ2LjI4OCwgNi4xMDYzXSwgWzQ2LjI3MzksIDYuMTExXSwgWzQ2LjI5NSwgNS43MTkxXSwgWzQ2LjMyODksIDUuOTU1Nl0sIFs0NS44NzQzLCA0LjkwNTZdLCBbNDUuOTEyOSwgNC44NDkxXSwgWzQ2LjExOTgsIDUuODk2OF0sIFs0NS45NDI2LCA1LjgzMTNdLCBbNDUuOTA0NiwgNS44MjY2XSwgWzQ1Ljc3MTYsIDUuMjA5MV0sIFs0NS43NzE4LCA1LjIwNzZdLCBbNDUuODA1OCwgNS4wMTczXSwgWzQ2LjQ1OTksIDUuMjMzNl0sIFs0Ni4zMzg5LCA1LjQyNThdLCBbNDYuNTA0MywgNS4yMDE3XSwgWzQ2LjM5MDEsIDUuMzYzM10sIFs0Ni40MDg1LCA1LjMxNThdLCBbNDYuNDg2MiwgNS4wNzY3XSwgWzQ2LjQ5MjMsIDUuMTExOF0sIFs0Ni40OTI2LCA1LjExNDZdLCBbNDYuNTA5OCwgNS4xODE2XSwgWzQ2LjUwODgsIDUuMTg2NV0sIFs0Ni4zNTA1LCA0Ljg1MTVdLCBbNDYuMjIxMSwgNS45OTk3XSwgWzQ2LjAwNTEsIDQuNzQ5Ml0sIFs0Ni4wMTY2LCA0Ljc0NDVdLCBbNDUuNzY5OCwgNS40Njc2XSwgWzQ2LjI5OTksIDUuNTk5MV0sIFs0Ni4zNzc2LCA2LjE1NzFdLCBbNDYuMzQxLCA2LjE0MzJdLCBbNDYuMzMxMywgNS45NTgyXSwgWzQ2LjMzNDksIDYuMTM4OV0sIFs0Ni4yNDQyLCA2LjA1OTNdLCBbNDYuMjU0MywgNi4xMjExXSwgWzQ2LjIzMzEsIDYuMDI0Ml0sIFs0Ni4xOTk3LCA1Ljk2NjddLCBbNDYuMDk1NiwgNS44OTM1XSwgWzQ1LjgyNDksIDUuNDI2Ml0sIFs0Ni4xNzA2LCA1Ljk4N10sIFs0NS45MDYxLCA0LjgyOTddLCBbNDUuOTA1NiwgNC44MjY3XSwgWzQ1LjkzNywgNC43Nzk0XSwgWzQ1LjkzOTcsIDUuODI2OV0sIFs0NS43MzU5LCA1Ljc3MjFdLCBbNDUuNjg4OCwgNS43MDk2XSwgWzQ2LjEyODksIDUuOTM1OF0sIFs0Ni4yMzMxLCA2LjA0ODVdLCBbNDUuNzE5NSwgNS41MjM4XSwgWzQ1Ljc1NDYsIDUuNDgyNV0sIFs0Ni40NDI3LCA1LjMxNDZdLCBbNDYuMzc2NywgNS4zNzExXSwgWzQ2LjM3NDIsIDUuMzY2OF0sIFs0Ni4zOTgyLCA1LjM1MTRdLCBbNDYuNDM4MSwgNS4zMTY1XSwgWzQ2LjQ5MTUsIDUuMDM4OV0sIFs0Ni40ODQ1LCA1LjA1ODZdLCBbNDYuNTA1MiwgNS4xMzQ4XSwgWzQ2LjUxNzIsIDUuMTY5OV0sIFs0Ni40MDQ4LCA1LjMyMDhdLCBbNDYuNDQ1NCwgNC44OTQ0XSwgWzQ2LjUxMzMsIDQuOTM4N10sIFs0Ni4zMTE1LCA0Ljg0MDldLCBbNDYuMzYzLCA1Ljk4MzVdLCBbNDYuMTk5NSwgNS45NjU3XSwgWzQ2LjI2NzEsIDUuNDgyM10sIFs0Ni4zNjU0LCA1Ljk5MTFdLCBbNDYuNDAyNCwgNi4wNDQ0XSwgWzQ2LjQwMzgsIDYuMDQ2M10sIFs0Ni40MTMyLCA2LjA3NjVdLCBbNDYuMzMzMSwgNi4xMzc3XSwgWzQ2LjI5NDYsIDYuMTE0Nl0sIFs0Ni4yNzQsIDYuMTEwM10sIFs0Ni4yNTYxLCA2LjEyMjNdLCBbNDYuMjE3MSwgNS45ODQyXSwgWzQ2LjA4NjMsIDUuODU2NF0sIFs0Ni4xMDYyLCA1LjgzMTVdLCBbNDUuODAwNiwgNS4xMDU5XSwgWzQ2LjM0MSwgNS45NjU5XSwgWzQ1Ljc3ODcsIDUuMTg3N10sIFs0NS43LCA1LjU2MDRdLCBbNDUuODEyNywgNC45MTg2XSwgWzQ1LjgwOTksIDUuMTEyNV0sIFs0NS44MTQ4LCA0LjkxOTldLCBbNDUuOTA2OCwgNC44NTQ0XSwgWzQ1Ljg5ODEsIDQuODA0MV0sIFs0NS45MTY3LCA0LjgxMDNdLCBbNDUuOTIwMiwgNC44MDg2XSwgWzQ2LjEyNSwgNS45MTA4XSwgWzQ1Ljg5NTMsIDUuODIyN10sIFs0Ni4yMTUyLCA1Ljk3NTFdLCBbNDUuODc3MiwgNS44MTUyXSwgWzQ1Ljc5NzIsIDUuNzg0Nl0sIFs0NS42MjUsIDUuNjE1M10sIFs0NS43MDU1LCA1LjU1NDVdLCBbNDUuNzMzMSwgNS41MTQ5XSwgWzQ2LjQwNiwgNS4zMTk4XSwgWzQ2LjQ5NTcsIDUuMTAxN10sIFs0Ni41MDg3LCA1LjEzODNdLCBbNDYuMjYxMiwgNS43Mjg0XSwgWzQ2LjMyMjEsIDUuOTUwOF0sIFs0Ni4zMzE2LCA1Ljk1ODVdLCBbNDYuMzYxLCA1Ljk4MjldLCBbNDYuMTAyNywgNS44MzhdLCBbNDYuNTE2NywgNC45NDJdLCBbNDYuMzgwOSwgNC44NzA1XSwgWzQ2LjAyMDcsIDQuNzQ0XSwgWzQ2LjA0NjMsIDQuNzM5NV0sIFs0Ni4wODc4LCA0Ljc0NjhdLCBbNDYuMDk4NSwgNC43NTc1XSwgWzQ2LjEzMTQsIDUuOTU1XSwgWzQ2LjEyMDIsIDQuNzc0Ml0sIFs0Ni4xNjI1LCA0Ljc5NDFdLCBbNDUuNzcxOCwgNS4yMDQ3XSwgWzQ2LjMxNCwgNS45NDU0XSwgWzQ1LjgxMzcsIDUuMTAzN10sIFs0NS44MTE3LCA1LjA5MTNdLCBbNDYuMzExMywgNS40NzM5XSwgWzQ2LjM0NywgNi4xNTE1XSwgWzQ2LjI4MzYsIDYuMTA0NF0sIFs0Ni4yNjkxLCA2LjExMjFdLCBbNDUuNzc3NSwgNS4yNDAzXSwgWzQ1Ljc5MjYsIDUuMTc4XSwgWzQ1LjkwMzEsIDQuODcxNF0sIFs0NS44MTA1LCA1LjEyN10sIFs0NS44Mjk4LCA1Ljc5NTZdLCBbNDUuNzk4OCwgNS43ODUxXSwgWzQ1LjcwODMsIDUuNjk5N10sIFs0NS42NzgxLCA1LjU1NDhdLCBbNDUuNzMzNywgNS41MTM3XSwgWzQ1LjgxNDcsIDUuNDIwOF0sIFs0NS44MzcxLCA1LjQyN10sIFs0Ni40OTQ3LCA1LjIwNDFdLCBbNDYuMzE1NywgNS40NDA0XSwgWzQ2LjUwMTksIDUuMjAxMV0sIFs0Ni41MDM4LCA1LjE2NDVdLCBbNDYuNTEzMiwgNS4xNzM5XSwgWzQ2LjUwOTEsIDUuMTkwNF0sIFs0Ni4zMzkyLCA1LjY0MDNdLCBbNDYuMjg1LCA1LjcxNjNdLCBbNDYuMjk0MSwgNS45MTQ1XSwgWzQ2LjMxNjYsIDUuOTQ4MV0sIFs0Ni4zODg4LCA0Ljg3NjhdLCBbNDYuNTEyOSwgNC45MzkzXSwgWzQ2LjIxODMsIDQuNzk0Nl0sIFs0Ni4xNzA5LCA1Ljk4ODVdLCBbNDYuMTYzNywgNC43OTE0XSwgWzQ2LjM2OTUsIDUuOTk5Nl0sIFs0NS44MTI1LCA1LjA5NjFdLCBbNDYuMjk0NCwgNS41Nzg0XSwgWzQ2LjE4MDMsIDUuOTkzXSwgWzQ2LjM4ODcsIDYuMDMxN10sIFs0Ni4zOTY2LCA2LjExNDFdLCBbNDYuMzQxNSwgNi4xNDQ1XSwgWzQ2LjIxNjksIDUuOTc4NF0sIFs0Ni4wMjE0LCA1LjgxMTFdLCBbNDYuMDA1NCwgNS44MDk1XSwgWzQ1LjkzODgsIDQuNzc2XSwgWzQ2LjM0NTcsIDUuNDE4NF0sIFs0Ni4wOTc3LCA1Ljg0MjNdLCBbNDUuNjkzMSwgNS41NDYxXSwgWzQ1LjY5MDQsIDUuNTYxNV0sIFs0NS43MTM5LCA1LjU0MjldLCBbNDUuODY5OSwgNS4zMzQyXSwgWzQ1LjgwODcsIDUuMTNdLCBbNDUuNzk4LCA1LjExMzNdLCBbNDYuMzQ1LCA1LjM4MzFdLCBbNDYuNDI5NiwgNS4zMjM0XSwgWzQ2LjQwMSwgNS4zNDE4XSwgWzQ2LjQ5ODUsIDUuMjAzMV0sIFs0Ni41MDkxLCA1LjE4NjRdLCBbNDYuMzk3NCwgNS4zMzQxXSwgWzQ2LjM5NDEsIDUuMzYzMl0sIFs0Ni40OTU3LCA1LjA5Ml0sIFs0Ni41MDE0LCA1LjEzMTZdLCBbNDYuNTA3LCA1LjE0NjZdLCBbNDYuMjQ5OSwgNC44MTE2XSwgWzQ2LjUwMDMsIDQuOTUxOF0sIFs0Ni4xMjAyLCA1LjkwMDldLCBbNDUuODEwMSwgNC45OTkzXSwgWzQ1LjgwNzQsIDQuOTcwNF0sIFs0NS44MDYyLCA0LjkzMzddLCBbNDUuODA1MSwgNC45MzA4XSwgWzQ1LjgwNiwgNC45MjMxXSwgWzQ1LjgwNjUsIDQuOTIwMV0sIFs0NS44MDcsIDQuOTE4M10sIFs0NS44MDgyLCA0LjkxODRdLCBbNDUuODA5MywgNC45MTg0XSwgWzQ1LjgwOTksIDQuOTE4NV0sIFs0Ni4xMzAxLCA1Ljk1MjJdLCBbNDYuMzk5OCwgNi4xMTI5XSwgWzQ2LjMzMzcsIDYuMTM4OF0sIFs0Ni4zMzI3LCA2LjEzNzNdLCBbNDYuMzI4MiwgNi4xMzU4XSwgWzQ2LjMwNjUsIDYuMTIwNl0sIFs0Ni4yNzQ1LCA2LjEwOTldLCBbNDYuMjczNywgNi4xMTE0XSwgWzQ2LjIzODQsIDYuMDMzN10sIFs0NS42Njc5LCA1LjU4NDVdLCBbNDUuODAzNiwgNS4xMTM3XSwgWzQ1LjkzNTEsIDQuNzYxMV0sIFs0NS44MTQsIDUuNzg0Ml0sIFs0Ni4xMDQ4LCA1LjgyNzJdLCBbNDUuNjI3OCwgNS42NDg1XSwgWzQ1LjYyMTIsIDUuNjE4M10sIFs0NS43MTQzLCA1LjUzMTJdLCBbNDUuODY0MSwgNS4zM10sIFs0NS43ODIxLCA1LjE4NjhdLCBbNDYuNTA4NCwgNS4xOTQ0XSwgWzQ2LjQxNTMsIDUuMzA1NV0sIFs0Ni41MTI4LCA1LjE3NDVdLCBbNDYuNDE2NSwgNS4zMTE5XSwgWzQ2LjQ3NzgsIDUuMjExM10sIFs0Ni40NjEzLCA1LjI0MTVdLCBbNDYuNTAyNCwgNS4xMzAyXSwgWzQ2LjUwMjYsIDUuMTMxN10sIFs0Ni4yNzk3LCA1LjU1NF0sIFs0Ni4yOTI3LCA1LjU3NTRdLCBbNDYuNTEyMSwgNC45NDE4XSwgWzQ2LjE4ODQsIDQuNzgwMl0sIFs0Ni41MTQyLCA0LjkzNTZdLCBbNDYuMjY2NiwgNS43NTk2XSwgWzQ2LjIyMjgsIDUuOTkyM10sIFs0Ni4wNDMsIDQuNzQwNl0sIFs0Ni4xMzQsIDQuNzkwOV0sIFs0Ni4zODkzLCA2LjEzMzFdLCBbNDYuMzI0MiwgNi4xMzE0XSwgWzQ2LjMxNzMsIDYuMTI1Ml0sIFs0Ni4zMDU0LCA2LjExOTRdLCBbNDYuMjk1LCA2LjExOTJdLCBbNDYuMjcyNywgNi4xMTMyXSwgWzQ2LjI0NjgsIDYuMDg3M10sIFs0Ni4yNDE2LCA2LjA2NzZdLCBbNDYuMjMxMSwgNi4wNDZdLCBbNDYuMTIwMSwgNS45MDE1XSwgWzQ2LjA2NzYsIDUuODA4OF0sIFs0NS44OTkyLCA0Ljg3MjddLCBbNDYuMzEzOCwgNS45NDUzXSwgWzQ1LjkxNzcsIDUuODI5XSwgWzQ1LjgxMzIsIDUuNzg0NV0sIFs0NS42NjgyLCA1LjY4NzFdLCBbNDUuNjg0MSwgNS41NjY4XSwgWzQ1Ljg3NTksIDUuMzM2NV0sIFs0NS44MzU0LCA1LjI5OTldLCBbNDUuNzY5OSwgNS4yMTNdLCBbNDYuNDMwMiwgNS4zMjEyXSwgWzQ2LjMxNzQsIDUuNDQ2NF0sIFs0Ni41MDE3LCA1LjAxMzRdLCBbNDYuNDksIDUuMDgyMV0sIFs0Ni40OTI0LCA1LjA4NzldLCBbNDYuNSwgNS4wOTczXSwgWzQ2LjQ5NjYsIDUuMTE3XSwgWzQ2LjQ5ODUsIDUuMTIzMl0sIFs0Ni4yNzA4LCA1LjUwNDJdLCBbNDYuMjY4OCwgNS41MzkxXSwgWzQ2LjUxNTIsIDQuOTgwMl0sIFs0NS42ODczLCA1LjU2MTNdLCBbNDUuNzcxOSwgNS4yMDYxXSwgWzQ2LjAwOTcsIDQuNzQ4Nl0sIFs0Ni4zMTU5LCA1LjY4MzNdLCBbNDYuMDU1MiwgNC43NTE0XSwgWzQ1LjkwNTYsIDQuODYwNF0sIFs0Ni4xMTg5LCA1Ljg5M10sIFs0Ni4zNzg4LCA2LjAxNzZdLCBbNDYuMzgwNiwgNi4wMTc2XSwgWzQ2LjM0MDcsIDYuMTQ1Nl0sIFs0Ni4zMTc1LCA2LjEyNTddLCBbNDYuMzA4NiwgNi4xMTk1XSwgWzQ2LjI5MjcsIDYuMTEyXSwgWzQ2LjM5OTksIDUuMzQ0MV0sIFs0Ni40MzMzLCA1LjMxODJdLCBbNDYuNTA2LCA1LjIwMzddLCBbNDYuNDg5OSwgNS4yMDk4XSwgWzQ2LjQwMTgsIDUuMzM4XSwgWzQ2LjM4NzIsIDUuMzY4N10sIFs0Ni40MDgxLCA1LjMxNjhdLCBbNDYuMzE3MywgNS40NDYyXSwgWzQ2LjQ1OTQsIDUuMjQ4XSwgWzQ2LjQ4NTEsIDUuMjExNV0sIFs0NS44MTM2LCA0LjkxODhdLCBbNDUuODI4OSwgNC45MjA1XSwgWzQ1Ljg0MTIsIDQuOTE3M10sIFs0Ni4zMDE1LCA1LjU5OTVdLCBbNDUuODc4MSwgNC44ODk5XSwgWzQ2LjMyNjQsIDUuNDMzN10sIFs0NS44Njc0LCA1LjgxMTFdLCBbNDUuODI5OCwgNS43OTU5XSwgWzQ1LjgwMzIsIDUuNzg2NV0sIFs0NS43NDEzLCA1Ljc2OThdLCBbNDUuNjI2LCA1LjY0NzhdLCBbNDUuNjI0MiwgNS42MTU5XSwgWzQ1LjY2NTMsIDUuNTg2OF0sIFs0Ni40MDMyLCA1LjMyOTJdLCBbNDYuNDI0MiwgNS4zMTI1XSwgWzQ2LjM4NjcsIDUuMzY4OF0sIFs0Ni4zMjM3LCA1LjQzNDVdLCBbNDYuNDg4NiwgNS4wNzk0XSwgWzQ2LjUxMDgsIDUuMTY2MV0sIFs0Ni40OTk4LCA1LjIwMjddLCBbNDYuMjcxMywgNS40Njc5XSwgWzQ2LjMyNTEsIDUuNjExMV0sIFs0Ni4zMTg4LCA1LjY3ODNdLCBbNDYuNDYwNywgNC45MTM1XSwgWzQ2LjUwNjUsIDQuOTcxM10sIFs0Ni4wODY0LCA1Ljg4ODZdLCBbNDYuMDM1MiwgNC43NDU3XSwgWzQ2LjM4MDksIDYuMDE3OV0sIFs0Ni4zNzgzLCA2LjE1NTFdLCBbNDYuMzI1NSwgNi4xMzI0XSwgWzQ2LjI4MzksIDYuMTA0OF0sIFs0Ni4yODMsIDYuMTA0OF0sIFs0Ni4yNjQ5LCA2LjEyMDJdLCBbNDYuMjQ5MiwgNi4xMjE1XSwgWzQ2LjA5NjgsIDUuODkzM10sIFs0Ni4xMjIyLCA0Ljc3NjddLCBbNDUuODc3MywgNC44OTc3XSwgWzQ2LjI2MywgNS44NTQ2XSwgWzQ2LjM1MTYsIDUuOTc3Ml0sIFs0Ni4xMjM5LCA1LjkwOV0sIFs0Ni4zMTE5LCA1LjYwNzVdLCBbNDUuOTU3MSwgNS44MzI4XSwgWzQ2LjI2NiwgNS43ODYzXSwgWzQ1LjkyNzEsIDUuODIxOV0sIFs0NS44NjE4LCA1LjgwODRdLCBbNDYuMTU1OSwgNS45NzMyXSwgWzQ1LjcxNTgsIDUuNzYwOV0sIFs0NS43MTA5LCA1LjcwMzNdLCBbNDYuNDk2OSwgNS4yMDMyXSwgWzQ2LjQ0ODUsIDUuMjc0OV0sIFs0Ni40ODU2LCA1LjIwOTRdLCBbNDYuNDYwNywgNS4yNDEzXSwgWzQ2LjQzMTcsIDUuMzE5XSwgWzQ2LjMzNCwgNS40MTUxXSwgWzQ2LjMxODMsIDUuNDA0Ml0sIFs0Ni4zNjUxLCA1LjM3NTNdLCBbNDYuMzIzMywgNS40NjY5XSwgWzQ2LjMwMTQsIDUuNDY5OV0sIFs0Ni4xMjA4LCA0Ljc3NTFdLCBbNDYuMzIzMiwgNS42NTI5XSwgWzQ2LjIxNjksIDUuOTc5N10sIFs0Ni4wODc2LCA1Ljg5MDddLCBbNDYuMzE2MywgNS40NzIzXSwgWzQ2LjI2NjEsIDUuODU3OF0sIFs0Ni4yNzE0LCA1LjQ2NjZdLCBbNDYuNCwgNi4xMDUzXSwgWzQ2LjM0MDYsIDYuMTQxN10sIFs0Ni4yNDUyLCA2LjA2MV0sIFs0Ni4yMzM2LCA2LjAyNjFdLCBbNDYuMjI5MSwgNi4wMTA1XSwgWzQ1LjgzMjMsIDUuNDMzN10sIFs0Ni4wODM3LCA1LjgxNzldLCBbNDYuMjczOCwgNS44ODI0XSwgWzQ2LjE3NDMsIDUuOTg5NV0sIFs0NS44MTY2LCA0LjkxOTRdLCBbNDYuMTA0MywgNS44MzQ1XSwgWzQ1Ljg0MywgNC45MTc5XSwgWzQ2LjEzMzgsIDUuOTU4NV0sIFs0NS43OTgzLCA1LjE2NDZdLCBbNDUuOTA4NSwgNC44MzQyXSwgWzQ1LjkzMywgNS44MjM5XSwgWzQ1LjY1NzMsIDUuNjg1Ml0sIFs0NS42MzE3LCA1LjYxMDddLCBbNDYuMzM3OCwgNS45NjQ5XSwgWzQ2LjE3NjgsIDUuOTkyM10sIFs0NS42Mzg5LCA1LjYwNl0sIFs0NS42ODQxLCA1LjU0OF0sIFs0Ni41MDEzLCA1LjAxM10sIFs0Ni41MDY0LCA1LjE1OTRdLCBbNDYuNTA4NywgNS4xOTQzXSwgWzQ2LjM3MzEsIDUuMzY1MV0sIFs0Ni40Njg0LCA1LjIxNzJdLCBbNDYuNDg3OSwgNS4yMDVdLCBbNDYuMzE2LCA1LjQzOThdLCBbNDYuNTEwNCwgNS4wMDg1XSwgWzQ2LjI5MzcsIDUuNTY5MV0sIFs0Ni4zMDk0LCA1LjYwNDZdLCBbNDYuMTczMiwgNS45ODkxXSwgWzQ2LjM1MDgsIDUuOTc1Nl0sIFs0Ni40MTQ5LCA2LjA2NzNdLCBbNDYuMzQ1NSwgNi4xNTEyXSwgWzQ2LjIyODgsIDYuMDA5N10sIFs0Ni4yODA5LCA1LjcxNDVdLCBbNDYuMTMyMiwgNS45NTYxXSwgWzQ1LjkwODcsIDQuODUyOV0sIFs0Ni4zMSwgNS45MzUzXSwgWzQ1Ljk4LCA0Ljc1MjNdLCBbNDUuNzEwMSwgNS43Mzg4XSwgWzQ1LjY3NiwgNS41NTNdLCBbNDUuNzQ0NCwgNS40OTgyXSwgWzQ1Ljc2NjUsIDUuNDcwNl0sIFs0NS43NzEzLCA1LjQ2NjFdLCBbNDUuNzY4NywgNS4yMjM2XSwgWzQ1LjgwMDQsIDUuMTYyXSwgWzQ2LjQ1MTksIDUuMjU1OF0sIFs0Ni40NDk5LCA1LjI5MDddLCBbNDYuMzQyLCA1LjM5XSwgWzQ2LjM2OTEsIDUuMzY5OV0sIFs0Ni4yNjQ2LCA1LjUxMl0sIFs0Ni4yODg3LCA1LjcxNzddLCBbNDYuMjYyMSwgNS44MjEzXSwgWzQ2LjI2MjMsIDUuODQxXSwgWzQ2LjI5MjMsIDUuOTE1N10sIFs0Ni4zMDE2LCA1LjkxNzJdLCBbNDYuNTA1MywgNC45NjgxXSwgWzQ1LjY3MDEsIDUuNTY5XSwgWzQ2LjEyODcsIDQuNzg0OV0sIFs0Ni4xMzkyLCA0Ljc5NThdLCBbNDUuODExLCA1LjA0MjRdLCBbNDYuMzQyNiwgNS45NjY3XSwgWzQ2LjM4MjYsIDYuMDIwNV0sIFs0Ni4zNzk1LCA2LjE0N10sIFs0Ni4zMzgyLCA2LjEzNzhdLCBbNDYuMzM3MywgNi4xMzc4XSwgWzQ2LjMzMDMsIDYuMTM2M10sIFs0Ni4zMTc2LCA2LjEyNThdLCBbNDYuMzA0MSwgNi4xMTk2XSwgWzQ2LjIyMzEsIDYuMDA1NV0sIFs0NS44MTE3LCA1LjA4MDZdLCBbNDUuODA1MSwgNS4wMTM1XSwgWzQ2LjA1MzYsIDQuNzQ3OF0sIFs0NS44NTU3LCA0LjkwMjJdLCBbNDUuODc5NSwgNC44ODgzXSwgWzQ1LjkwNjUsIDQuODU3OV0sIFs0Ni4zMTE1LCA1LjkzMjRdLCBbNDYuMTc3NCwgNS45OTE5XSwgWzQ1LjkwOTksIDQuODM4Ml0sIFs0NS44OTk0LCA0LjgxMjNdLCBbNDUuNjQ2NCwgNS42ODldLCBbNDUuNjMzNywgNS42NDk0XSwgWzQ1Ljc3ODMsIDUuNDYwNF0sIFs0NS43OTYxLCA1LjQzNzVdLCBbNDUuODAxMywgNS40MzEzXSwgWzQ1Ljg4MDEsIDUuMzYxMV0sIFs0NS44ODMsIDUuMzQ4OV0sIFs0Ni41MDAzLCA1LjAxNTFdLCBbNDYuNTE5MSwgNS4xNjc1XSwgWzQ2LjUxMzYsIDUuMTczN10sIFs0Ni40ODY4LCA1LjIwNThdLCBbNDYuNDQ1NiwgNS4yODM3XSwgWzQ2LjM4MjIsIDUuMzc3OV0sIFs0Ni4zMTgxLCA1LjQzNjFdLCBbNDYuMzkzNCwgNS4zNTIyXSwgWzQ2LjI3NDMsIDUuNDYxOF0sIFs0Ni4yNzE2LCA1LjQ2OF0sIFs0NS44MTE5LCA1LjA4M10sIFs0Ni4wMDM4LCA0Ljc0OV0sIFs0Ni4zMjQ0LCA1LjY2NzldLCBbNDUuODA5NiwgNS4wMjc4XSwgWzQ2LjQxMDUsIDYuMDg5N10sIFs0Ni4zNTQ5LCA2LjE1ODJdLCBbNDYuMzMyOSwgNi4xMzgzXSwgWzQ2LjI4MjUsIDYuMTA0N10sIFs0Ni4yMzgzLCA2LjEwMDJdLCBbNDYuMjMxLCA2LjAxMzNdLCBbNDYuMjYyNiwgNS44NDNdLCBbNDYuMjI0MSwgNi4wMDczXSwgWzQ2LjIxNywgNS45Nzg1XSwgWzQ2LjA1OTQsIDUuODA5N10sIFs0Ni4zNDM5LCA1Ljk2ODZdLCBbNDYuMDE3OSwgNS44MDg0XSwgWzQ1LjgwNTQsIDUuMDE1NV0sIFs0NS44MDkyLCA1LjAwNDFdLCBbNDYuMjczNSwgNS41NDYzXSwgWzQ1LjkwNjEsIDQuODI5MV0sIFs0NS45NzU1LCA0Ljc1NDRdLCBbNDUuODM5NywgNS40MTldLCBbNDUuNzA1NCwgNS43NDc1XSwgWzQ1LjcwODYsIDUuNzE1Ml0sIFs0NS42MTk3LCA1LjYxOTNdLCBbNDUuNzk4MSwgNS40MzQ4XSwgWzQ1LjgwNDMsIDUuMTUyOV0sIFs0NS43OTk5LCA1LjExNDZdLCBbNDUuODA1MiwgNS4wMTI1XSwgWzQ2LjQzNzUsIDUuMzE3NF0sIFs0Ni40OTE5LCA1LjAzMV0sIFs0Ni40ODQ5LCA1LjIxMDZdLCBbNDYuNDMxNSwgNS4zMTkxXSwgWzQ2LjM0MywgNS40Mjc0XSwgWzQ2LjQzMDIsIDUuMzIyMV0sIFs0Ni4yNjgyLCA1LjQ4OF0sIFs0Ni4yNjcyLCA1LjUyOF0sIFs0Ni4zMjE2LCA1LjY3MjVdLCBbNDYuMjYzOSwgNS43MzM3XSwgWzQ2LjIzNTksIDQuODA3MV0sIFs0Ni41MTExLCA0Ljk0NDVdLCBbNDYuMzI0NywgNS42NjYxXSwgWzQ2LjA0MTksIDQuNzQxNl0sIFs0Ni4yNjU5LCA1Ljc1MDVdLCBbNDYuMDgxNSwgNC43NTM4XSwgWzQ2LjE2ODQsIDQuNzg0Ml0sIFs0NS44NTMyLCA1LjMwNzldLCBbNDYuMzQ3NSwgNS45NzI5XSwgWzQ2LjQwMTYsIDYuMTAzN10sIFs0Ni4yMjA2LCA2LjAwMTZdLCBbNDUuODI5OCwgNS40MzU2XSwgWzQ2LjA1NzIsIDUuODE0Ml0sIFs0NS45MDQ0LCA0LjgwNjddLCBbNDUuODQ4NiwgNS4zMDNdLCBbNDYuMzQ0OSwgNS45Njk4XSwgWzQ2LjA4NjMsIDUuODE3N10sIFs0NS45NTMxLCA1LjgzNDVdLCBbNDUuODI2MiwgNS43ODg5XSwgWzQ1LjcyODEsIDUuNzc2NV0sIFs0NS43NzE2LCA1LjIzMDldLCBbNDYuNDkzNywgNS4wMjgxXSwgWzQ2LjQ4NjMsIDUuMDc1NF0sIFs0Ni41MDgzLCA1LjIwMTldLCBbNDYuNDE0OCwgNS4zMDddLCBbNDYuNDIwNSwgNS4zMDg1XSwgWzQ2LjQyOTEsIDUuMzIzOV0sIFs0Ni4zMjE3LCA1LjQwNDhdLCBbNDYuMzIzNywgNS40NjU4XSwgWzQ2LjI2ODcsIDUuNTAzOF0sIFs0Ni4yNjY0LCA1LjUyNTFdLCBbNDYuMjM5OSwgNC44MDg5XSwgWzQ2LjUxNDQsIDQuOTUyM10sIFs0Ni41MDYxLCA0Ljk1ODVdLCBbNDYuMTgyOSwgNC43ODAyXSwgWzQ2LjUxOTgsIDQuOTQxNl0sIFs0Ni4wNjc4LCA0Ljc2MThdLCBbNDYuMTU1MSwgNC44MDI5XSwgWzQ2LjIxOTMsIDUuOTkzMl0sIFs0NS42NDQxLCA1LjYwMzZdLCBbNDYuMzkzNiwgNi4wMzddLCBbNDYuMzc5NSwgNi4xNTldLCBbNDYuMjc3MSwgNi4xMDU1XSwgWzQ2LjIzMTIsIDYuMDQ2Ml0sIFs0Ni4yMjY2LCA2LjAwNzldLCBbNDUuOTEyNCwgNC44NDY4XSwgWzQ2LjE5OTYsIDUuOTY2NV0sIFs0Ni4xNzk0LCA1Ljk5MTddLCBbNDUuNzA3OSwgNS43MjA1XSwgWzQ1LjcwMjEsIDUuNzAxXSwgWzQ1LjY0NTEsIDUuNjg4Nl0sIFs0NS43NDIzLCA1LjQ5OThdLCBbNDUuNzQ5NSwgNS40ODkxXSwgWzQ2LjE1NDEsIDUuOTcxNl0sIFs0NS43ODc4LCA1LjE4MjRdLCBbNDYuNDg3MSwgNS4yMDU0XSwgWzQ2LjQ1MTIsIDUuMjY2Ml0sIFs0Ni41MDEyLCA1LjIwMDddLCBbNDYuNDkyNywgNS4yMTAxXSwgWzQ2LjQ4NDUsIDUuMDU5XSwgWzQ2LjUxNjQsIDUuMTcxOF0sIFs0Ni4zMTc4LCA1LjQ1NjldLCBbNDYuNDI3MywgNS4zMjI3XSwgWzQ2LjI5MzMsIDUuNTkxMV0sIFs0Ni4zMjEzLCA1LjYxMV0sIFs0Ni41MDYzLCA0Ljk2NV0sIFs0Ni4yNzMxLCA0LjgyNDhdLCBbNDYuMjY5NiwgNS41MDQyXSwgWzQ2LjM0LCA1Ljk2NTddLCBbNDYuMDc2MSwgNS44MTE2XSwgWzQ2LjExNTQsIDUuODkwM10sIFs0Ni4zNjYxLCA1Ljk5M10sIFs0NS44MTQ1LCA1LjI5MDddLCBbNDYuMjk5OSwgNS43MTg0XSwgWzQ2LjQwOCwgNi4wOTgzXSwgWzQ2LjMzNzQsIDYuMTM4MV0sIFs0Ni4yOTQ0LCA2LjExOTVdLCBbNDYuMjkxLCA2LjExMDddLCBbNDYuMjQ5LCA2LjEyMTJdLCBbNDYuMjQ4MywgNi4xMjFdLCBbNDYuMjQ0OSwgNi4xMTY3XSwgWzQ2LjIyODcsIDYuMDEzMV0sIFs0Ni4yMTcsIDUuOTg0NV0sIFs0NS44NTc2LCA0LjkwMDZdLCBbNDUuODc0NSwgNC45MDY4XSwgWzQ1LjkwNjIsIDQuODI4OV0sIFs0NS45MjUyLCA1LjgyMzFdLCBbNDYuMDg2OCwgNS44NzE3XSwgWzQ1Ljg5OTgsIDUuODI0Nl0sIFs0NS42OTk1LCA1LjU0ODldLCBbNDUuNjkzNCwgNS41NjA5XSwgWzQ1LjY5OTgsIDUuNTU2NF0sIFs0NS44MjQ1LCA1LjQyMzldLCBbNDYuNDMxOCwgNS4zMTg1XSwgWzQ2LjQ4NiwgNS4wNTE4XSwgWzQ2LjQ2MDYsIDUuMjQzOF0sIFs0Ni41MTIxLCA1LjE2NzhdLCBbNDYuNTA1MiwgNS4xNjE2XSwgWzQ2LjQ0ODEsIDUuMjc1OV0sIFs0Ni4zNjk5LCA1LjM2MjhdLCBbNDYuNDc0OCwgNS4yMTM0XSwgWzQ2LjMyMzYsIDUuNDY2NF0sIFs0Ni4yOTI4LCA1LjQ2NjRdLCBbNDYuMDQ0NSwgNC43Mzk5XSwgWzQ1Ljc3MTIsIDUuMTk0OV0sIFs0Ni4zNjk4LCA2LjAwMDNdLCBbNDYuMzcwOSwgNi4wMDE4XSwgWzQ2LjM3MTEsIDYuMDAxOF0sIFs0Ni4zNzEzLCA2LjAwMl0sIFs0Ni4zNzExLCA2LjAwMzVdLCBbNDYuMzcxNiwgNi4wMDUxXSwgWzQ2LjM3MjIsIDYuMDA2NV0sIFs0Ni4zNzI3LCA2LjAwNjZdLCBbNDYuMzcyOSwgNi4wMDY0XSwgWzQ2LjM3MzcsIDYuMDA3OV0sIFs0Ni4zMTAxLCA1LjkzNV0sIFs0Ni40MDIsIDYuMTAzM10sIFs0Ni4zNzg5LCA2LjE1ODFdLCBbNDYuMzQxNCwgNi4xNDQ2XSwgWzQ2LjMyOTUsIDYuMTM1Ml0sIFs0Ni4yOTgxLCA2LjEyMDJdLCBbNDYuMjY5NiwgNS44NjU5XSwgWzQ2LjI0MTksIDYuMDY4Ml0sIFs0Ni4yMjc2LCA2LjAxMDJdLCBbNDUuODEwNSwgNS4wNDEyXSwgWzQ1LjkxMDksIDQuODQxNl0sIFs0NS45MjA4LCA0LjgwNzhdLCBbNDUuODA5LCA1LjAzMDldLCBbNDYuMzE5NSwgNS45NDkxXSwgWzQ2LjM0NTUsIDUuOTcwM10sIFs0Ni4xMDM4LCA1LjgxOTZdLCBbNDUuODA3LCA1Ljc4NjhdLCBbNDYuMDg1MSwgNS44NjEzXSwgWzQ1LjgwNTIsIDUuNzg2OF0sIFs0NS43MTc1LCA1Ljc2MjRdLCBbNDUuNjIyNCwgNS42Mzc0XSwgWzQ2LjM0MywgNS40MTY2XSwgWzQ2LjUwMDQsIDUuMDE0Ml0sIFs0Ni40ODY0LCA1LjA1MDZdLCBbNDYuNDg4OSwgNS4wNzhdLCBbNDYuMzIxOCwgNS40MzQ4XSwgWzQ2LjQ0NzEsIDUuMjg3MV0sIFs0Ni40MzczLCA1LjMxNzVdLCBbNDYuMzE1OCwgNS40NDA4XSwgWzQ2LjQyMiwgNS4zMDY2XSwgWzQ2LjI2NjIsIDUuNTI0OV0sIFs0Ni41MDcyLCA0Ljk2NDFdLCBbNDYuMjY2NywgNS41MjZdLCBbNDYuMzE2MSwgNS45NDY5XSwgWzQ2LjExMzEsIDUuODg4OF0sIFs0Ni4yNjcsIDUuODczMl0sIFs0Ni4wMzkxLCA1LjgwOV0sIFs0Ni40MDk2LCA2LjA1MThdLCBbNDYuMzc3NiwgNi4xNTQxXSwgWzQ2LjI5NzYsIDYuMTIwM10sIFs0Ni4yNzUyLCA2LjEwODNdLCBbNDYuMzY2NSwgNS45OTM2XSwgWzQ2LjIyMDEsIDZdLCBbNDUuNzA5NywgNS41NTI1XSwgWzQ2LjEwMjYsIDUuODE5OV0sIFs0NS44MzI3LCA0LjkyMTFdLCBbNDUuOTAzMywgNC44NjkzXSwgWzQ2LjI2ODEsIDUuODc2M10sIFs0NS43NDIyLCA1Ljc3MjFdLCBbNDUuNzQxNywgNS43NzA2XSwgWzQ1LjcwNTksIDUuNzQ2XSwgWzQ1LjY2ODcsIDUuNjg4Ml0sIFs0NS42MzgxLCA1LjY2N10sIFs0NS42MjQ0LCA1LjY0NTZdLCBbNDUuNjg1LCA1LjU2MzJdLCBbNDYuNTA0LCA1LjE2NzFdLCBbNDYuNDMwMSwgNS4zMjA4XSwgWzQ2LjQ4OTEsIDUuMDgwMl0sIFs0Ni4zMzI4LCA1LjQwMTddLCBbNDYuMzQyNCwgNS40MTY5XSwgWzQ2LjI5MDUsIDUuNDU5NV0sIFs0Ni4yNzAxLCA1LjQ2ODddLCBbNDYuMjY4MiwgNS41MDRdLCBbNDYuMjc0OCwgNS44ODM1XSwgWzQ2LjMxMzgsIDUuOTI1OV0sIFs0Ni4yODQ2LCA0LjgyODddLCBbNDYuMTQ2NiwgNS45NjZdLCBbNDYuMDgxLCA1LjgxNjFdLCBbNDUuNzcwNSwgNS4yMjldLCBbNDUuODA2MSwgNS4wMDg2XSwgWzQ2LjM3ODcsIDYuMTQ4Ml0sIFs0Ni4zMTk0LCA2LjEyNTNdLCBbNDYuMjY2MSwgNS41MDg1XSwgWzQ2LjI5NjIsIDYuMTE5M10sIFs0Ni4yODQ4LCA2LjEwMjRdLCBbNDYuMjQxOCwgNi4wOTQ5XSwgWzQ2LjIzNzIsIDYuMDM1NF0sIFs0NS44NjMyLCA1LjMyODRdLCBbNDYuMzE4LCA1Ljk0NzddLCBbNDYuMTI4LCA1Ljk0MzRdLCBbNDYuMzIxMiwgNS45NTAyXSwgWzQ1Ljg0MDYsIDQuOTE2OV0sIFs0NS45OTc5LCA1LjgxMDZdLCBbNDUuOTk1NywgNS44MTA1XSwgWzQ1Ljk4ODIsIDUuODEwNV0sIFs0NS45ODQ1LCA1LjgxNV0sIFs0NS45ODQ0LCA1LjgxNTFdLCBbNDUuOTg0MywgNS44MTUzXSwgWzQ1Ljk3ODksIDUuODI1OV0sIFs0NS45NzUxLCA1LjgzMjFdLCBbNDYuMDQzOCwgNS44MDddLCBbNDUuOTczMSwgNS44MzM2XSwgWzQ2LjIxNjksIDUuOTg0NV0sIFs0Ni4xMjc5LCA1Ljk0NjJdLCBbNDUuOTMzNCwgNS44MjQ0XSwgWzQ1Ljc3NzQsIDUuNzgwMV0sIFs0NS43MjU0LCA1Ljc3NTZdLCBbNDUuNjkxNSwgNS41NjJdLCBbNDYuNDM4OCwgNS4zMTY2XSwgWzQ2LjQxMDMsIDUuMzA5MV0sIFs0Ni40OTE3LCA1LjAzNzddLCBbNDYuNDg2NSwgNS4wNzI4XSwgWzQ2LjUwMzcsIDUuMTM1M10sIFs0Ni40OTY2LCA1LjIwNF0sIFs0Ni4zMTg3LCA1LjQ0NDNdLCBbNDYuNDQ2NCwgNS4yODQ0XSwgWzQ2LjI2OTUsIDUuNzIwNV0sIFs0Ni4zMDk1LCA1LjkzNzNdLCBbNDYuNTA1MiwgNC45Njk0XSwgWzQ2LjE1NTQsIDUuOTcyOF0sIFs0NS42Njg4LCA1LjU3OTddLCBbNDYuMDMyNiwgNC43NDY4XSwgWzQ2LjM2NjUsIDUuOTk0XSwgWzQ2LjM5NzEsIDYuMTE4MV0sIFs0Ni4zMTY3LCA2LjEyNDNdLCBbNDYuMjQxMywgNi4wNzFdLCBbNDYuMTMyLCA1Ljk1NTldLCBbNDUuODUzNCwgNC45MDk1XSwgWzQ1Ljg3MSwgNC45MDgyXSwgWzQ1Ljg3OSwgNC44ODk4XSwgWzQ1LjkyMzIsIDQuNzg5Ml0sIFs0NS44NDk1LCA1LjgwMl0sIFs0NS44MjY4LCA1Ljc4OTZdLCBbNDUuODE4OCwgNS43ODQ5XSwgWzQ1Ljc3OTIsIDUuNzgwNF0sIFs0NS42NjczLCA1LjY4NThdLCBbNDUuNjQ4NSwgNS42ODkyXSwgWzQ1LjYzMSwgNS42MTE3XSwgWzQ2LjQ5NDQsIDUuMjA0M10sIFs0Ni40NzYxLCA1LjIxMzNdLCBbNDYuMzM3NiwgNS40MjY3XSwgWzQ2LjM0MjEsIDUuMzkwMV0sIFs0Ni40ODUxLCA1LjA1MTldLCBbNDYuNDg1NiwgNS4wNjU0XSwgWzQ2LjQ5MTEsIDUuMDg1M10sIFs0Ni40OTE3LCA1LjEwODJdLCBbNDYuNTAxMSwgNS4xMjk2XSwgWzQ2LjUxNDUsIDUuMTcyMl0sIFs0Ni4yNzYzLCA0LjgyNjVdLCBbNDYuMzQwMiwgNC44NTI2XSwgWzQ2LjM1MjMsIDQuODUxMV0sIFs0Ni4yNzEyLCA1Ljg2NDNdLCBbNDYuMTk2OSwgNS45NjQxXSwgWzQ1LjgxMTgsIDUuMDkyNl0sIFs0Ni4zNTQ3LCA1Ljk4MDFdLCBbNDYuMzc5NCwgNi4xNTgyXSwgWzQ2LjM0MiwgNi4xNDczXSwgWzQ2LjUxMTQsIDUuMDAyN10sIFs0NS42MTEyLCA1LjYzMTZdLCBbNDUuOTA4LCA0LjgzMzhdLCBbNDUuOTQsIDQuNzMzMl0sIFs0NS45Mzg3LCA1LjgyODJdLCBbNDUuODIzMywgNS43ODcxXSwgWzQ1LjgyMywgNS43ODY5XSwgWzQ1Ljc5MjksIDUuNzg0MV0sIFs0NS43NjQ2LCA1Ljc4MDddLCBbNDUuNzQyNywgNS43Nzk0XSwgWzQ1LjcyOTIsIDUuNzc2Ml0sIFs0Ni40NTYzLCA1LjI1MzRdLCBbNDYuMzE3OSwgNS40NDQxXSwgWzQ2LjQ5MSwgNS4wNDE1XSwgWzQ2LjM5OTIsIDUuMzMxMV0sIFs0Ni40MDA2LCA1LjMzMTNdLCBbNDYuMjg0LCA1Ljg5MjNdLCBbNDYuMzEsIDUuOTQwOV0sIFs0Ni4zMTU3LCA1Ljk0NzFdLCBbNDYuMDk1OCwgNS44MjM2XSwgWzQ2LjAyNjYsIDUuODEyNF0sIFs0Ni41MDczLCA0Ljk3MTddLCBbNDYuNTEzNSwgNC45MzgxXSwgWzQ2LjM2NTcsIDQuODU2OF0sIFs0Ni40OTkzLCA0LjkyN10sIFs0Ni41MDUxLCA0LjkyOThdLCBbNDYuNTE1LCA0Ljk0MDVdLCBbNDYuMjQ1NywgNC44MTA4XSwgWzQ2LjM0NzEsIDQuODUyM10sIFs0Ni4yNiwgNC44MTFdLCBbNDYuNTE1OSwgNC45NDIyXSwgWzQ2LjUxMTQsIDQuOTUyN10sIFs0Ni41MTAyLCA0Ljk2NjZdLCBbNDYuMTQ2NCwgNS45NjU3XSwgWzQ2LjI2NTYsIDUuNDc4MV0sIFs0Ni4zMTY3LCA1LjYwOF0sIFs0Ni4xMjI1LCA1LjkwNjhdLCBbNDYuMzgxOSwgNi4wMl0sIFs0Ni4zOTY2LCA2LjAzOTVdLCBbNDYuMjY0NiwgNS41MTEzXSwgWzQ2LjM5OTUsIDYuMTEyOV0sIFs0Ni4zNzc2LCA2LjE0OTNdLCBbNDYuMzQwNywgNi4xNDVdLCBbNDYuMzM4OCwgNS42NDAxXSwgWzQ2LjMzOTUsIDYuMTQwM10sIFs0Ni4zMzg3LCA2LjEzODZdLCBbNDYuMjQ0NSwgNi4wOTE1XSwgWzQ1Ljg4MzYsIDUuMzUwNV0sIFs0NS45NjQ1LCA0Ljc1MDJdLCBbNDUuNzkxMywgNS43ODQyXSwgWzQ2LjA5NTQsIDUuODQ0M10sIFs0NS42MjUzLCA1LjY0NzJdLCBbNDUuNzAxMSwgNS41NTQxXSwgWzQ1LjgxMDEsIDUuMDY5M10sIFs0Ni41MDk1LCA1LjE2NTVdLCBbNDYuNTE1NSwgNS4xNzE1XSwgWzQ2LjUxMTEsIDUuMTc3NV0sIFs0Ni40Nzc2LCA1LjIxMjhdLCBbNDYuNDI1NywgNS4zMTM0XSwgWzQ2LjI4OTQsIDUuNDYyNl0sIFs0Ni4zMjg5LCA1LjYxNjVdLCBbNDYuMjY3NiwgNS44NzU3XSwgWzQ2LjM2OTIsIDUuOTk5Ml0sIFs0Ni4wODY2LCA1Ljg3NDJdLCBbNDYuMTc2NywgNC43ODAyXSwgWzQ2LjI2MzMsIDQuODEzNl0sIFs0Ni41MDczLCA0Ljk0NDZdLCBbNDYuNTE1LCA0Ljk3NTRdLCBbNDUuODQ5OCwgNS4zMDU3XSwgWzQ2LjEwMDgsIDQuNzYwM10sIFs0Ni4zNTk3LCA1Ljk4MjZdLCBbNDYuMTMxNCwgNC43ODc5XSwgWzQ2LjE0NDMsIDQuNzk5OV0sIFs0Ni4zODIyLCA2LjAyMDNdLCBbNDYuMzk2OSwgNi4wNF0sIFs0Ni4zODAyLCA2LjE0NjZdLCBbNDYuMzc3NCwgNi4xNDk4XSwgWzQ2LjI0NTEsIDYuMDgyNl0sIFs0Ni4yMzMxLCA2LjA0NzVdLCBbNDYuMzE0NSwgNS45NDYyXSwgWzQ2LjM0NTYsIDUuOTcwNl0sIFs0NS44MzEyLCA0LjkyMTVdLCBbNDUuOTA4LCA0LjgxMDRdLCBbNDUuOTk5MSwgNC43NDkyXSwgWzQ1Ljc4NDIsIDUuNzgzXSwgWzQ1Ljc0MDIsIDUuNTAyNl0sIFs0NS44MDE0LCA1LjQzMTFdLCBbNDUuNzY5MSwgNS4yMjU0XSwgWzQ2LjUwODEsIDUuMTk0OV0sIFs0Ni40MjQ1LCA1LjMwOV0sIFs0Ni4zNDM5LCA1LjM4NjldLCBbNDYuNDQ2NywgNS4zMDEzXSwgWzQ2LjQ4NjEsIDUuMDUxM10sIFs0Ni40ODcyLCA1LjIwNTZdLCBbNDYuMzQwOSwgNS40MjVdLCBbNDYuMzE1NywgNS40NF0sIFs0Ni41MTU4LCA1LjE3MThdLCBbNDYuNTA5OSwgNS4wMDc0XSwgWzQ2LjUxMzksIDQuOTQ2OF0sIFs0Ni4zOTQzLCA0Ljg4MTFdLCBbNDYuNTE0MiwgNC45NDUzXSwgWzQ2LjQ2NjgsIDQuOTE2XSwgWzQ2LjIzNDgsIDYuMDI4M10sIFs0Ni4wMDYxLCA1LjgwOTddLCBbNDYuMzQ3NywgNS45NzM0XSwgWzQ1LjcyLCA1LjUyMzZdLCBbNDUuNzQ3MywgNS40OTNdLCBbNDUuODgzNywgNS4zNTFdLCBbNDUuODEyLCA1LjA0NjNdLCBbNDYuMjY2OSwgNS43NzM5XSwgWzQ2LjAxMjMsIDUuODA3N10sIFs0Ni4zNzc3LCA2LjAxNjFdLCBbNDYuNDE2MywgNi4wNTcyXSwgWzQ2LjQxNjksIDYuMDU4N10sIFs0Ni4zNDc0LCA2LjE1MThdLCBbNDYuMjcxMiwgNS44NjQxXSwgWzQ2LjI2NjEsIDYuMTE2N10sIFs0Ni4yNDMsIDYuMDkzNl0sIFs0Ni4yMzQyLCA2LjA0OTddLCBbNDYuMzI3NiwgNS45NTQ2XSwgWzQ1Ljc5NjQsIDUuMTY3M10sIFs0Ni4wNTA1LCA1LjgxMl0sIFs0NS44NDUyLCA0LjkxNThdLCBbNDUuOTAzOSwgNC44MjI5XSwgWzQ1Ljg5NjQsIDQuODA2XSwgWzQ1LjgwNTIsIDUuNDI0OV0sIFs0NS44MjUyLCA1Ljc4ODJdLCBbNDUuODIyNiwgNS43ODY1XSwgWzQ1LjY3MzMsIDUuNTUxN10sIFs0Ni4wODUzLCA1Ljg3ODJdLCBbNDUuODU5MSwgNS40MDFdLCBbNDUuODYzNiwgNS4zMjkzXSwgWzQ1LjgwNDYsIDUuMTA1XSwgWzQ2LjUwNzcsIDUuMTUyNF0sIFs0Ni40MTY2LCA1LjMwMThdLCBbNDYuNDAxOCwgNS4zNDE0XSwgWzQ2LjUwODksIDUuMDEwN10sIFs0Ni40ODcyLCA1LjA0ODhdLCBbNDYuNDg1NywgNS4wN10sIFs0Ni40OTUzLCA1LjA4ODZdLCBbNDYuNTAxNCwgNS4xMzEyXSwgWzQ2LjQyNTYsIDUuMzE0Ml0sIFs0Ni41MDQxLCA1LjIwMTRdLCBbNDYuMjI5NywgNC44MDA3XSwgWzQ2LjMwMTQsIDQuODM0M10sIFs0Ni41MDQ3LCA0Ljk1NDZdLCBbNDYuMzg1LCA0Ljg3MzldLCBbNDYuNTA1LCA0Ljk0NDFdLCBbNDYuNTExNywgNC45OTcyXSwgWzQ2LjQ5MjUsIDQuOTE5N10sIFs0Ni4zMTI2LCA1Ljk0MzRdLCBbNDYuMDc0LCA1LjgxMDZdLCBbNDUuODA5OCwgNS4wNTk1XSwgWzQ2LjMwMjksIDYuMTE4N10sIFs0NS43ODk0LCA1LjE4MTVdLCBbNDYuMTU3OCwgNC44MDE3XSwgWzQ2LjMyMDcsIDUuOTUwMV0sIFs0Ni4zMzY0LCA1LjYzNzVdLCBbNDUuODI5NywgNC45MTkzXSwgWzQ1Ljg5NjUsIDQuODc2NV0sIFs0NS45MDU5LCA0LjgyNzddLCBbNDUuOTM3MiwgNC43NzkxXSwgWzQ1LjkzODcsIDQuNzY5OV0sIFs0NS45Njg2LCA0Ljc1M10sIFs0NS42MTMxLCA1LjYzNDZdLCBbNDUuNjQxLCA1LjYwNTddLCBbNDUuNjY4MywgNS41ODI4XSwgWzQ1LjY4MTYsIDUuNTUwN10sIFs0NS43NDUzLCA1LjQ5NzJdLCBbNDUuNzA4MywgNS41NTRdLCBbNDUuODQ3NCwgNS40MTY1XSwgWzQ2LjMzOTcsIDUuNDE2Nl0sIFs0Ni4zMTUxLCA1LjQzNzhdLCBbNDYuNTA3LCA1LjAwOTVdLCBbNDYuNDg2NSwgNS4wNzM3XSwgWzQ2LjUxMTksIDUuMTc1OF0sIFs0Ni40NjU4LCA1LjIyODldLCBbNDYuMzM5NCwgNS4zOTk3XSwgWzQ2LjMzMDMsIDUuNDE0OV0sIFs0Ni4yODc2LCA1LjQ1OTJdLCBbNDYuMjY5MywgNS44NjYzXSwgWzQ2LjQ3NTUsIDQuOTE1NV0sIFs0Ni41MTIzLCA0LjkzOTddLCBbNDYuMTE4MSwgNC43NzIxXSwgWzQ2LjM1NzgsIDUuOTgxNF0sIFs0Ni4zMDkxLCA1LjQxMDJdLCBbNDYuMzkwOSwgNi4wMzQ5XSwgWzQ2LjQxMjYsIDYuMDUzM10sIFs0Ni4zNzczLCA2LjE1MjRdLCBbNDYuMjk0NywgNi4xMTQzXSwgWzQ2LjI2MjgsIDUuODQ1NV0sIFs0Ni4yOTAxLCA2LjEwOTZdLCBbNDYuMjU3NiwgNi4xMjE4XSwgWzQ2LjI0NDQsIDYuMDc3N10sIFs0Ni4yNDI1LCA2LjA1NzhdLCBbNDUuNjkwMiwgNS41NDY2XSwgWzQ1LjgyMDUsIDQuOTIxMV0sIFs0NS44NzI1LCA1LjM3NDVdLCBbNDUuOTAzNiwgNC44Njc4XSwgWzQ1Ljc2ODUsIDUuMjIxMV0sIFs0NS45MTExLCA0Ljg0MzJdLCBbNDUuOTEsIDQuODM3NF0sIFs0NS45MDE3LCA0LjgxNzVdLCBbNDUuOTAwOSwgNC44MTU4XSwgWzQ1LjkxNzksIDQuODFdLCBbNDYuMTk5OSwgNS45Njg2XSwgWzQ1LjgwMTcsIDUuNzg2XSwgWzQ1LjcyNTEsIDUuNzc1M10sIFs0NS43MDg3LCA1Ljc1NjddLCBbNDUuNzA5OSwgNS43MDA2XSwgWzQ1LjY3MDQsIDUuNjkxNF0sIFs0NS42NzQ0LCA1LjU2MzJdLCBbNDUuNjcyMywgNS41NTI1XSwgWzQ2LjMxMDMsIDUuNDA0N10sIFs0Ni40NTAyLCA1LjI1NjhdLCBbNDYuMzQxMywgNS40MTY5XSwgWzQ2LjQ0OTksIDUuMjU4M10sIFs0Ni40NDI5LCA1LjMxNDZdLCBbNDYuNDk5OCwgNS4wOTY3XSwgWzQ2LjUwNDcsIDUuMjAzNV0sIFs0Ni40ODYyLCA1LjIwODJdLCBbNDYuNDQ2MSwgNS4yODI3XSwgWzQ2LjM5OCwgNS4zMzNdLCBbNDYuMzIsIDQuODQ3MV0sIFs0Ni4wODMyLCA0Ljc0ODJdLCBbNDYuMDk2LCA0Ljc1NDJdLCBbNDYuMTEwNCwgNC43NzExXSwgWzQ2LjM0MywgNS45NjddLCBbNDYuMzk5NywgNi4wNDMxXSwgWzQ2LjMwNzcsIDYuMTE5MV0sIFs0Ni4yMzUzLCA2LjA1MDhdLCBbNDUuODExNywgNS4wNDQ4XSwgWzQ1LjgxNDQsIDQuOTIwMV0sIFs0NS44MjQ0LCA0LjkxOTldLCBbNDUuODc0MywgNC45MDY0XSwgWzQ1Ljk2MDYsIDQuNzQ2MV0sIFs0Ni4zMTI3LCA1Ljk0NTFdLCBbNDUuOTE4NiwgNS44Mjg3XSwgWzQ2LjE0MzgsIDUuOTY0Nl0sIFs0Ni4yMTcsIDUuOTgzOV0sIFs0NS42ODM4LCA1LjcwODZdLCBbNDUuNjgwMSwgNS43MDU2XSwgWzQ1Ljc3NzMsIDUuNDYxNF0sIFs0NS44MjA4LCA1LjI5MDhdLCBbNDYuNDMwMiwgNS4zMjExXSwgWzQ2LjMzOSwgNS40MDJdLCBbNDYuNDA5LCA1LjMxNTNdLCBbNDYuNDg0NiwgNS4wNjIxXSwgWzQ2LjUxNzgsIDUuMTY4OV0sIFs0Ni40NTkxLCA1LjI0ODFdLCBbNDYuMzQzNSwgNS4zODY4XSwgWzQ2LjQzODYsIDUuMzE2Nl0sIFs0Ni4zODU2LCA1LjM3MTZdLCBbNDYuMzIxOCwgNS40Njc3XSwgWzQ2LjE3MzYsIDUuOTgyN10sIFs0NS42ODE4LCA1LjU1MDZdLCBbNDYuMTEyLCA0Ljc3MTJdLCBbNDYuMTcyMiwgNC43ODE5XSwgWzQ2LjI5NDMsIDUuOTE0Nl0sIFs0Ni4zMTc1LCA1Ljk0OF0sIFs0Ni4zODExLCA2LjAxOTJdLCBbNDYuMzg0NywgNi4wMjY3XSwgWzQ2LjM5NDYsIDYuMDM3Ml0sIFs0Ni40MDgxLCA2LjA5ODJdLCBbNDYuMjY3OSwgNS43NjVdLCBbNDYuNDA1NywgNi4wOTk5XSwgWzQ2LjM1NjYsIDYuMTU5Ml0sIFs0Ni4yNzg2LCA1Ljg4OF0sIFs0Ni4zNTM2LCA2LjE1NzldLCBbNDYuMzM2NiwgNi4xMzhdLCBbNDUuODQ2LCA0LjkxNDRdLCBbNDUuOTM0NiwgNC43NTg4XSwgWzQ1Ljk0NjcsIDQuNzI4Ml0sIFs0NS45OTY0LCA0Ljc0OTZdLCBbNDYuMjg4LCA1LjU2MTldLCBbNDUuNjgyLCA1LjU1MDNdLCBbNDYuMDg2OSwgNS44ODk3XSwgWzQ1LjgxNiwgNS40MjA2XSwgWzQ2LjM0NTcsIDUuOTcyNF0sIFs0NS44MDk0LCA1LjI4NjZdLCBbNDUuNzE1LCA1LjUyODFdLCBbNDUuODA2NCwgNS4wMTk5XSwgWzQ2LjQyNDEsIDUuMzEwOV0sIFs0Ni4zNzYyLCA1LjM3MDZdLCBbNDYuNDk2NCwgNS4wMjI4XSwgWzQ2LjUwMDMsIDUuMTI5NF0sIFs0Ni40OTEsIDUuMjEwNV0sIFs0Ni40NTU1LCA1LjI1NDZdLCBbNDYuNDE2MywgNS4zMTI2XSwgWzQ2LjQ2OTIsIDUuMjIxMl0sIFs0Ni4yNjQ0LCA1LjUxNjhdLCBbNDYuMjk0NCwgNS41Nzc2XSwgWzQ2LjE4OTgsIDQuNzgwOV0sIFs0Ni41MTk5LCA0Ljk0MjNdLCBbNDUuNzM0NSwgNS41MTIyXSwgWzQ2LjI2MjIsIDUuODQ2Ml0sIFs0Ni4wOCwgNS44MTI5XSwgWzQ2LjMzNzUsIDUuNjM4Ml0sIFs0Ni4zOTA0LCA2LjEzMDhdLCBbNDYuMzEyLCA2LjEyMDFdLCBbNDYuMjMwNywgNi4wMTQ4XSwgWzQ2LjIyNTQsIDYuMDA3M10sIFs0Ni4wODksIDUuODkxNl0sIFs0Ni4wODU4LCA1Ljg4NzRdLCBbNDUuODk2OSwgNC44NzgxXSwgWzQ2LjIxNTMsIDUuOTkyNF0sIFs0NS44NjA4LCA1LjM5NzJdLCBbNDYuMjYyOSwgNS43MzFdLCBbNDUuOTM4OSwgNS44MjUyXSwgWzQ1LjgyMzIsIDUuNzg2OV0sIFs0NS44MTY1LCA1Ljc4NDFdLCBbNDUuNzc2NCwgNS43ODA3XSwgWzQ1Ljc2MjIsIDUuNzc5NF0sIFs0NS43NDI5LCA1LjQ5OV0sIFs0NS43OTMsIDUuMjcxN10sIFs0Ni40NTcxLCA1LjI1MDJdLCBbNDYuNDI3MywgNS4zMjIxXSwgWzQ2LjQyNCwgNS4zMTI5XSwgWzQ2LjM5NzYsIDUuMzUyNV0sIFs0Ni4zNzgzLCA1LjM3MjRdLCBbNDYuMzY2MSwgNS4zNzIyXSwgWzQ2LjQ5ODUsIDUuMDk4XSwgWzQ2LjQ4MjQsIDUuMjEzOF0sIFs0Ni40NzQ3LCA1LjIxMzhdLCBbNDYuMzE2LCA1LjQ3MjhdLCBbNDYuMjI3NywgNC43OTk0XSwgWzQ2LjUwMzUsIDQuOTQ3NV0sIFs0Ni40ODA3LCA1LjIxMTldLCBbNDYuMDUxNCwgNS44MTI1XSwgWzQ2LjM4MzYsIDYuMDI0NV0sIFs0Ni4xMDg3LCA1Ljg4NTZdLCBbNDYuMzI2NiwgNS42NDQ2XSwgWzQ1Ljg0NiwgNC45MTVdLCBbNDYuMTIxMSwgNS45MDQ5XSwgWzQ1Ljg5NjMsIDQuODA1Ml0sIFs0NS44ODI1LCA1LjM1NTVdLCBbNDUuOTM5MiwgNC43NzE4XSwgWzQ1Ljk0MDcsIDQuNzMyMl0sIFs0NS45NDk0LCA1LjgzM10sIFs0NS43MjI1LCA1Ljc3MDVdLCBbNDUuNjk4NCwgNS43MDM1XSwgWzQ1LjY4MTEsIDUuNzA2N10sIFs0NS42NzIxLCA1LjU2OTNdLCBbNDUuNjg4MSwgNS41NDUxXSwgWzQ1LjcxNzYsIDUuNTI1XSwgWzQ2LjUwNTEsIDUuMTYyM10sIFs0Ni40OTg5LCA1LjAxOTFdLCBbNDYuNDk2NSwgNS4wOTIxXSwgWzQ2LjQxNjIsIDUuMzAxXSwgWzQ2LjI3MTEsIDUuNDY0M10sIFs0Ni4yNzAyLCA1LjU0Ml0sIFs0Ni4zMzg0LCA1LjYzOTRdLCBbNDYuMzEwOCwgNS42ODU0XSwgWzQ2LjI5MSwgNS43MTg4XSwgWzQ2LjI2MjIsIDUuODQwNl0sIFs0Ni4zMzE3LCA0Ljg1MzJdLCBbNDYuMzg4LCA0Ljg3NjFdLCBbNDYuMTg2OCwgNC43ODAyXSwgWzQ2LjUwNDEsIDQuOTI5Nl0sIFs0Ni4xNTIxLCA1Ljk2OTNdLCBbNDYuMTUzOSwgNC44MDI5XSwgWzQ2LjQxNjYsIDYuMDU4Ml0sIFs0Ni4zOTc1LCA2LjExNDldLCBbNDYuMzUyNCwgNi4xNTc1XSwgWzQ2LjM1MDYsIDYuMTU3NV0sIFs0Ni4zMzAxLCA2LjEzNjFdLCBbNDYuMjcwNiwgNi4xMV0sIFs0Ni4yNTk5LCA2LjEyMDddLCBbNDYuMjQ2NywgNi4wODQxXSwgWzQ2LjI0NDMsIDYuMDc4MV0sIFs0Ni4yNDE4LCA2LjA3MzZdLCBbNDYuMTA2MSwgNS44MjkzXSwgWzQ2LjA4NDksIDUuODgzMl0sIFs0NS44MjQ0LCA1Ljc4NzldLCBbNDYuMzE3OCwgNS45NDc3XSwgWzQ1LjcxMDYsIDUuNzA4M10sIFs0NS42Mzg0LCA1LjY3ODFdLCBbNDUuNjM3OCwgNS42NTUyXSwgWzQ1LjY5NSwgNS41NDU0XSwgWzQ1Ljc0NTYsIDUuNDk2Nl0sIFs0Ni40NDYsIDUuMzEzN10sIFs0Ni4zNDE5LCA1LjM4OTddLCBbNDYuNDUwNywgNS4yNjE5XSwgWzQ2LjQyNzgsIDUuMzE5OV0sIFs0Ni4zMTUyLCA1LjQxMjhdLCBbNDYuNTExMSwgNC45NDldLCBbNDYuNTA3MywgNS4xNDQ2XSwgWzQ2LjMxNjksIDUuNDY5M10sIFs0Ni4yNzI2LCA1LjU0NTNdLCBbNDYuMzA5OSwgNS42MDY1XSwgWzQ2LjUwMDgsIDQuOTUyOF0sIFs0Ni4xOTgyLCA0Ljc4OTddLCBbNDYuNTA4LCA0Ljk2MDNdLCBbNDYuMzI0OCwgNS42NDQ0XSwgWzQ2LjE0OTYsIDUuOTY3Nl0sIFs0NS44NywgNS4zNzc1XSwgWzQ2LjA3MTIsIDQuNzYwOF0sIFs0Ni4xNTAxLCA0LjgwMTldLCBbNDYuMjIyLCA1Ljk5MDZdLCBbNDYuMjgxOCwgNS44OTA1XSwgWzQ2LjQxMTMsIDYuMDUyNV0sIFs0Ni4zOTg0LCA2LjExMzVdLCBbNDYuMzQyNSwgNi4xNDg4XSwgWzQ2LjMxMDIsIDYuMTE5NV0sIFs0Ni4zMDU3LCA2LjExOTddLCBbNDYuMjM2OCwgNi4wMzExXSwgWzQ2LjIzMDEsIDYuMDEyOV0sIFs0Ni4xMDQxLCA1Ljg4NzZdLCBbNDUuNjE3NCwgNS42MzY0XSwgWzQ1Ljc3MTEsIDUuMjEwN10sIFs0Ni4wMTM1LCA1LjgwNjJdLCBbNDUuODE0LCA0LjkxOV0sIFs0NS44ODc0LCA0Ljg4MjRdLCBbNDUuOTEyMSwgNC44NTAxXSwgWzQ1LjcxMDksIDUuNzA0MV0sIFs0NS42Njk4LCA1LjY5MDRdLCBbNDUuNjc0LCA1LjU1MTddLCBbNDUuNzgyNSwgNS40NTQzXSwgWzQ1Ljc4OTcsIDUuNDQ0MV0sIFs0NS44MDc3LCA1LjQyMjJdLCBbNDUuODc0LCA1LjMzNTVdLCBbNDYuMzI5MiwgNS40MDM5XSwgWzQ2LjUwNzcsIDUuMTk4XSwgWzQ2LjQ0ODYsIDUuMjk1Nl0sIFs0Ni40OTIsIDUuMDMzNF0sIFs0Ni40OTE4LCA1LjAzNjZdLCBbNDYuMzcwMywgNS4zNjI4XSwgWzQ2LjI2NzQsIDUuNDgzM10sIFs0Ni4zMTY4LCA1LjYwODFdLCBbNDYuMzM5MSwgNS42NDkyXSwgWzQ2LjMxNTMsIDUuOTQ2OV0sIFs0Ni4wOTg0LCA1Ljg5M10sIFs0Ni4xMDIzLCA1LjgzOTVdLCBbNDYuMDYsIDUuODA4OF0sIFs0Ni4xNjM2LCA0Ljc5MTddLCBbNDYuMTA0NiwgNS44MzQyXSwgWzQ2LjI2NzUsIDUuNzYzM10sIFs0Ni4xNzksIDUuOTkxNF0sIFs0Ni4zMzgyLCA1LjY0OTFdLCBbNDYuMzkxNiwgNi4wMzYxXSwgWzQ2LjM5ODcsIDYuMDQyM10sIFs0Ni40MDAyLCA2LjA0MzhdLCBbNDYuNDA4OCwgNi4wNTE1XSwgWzQ2LjM3NjIsIDYuMTYxMV0sIFs0Ni4zNDk3LCA2LjE1NjhdLCBbNDYuMzE5OCwgNi4xMjZdLCBbNDYuMjM4LCA2LjAzMzFdLCBbNDYuMTE3NSwgNS44OTE3XSwgWzQ2LjEyMDIsIDUuOV0sIFs0Ni4wNDY3LCA1LjgwODVdLCBbNDUuNzUxMiwgNS43ODM4XSwgWzQ1LjY4NjUsIDUuNTYxNF0sIFs0NS43NDA5LCA1LjUwMTldLCBbNDUuNzg2MiwgNS40NDcxXSwgWzQ2LjQ5ODksIDUuMjAzMl0sIFs0Ni40NDU5LCA1LjMwNTFdLCBbNDYuNTAwOCwgNS4yMDE3XSwgWzQ2LjQ3MzUsIDUuMjE1NF0sIFs0Ni4zNDEzLCA1LjM5MDddLCBbNDYuNDkwMSwgNS4wNDI5XSwgWzQ2LjQ3NjQsIDUuMjEyNF0sIFs0Ni4zOTMxLCA1LjM1MjZdLCBbNDYuMzEzMSwgNS40MDQ0XSwgWzQ2LjQ0OTcsIDUuMjkwMV0sIFs0Ni4yOTk0LCA0LjgzMjldLCBbNDYuNTAwMywgNC45Mjc1XSwgWzQ1Ljc2MjEsIDUuNDc1NF0sIFs0Ni4wNzg1LCA0Ljc1NjddLCBbNDUuOTAyNSwgNC44MjA4XSwgWzQ2LjI2NzQsIDUuNDg1OF0sIFs0Ni4wMjc3LCA1LjgxMl0sIFs0Ni4zMzU4LCA2LjEzNzJdLCBbNDYuMzI4MiwgNi4xMzU1XSwgWzQ2LjI0MTksIDYuMDY4NV0sIFs0NS43OTEyLCA1LjQ0MjldLCBbNDUuNzc5LCA1LjI0MzRdLCBbNDUuODQ1OSwgNC45MTUxXSwgWzQ1Ljg2ODEsIDQuOTA3NF0sIFs0NS45MDYxLCA0Ljg1ODhdLCBbNDYuMjk3OCwgNS43MTg3XSwgWzQ1LjkxOTcsIDUuODI4NF0sIFs0Ni4zNTAzLCA1Ljk3NTFdLCBbNDUuNzQyOCwgNS43Nzk4XSwgWzQ1LjcxMDQsIDUuNzM3Ml0sIFs0Ni4yOTM1LCA2LjExMjNdLCBbNDYuMDg4NywgNS44MjA1XSwgWzQ1LjcwODksIDUuNzE0M10sIFs0Ni40MzA5LCA1LjMxOTVdLCBbNDYuMzgyMywgNS4zNzU4XSwgWzQ2LjMzMzMsIDUuNDAxN10sIFs0Ni40Njg0LCA1LjIyMDRdLCBbNDYuMzM5MiwgNS40MTcxXSwgWzQ2LjUwOTMsIDUuMTgzOF0sIFs0Ni40NjAyLCA1LjIzOTldLCBbNDYuNDIwMSwgNS4zMDg4XSwgWzQ2LjI3MDQsIDUuNDY4OV0sIFs0Ni4yODI5LCA1LjcxNTddLCBbNDYuNTE3OCwgNC45NDAyXSwgWzQ2LjUxMTQsIDQuOTQ0OV0sIFs0Ni4wMDM3LCA1LjgwOTZdLCBbNDYuMzg1NywgNi4xMzldLCBbNDYuMzc4LCA2LjE1NDRdLCBbNDYuMzMxOSwgNi4xMzYyXSwgWzQ2LjI0MjksIDYuMDkzNF0sIFs0Ni4yNDYxLCA2LjA4NTldLCBbNDYuMjMzOSwgNi4wMjYyXSwgWzQ1LjgwNDEsIDUuNDI2OV0sIFs0NS44ODMxLCA0Ljg4MzNdLCBbNDYuMjIyNSwgNS45OTYxXSwgWzQ1LjkwMTMsIDQuODE2M10sIFs0NS44MDg4LCA1LjEzMjddLCBbNDUuODk3OSwgNC44MDQzXSwgWzQ1Ljk4MDIsIDQuNzUyMV0sIFs0NS43NjY3LCA1Ljc4MThdLCBbNDUuNzE2NywgNS43NjE3XSwgWzQ1LjcwOTksIDUuNzI5OF0sIFs0NS42MzcxLCA1LjY1MzZdLCBbNDUuNjkwNSwgNS41NDU1XSwgWzQ1LjY5MiwgNS41NjJdLCBbNDUuNzEzNiwgNS41NDU1XSwgWzQ2LjQ2NiwgNS4yMjgyXSwgWzQ2LjQ4ODMsIDUuMDQ2N10sIFs0Ni40ODU2LCA1LjA2MjFdLCBbNDYuNDkyOSwgNS4wODgyXSwgWzQ2LjQyOTgsIDUuMzIyNl0sIFs0Ni4zODg3LCA1LjM2NzFdLCBbNDYuMjcxMSwgNS40NjkyXSwgWzQ2LjI2ODIsIDUuNDk5Nl0sIFs0Ni4yNjc2LCA1Ljc2NDhdLCBbNDYuMjYyOSwgNS44MTgzXSwgWzQ2LjI1OTksIDQuODExXSwgWzQ2LjIzNywgNC44MDc4XSwgWzQ2LjI0MTksIDQuODA5M10sIFs0Ni4yMDkxLCA0Ljc5MjhdLCBbNDYuMzEwMywgNC44NDAxXSwgWzQ2LjMwODcsIDUuOTQxNF0sIFs0Ni4xMDksIDQuNzY5N10sIFs0Ni4xMTEyLCA0Ljc3MTJdLCBbNDYuMTU5MywgNC44MDAzXSwgWzQ2LjI3MjksIDUuNTQ1Nl0sIFs0Ni4zOTE0LCA2LjAzNTldLCBbNDYuMzc3NiwgNi4xNTY0XSwgWzQ2LjMzODQsIDYuMTM3OF0sIFs0Ni4zMTQ4LCA2LjEyMjhdLCBbNDYuMjc2MywgNi4xMDc0XSwgWzQ2LjI1NjQsIDYuMTIyNl0sIFs0Ni4yMjYyLCA2LjAwNjhdLCBbNDYuMjIyNSwgNi4wMDRdLCBbNDUuNzExOCwgNS41NDk1XSwgWzQ1LjgyMjMsIDQuOTIwNF0sIFs0NS43ODcyLCA1LjI2MTldLCBbNDUuODY5NiwgNC45MDgyXSwgWzQ1Ljg4MTUsIDQuODgzNl0sIFs0NS44MDAxLCA1LjEwNjFdLCBbNDUuOSwgNS44MjQ3XSwgWzQ1Ljc1MDIsIDUuNzgzNl0sIFs0NS43MDk3LCA1LjczNDZdLCBbNDUuNjEyNSwgNS42MzRdLCBbNDUuNzk4LCA1LjEwOTZdLCBbNDUuODQ4MSwgNS4zMDI1XSwgWzQ1LjgwNzksIDUuMDM0OV0sIFs0Ni4zNjUxLCA1LjM3NTFdLCBbNDYuNDQ2OSwgNS4zMDAyXSwgWzQ2LjQ0NjIsIDUuMzEyNF0sIFs0Ni40ODM5LCA1LjA1NjRdLCBbNDYuNDg2NiwgNS4wNzE4XSwgWzQ2LjUxNDEsIDUuMTcyMl0sIFs0Ni4yODk5LCA1LjU2MjZdLCBbNDYuMzM5OSwgNS42NDk1XSwgWzQ2LjMwOTYsIDUuNjkxOV0sIFs0Ni4zMTUsIDUuOTQ2Nl0sIFs0Ni40NDQsIDQuODkzNV0sIFs0Ni40NTYyLCA0LjkwOTFdLCBbNDYuNTEyNywgNC45NTQ1XSwgWzQ2LjA0NjIsIDUuODA4XSwgWzQ2LjEzOTQsIDQuNzk2MV0sIFs0Ni4zMDk4LCA1LjkzNzRdLCBbNDYuMzMsIDUuOTU3OV0sIFs0Ni4zMjY4LCA1Ljk1MzddLCBbNDYuMjY1NiwgNi4xMTg0XSwgWzQ2LjI0NTksIDYuMDgzM10sIFs0Ni4yNDExLCA2LjA2OThdLCBbNDUuODA3NywgNS4xMzJdLCBbNDYuNDE1MSwgNS4zMDYyXSwgWzQ1LjgxNzUsIDQuOTE5Ml0sIFs0NS45MTA0LCA0Ljg1Ml0sIFs0NS45NjI3LCA0Ljc0ODZdLCBbNDUuODA1NiwgNS4wMTY0XSwgWzQ1LjkyNjQsIDUuODIyMl0sIFs0NS44Njg1LCA1LjgxMTVdLCBbNDUuNjg1MiwgNS43MDk0XSwgWzQ1LjY0MjksIDUuNjAzOV0sIFs0NS43MDAzLCA1LjU1NTFdLCBbNDYuMTA2MiwgNS44Mjk1XSwgWzQ1Ljc4NiwgNS4yNTk3XSwgWzQ2LjUxMzQsIDUuMTcyN10sIFs0Ni40NDYzLCA1LjI4NTNdLCBbNDYuNDg2MywgNS4wNDkyXSwgWzQ2LjM0OCwgNS4zNzg0XSwgWzQ2LjI2NDIsIDUuNTE4OF0sIFs0Ni4yNjYxLCA1LjUyNDZdLCBbNDYuMjkyNywgNS41ODg4XSwgWzQ2LjMyNzIsIDUuNjEzMl0sIFs0Ni4yNjYzLCA1Ljc0MjddLCBbNDYuMjY5MiwgNS44Nzg0XSwgWzQ2LjUxMjQsIDQuOTkxOF0sIFs0Ni41MTQ1LCA0Ljk4NzFdLCBbNDYuMjAzLCA0Ljc5MzZdLCBbNDUuODA4MywgNC45OTUyXSwgWzQ1LjgwNzMsIDQuOTc1M10sIFs0NS44MDc0LCA0Ljk3MDddLCBbNDUuODA4LCA0Ljk2OTJdLCBbNDUuODA5NCwgNC45NjYyXSwgWzQ1LjgxMDYsIDQuOTY0Nl0sIFs0NS44MTEsIDQuOTYzMV0sIFs0NS44MDk1LCA0Ljk0NjNdLCBbNDUuODA5NCwgNC45NDMzXSwgWzQ1LjgwNzksIDQuOTM4NV0sIFs0Ni4zOTksIDYuMTEyOV0sIFs0Ni4zNzM3LCA2LjE2M10sIFs0Ni4zMzc5LCA2LjEzODhdLCBbNDYuMjQzNSwgNi4wNjU0XSwgWzQ2LjI2MDcsIDUuNzI1Ml0sIFs0Ni4yMjk1LCA2LjAxMzZdLCBbNDYuMDM3NywgNS44MDkzXSwgWzQ1LjkwNjcsIDQuODU3Ml0sIFs0NS44MDY1LCA1LjQyMzNdLCBbNDUuOTA0NSwgNC44MjM0XSwgWzQ1LjcxOTksIDUuNzY0NV0sIFs0NS42MzU5LCA1LjY1MTVdLCBbNDUuNzMxMywgNS41MTc1XSwgWzQ1LjgwMDYsIDUuNDMyMV0sIFs0NS44MTAzLCA1LjQyMTRdLCBbNDYuMzAwNSwgNS43MTgyXSwgWzQ2LjI2MywgNS44MTczXSwgWzQ2LjQ1NDUsIDUuMjU1Ml0sIFs0Ni4zMTE3LCA1LjQxMDhdLCBbNDYuNDk3NiwgNS4yMDM0XSwgWzQ2LjQ3ODYsIDUuMjExM10sIFs0Ni40NjE4LCA1LjIzMjNdLCBbNDYuNDU5NCwgNS4yMzRdLCBbNDYuNDQ5NiwgNS4yODldLCBbNDYuNTA5NiwgNS4wMTE2XSwgWzQ2LjUwMTYsIDUuMDEyOV0sIFs0Ni41MTUzLCA1LjE2N10sIFs0Ni4xOTA0LCA0Ljc4MTVdLCBbNDYuNTAzMywgNC45NTI1XSwgWzQ2LjI4ODEsIDQuODMwM10sIFs0Ni4xNjk5LCA0Ljc4MzJdLCBbNDYuMTAyLCA1Ljg5MDJdLCBbNDYuMzc1NiwgNi4wMTI0XSwgWzQ2LjM5NDMsIDYuMDM3XSwgWzQ2LjM1NiwgNi4xNTg4XSwgWzQ2LjI4OTQsIDYuMTA4NV0sIFs0Ni4zNTY3LCA1Ljk4MTRdLCBbNDYuMjU4LCA2LjEyMjRdLCBbNDYuMjMwOSwgNi4wMTU4XSwgWzQ2LjIyODYsIDYuMDEyNl0sIFs0Ni4zNTE0LCA1Ljk3NjhdLCBbNDUuODIyOCwgNC45Ml0sIFs0NS44NjA1LCA1LjgwNzRdLCBbNDUuNjcwNiwgNS41NjgzXSwgWzQ1LjY3MjQsIDUuNTUyOV0sIFs0NS42ODAxLCA1LjU1MjldLCBbNDUuNjk1MSwgNS41NTkxXSwgWzQ1Ljg4MDYsIDUuMzQxMl0sIFs0NS43ODk4LCA1LjE4MTFdLCBbNDYuMzI4MiwgNS40MTQzXSwgWzQ2LjMxNzEsIDUuNDU3MV0sIFs0Ni40NjAxLCA1LjI0NV0sIFs0Ni4zMTU0LCA1LjQ3NTNdLCBbNDYuMjcwOSwgNS40NjU5XSwgWzQ2LjI2NzEsIDUuNDg0M10sIFs0Ni4zMzQyLCA1LjY0OThdLCBbNDYuMzI0MiwgNS42NjczXSwgWzQ2LjI2NTMsIDUuODcwMl0sIFs0Ni4yODI5LCA1Ljg5MTRdLCBbNDYuMzEyMSwgNC44NDEzXSwgWzQ2LjQ1NSwgNC45MDcyXSwgWzQ2LjUxMzgsIDQuOTQxOV0sIFs0Ni4zNzE1LCA0Ljg2MTRdLCBbNDYuMzc1OCwgNC44NjU3XSwgWzQ2LjQ2MjQsIDQuOTE0NV0sIFs0Ni41MDA1LCA0LjkyNjldLCBbNDYuMjkwNCwgNC44MzA4XSwgWzQ2LjQxMTQsIDUuMzAzNl0sIFs0Ni4zMTUsIDUuNjgzM10sIFs0Ni4wODk5LCA1LjgyMTddLCBbNDYuMzQ3NiwgNi4xNTMzXSwgWzQ2LjMzMzEsIDYuMTM3OV0sIFs0Ni4yNjUyLCA2LjExOTddLCBbNDYuMjYzNiwgNi4xMTgyXSwgWzQ2LjMzOTYsIDUuOTY2XSwgWzQ2LjIzNiwgNi4wMjk4XSwgWzQ2LjIzMjEsIDYuMDIwNl0sIFs0Ni4xMzk0LCA1Ljk2NjNdLCBbNDYuMTI5NiwgNS45NTFdLCBbNDYuNDYwNSwgNS4yMzM0XSwgWzQ2LjM0NjQsIDUuMzc5Nl0sIFs0Ni4zMzk1LCA1LjM5OTNdLCBbNDYuNDE0OCwgNS4zMDc5XSwgWzQ2LjMxOTgsIDUuNDU3NF0sIFs0Ni4zNjk1LCA1LjM2NDNdLCBbNDYuNDk1MiwgNS4yMDQ0XSwgWzQ2LjQ2ODQsIDUuMjE1MV0sIFs0Ni4zOTc0LCA1LjM1MzVdLCBbNDYuMzQwNCwgNS4zOTQ4XSwgWzQ2LjM2NDksIDUuOTg3MV0sIFs0NS44NDgsIDUuNDE2M10sIFs0NS44NjksIDQuOTA4M10sIFs0Ni4yNjkzLCA1LjU0MDVdLCBbNDUuODMxMSwgNS43OTcyXSwgWzQ1Ljc1OTksIDUuNzc5XSwgWzQ1Ljc1MzMsIDUuNzgzNV0sIFs0NS43NDAzLCA1Ljc2OThdLCBbNDUuNzA5LCA1LjU1MzRdLCBbNDUuODA2LCA1LjEwNTJdLCBbNDYuNDk1NSwgNS4yMDQ0XSwgWzQ2LjM4NTQsIDUuMzcxOF0sIFs0Ni4zMTU1LCA1LjQwNDFdLCBbNDYuMzMyOSwgNS40MzEzXSwgWzQ2LjMzNzIsIDUuNDI3XSwgWzQ2LjM1MjIsIDUuMzczNV0sIFs0Ni40NDgxLCA1LjI5NzFdLCBbNDYuNDQ3LCA1LjI4NjRdLCBbNDYuNDE1OCwgNS4yOTg2XSwgWzQ2LjQwNDIsIDUuMzIxNV0sIFs0Ni41MTMsIDQuOTQyNF0sIFs0Ni4zNjA3LCA0Ljg1NDJdLCBbNDYuNTA2NiwgNC45NTkxXSwgWzQ2LjE5MjQsIDUuOTc3OV0sIFs0Ni4zMDg3LCA1LjkxNzVdLCBbNDYuMjYyOCwgNS44NDMzXSwgWzQ2LjQxODIsIDUuMzA3Ml0sIFs0Ni4xMzg2LCA1Ljk2NjZdLCBbNDYuMzgzMywgNi4wMjQxXSwgWzQ2LjI2NjYsIDUuNzU4Nl1dOwogICAgICAgICAgICAgICAgdmFyIGNsdXN0ZXIgPSBMLm1hcmtlckNsdXN0ZXJHcm91cCh7fSk7CgogICAgICAgICAgICAgICAgZm9yICh2YXIgaSA9IDA7IGkgPCBkYXRhLmxlbmd0aDsgaSsrKSB7CiAgICAgICAgICAgICAgICAgICAgdmFyIHJvdyA9IGRhdGFbaV07CiAgICAgICAgICAgICAgICAgICAgdmFyIG1hcmtlciA9IGNhbGxiYWNrKHJvdyk7CiAgICAgICAgICAgICAgICAgICAgbWFya2VyLmFkZFRvKGNsdXN0ZXIpOwogICAgICAgICAgICAgICAgfQoKICAgICAgICAgICAgICAgIGNsdXN0ZXIuYWRkVG8obWFwX2VjODUxNGFiYjAyZjQ0ODE5ZDRkZWJmNTgwZGU2ZGQ1KTsKICAgICAgICAgICAgICAgIHJldHVybiBjbHVzdGVyOwogICAgICAgICAgICB9KSgpOwogICAgICAgICAgICAKPC9zY3JpcHQ+ onload=\"this.contentDocument.open();this.contentDocument.write(atob(this.getAttribute('data-html')));this.contentDocument.close();\" allowfullscreen webkitallowfullscreen mozallowfullscreen></iframe></div></div>"
            ],
            "text/plain": [
              "<folium.folium.Map at 0x7fce89c3e198>"
            ]
          },
          "metadata": {
            "tags": []
          },
          "execution_count": 97
        }
      ]
    }
  ]
}
