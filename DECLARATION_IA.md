# Déclaration sur l'usage de l'IA

TP « Théorie de l'information et du codage – Matlab/Simulink » – ENSIM 5A ASTRE – Nawel YONKOUA

J'ai utilisé l'assistant d'IA **Claude (Anthropic)** de façon ponctuelle pour ce TP, principalement sur la partie Simulink de la partie 4, que j'ai trouvée plus difficile et pour laquelle le temps était court.

## Mon travail
- Parties 1 et 2 : programmes `source.m`, `entropie.m`, `huffman_dec.m`, `comparer.m`, `Partie2.m`, `Questiontroissix.m`, `Questionseptaneuf.m`.
- Partie 3 : modèles Simulink des chaînes de transmission.
- Parties 4 et 5 : j'ai travaillé sur ces deux parties (codage de Hamming(7,4), courbes de TEB avec et sans codage, chaîne QPSK), qui étaient plus difficiles que les précédentes.
- Choix du texte et des paramètres, organisation du travail, décision de ce qui est traité (parties 2 à 5) ou non (6, 7, Lempel-Ziv).
- Exécution de tous les scripts et modèles dans MATLAB Online, tests, relevé des résultats, comparaison avec la théorie.
- Rédaction du rapport.

## Aide de l'IA
- Partie 4, partie Simulink : par manque de temps, le code générant les blocs Simulink (codeur et décodeur de Hamming en portes logiques, chaîne avec codage) a été généré par l'IA (`construire_codeur.m`, `construire_decodeur.m`, `construire_chaine_cod.m`).
- J'ai vérifié la cohérence de ce code : mêmes matrices G et H que mon codeur/décodeur Matlab, validation par les scripts de test (16/16 mots-codes identiques pour le codeur, correction de toutes les erreurs simples pour le décodeur) et comparaison des TEB simulés avec la théorie.
- Explications ponctuelles de la théorie et aide au débogage.
