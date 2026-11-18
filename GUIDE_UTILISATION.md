# Guide d'utilisation

## Prérequis
MATLAB (testé sous MATLAB Online) avec Simulink et DSP System Toolbox. La Communications Toolbox n'est pas utilisée.

## Mise en route
1. Copier le dossier `programmes/` dans le répertoire de travail MATLAB et s'y placer (`cd`).
2. Lancer `Parametres` : charge `parametres.mat` dans l'espace de travail (nécessaire avant tout modèle `.slx`).

## Exécution par partie
| Partie | Script à lancer | Résultat |
|---|---|---|
| 2 – source, Huffman | `Partie2`, `Questiontroissix`, `Questionseptaneuf` | entropies, longueurs moyennes, figures |
| 3 – canaux | `test_cbs`, `test_unif`, `test_gauss`, `test_int` | TEB vs théorie (`chaine_cbs/unif/gauss/int.slx`) |
| 4 – Hamming | `test_hamming`, `test_codeur_sl`, `test_decodeur_sl`, `partie4_teb`, `test_retard`, `test_cod` | validations 16/16, courbes TEB avec/sans codage |
| 5 – QPSK | `test_qpsk`, `test_qpsk_cod` | constellations, TEB Gray/naturel, QPSK + Hamming |

Les modèles `chaine_cod.slx`, `chaine_qpsk.slx` et `chaine_qpsk_cod.slx` peuvent être régénérés par `construire_chaine_cod`, `construire_chaine_qpsk(mapping)` et `construire_chaine_qpsk_cod`.

## Rapport
`rapport/main.pdf`.

## Remarque
Les simulations longues (5·10^6 bits) peuvent prendre plusieurs minutes ; réduire `Nmax` dans les scripts de test pour un essai rapide.

## Présentation
Présentation vidéo : https://canva.link/th1knrc3f6iyvpg
