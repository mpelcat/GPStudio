

######################          Modification à apporter sur la carte GigaEthernet           ##########################
Pour utiliser l'ethernet sur la DreamCam, il est nécessaire de faire quelques modifications.

La clock de 125MHz provenant du marvell PHY est connecté au FPGA sur une sortie de PLL et il est donc impossible de récupérer le signal.
Il faut modifier cette connection afin que la clock GE_RXCLK arrive sur une entrée de PLL.

Pour cela, il faut souder un fil allant de la pin 67 (ENET_RX_CLK) du connecteur SAMTEC à la pin 3 (CLKIN_COMM_3).
Il reste ensuite à changer l'assignation de cette pin dans Quartus qui est maintenant AH14 (port GE_RXCLK).



######################                  Génération du bloc dans GPStudio                     ##########################
Il est nécessaire d'ajouter deux PLL dans le Clock Interconnect afin de multiplier la fréquence par deux des clocks GE_TXCLK et CLK_125_i.
Le mode utilisé dans le Marvell88e1111 est le mode RGMII (double data rate) dans lequel les données sont transmises sur 4 bits sur chaqure front montant
et descendant de l'horloge. On génère donc des clocks allant deux fois plus vite pour clocker les données sur chaque front montant de ces dernières.

La première PLL prend en entrée GE_RXCLK et sort clk250_marvell (250MHz).
La seconde PLL prend en entrée CLK_125 et sort clk250_fpga (250MHz).



######################                   Exemple d'un bloc com+ethernet                      ##########################
Un exemple de top contenant le bloc de com et l'ethernet est fournit dans le fichier "com_ethernet_example.vhd".
