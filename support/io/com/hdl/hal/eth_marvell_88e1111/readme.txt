
Pour utiliser l'ethernet sur la DreamCam, il est nécessaire de faire quelques modifications.

La clock de 125MHz provenant du marvell PHY est connecté au FPGA sur une sortie de PLL et il est donc impossible de récupérer le signal.
Il faut modifier cette connection afin que la clock GE_RXCLK arrive sur une entrée de PLL.

Pour cela, il faut souder un fil allant de la pin 67 (ENET_RX_CLK) du connecteur SAMTEC à la pin 3 (CLKIN_COMM_3).
Il reste ensuite à changer l'assignation de cette pin dans Quartus qui est maintenant AH14.
