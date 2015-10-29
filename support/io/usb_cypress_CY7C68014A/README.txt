
--- USB Driver informations
-----------------------------------

Flows:
=======================================================================
- 4 outputs flows (camera to pc comm)
- 2 inputs flow (pc to camera comm)

- Each output flow can support 8,16 or 32 bits dimension.
- Each input flow  can support 8 or 16 bits dimension.

By default, each flow is typed with 16 bits representation (equal to the physical USB comm). 
Overwrite usb params to change it (see example below).
If the flow size is different from 16 bits, a serializer is automatically inserted to optimize the USB bandwidth (so be careful if using 32 bits ... )

Params
=======================================================================
- Each output flow requires a temporary FIFO the depth can be adjusted by the INx_NBWORDS params (expressed in terms of words = 16 bits)

- Each input flow requires 2 FIFOs by component (swapping for reception during read data in other), FIFO depth can be adjust by the OUTx_NBWORDS

- Setting a flow NBWORDS to 0 will desactive the component (which will be removed during the fitting process), that could save many RAM blocks in the FPGA.
If you use only one flow, it is recommand to set others to 0.

- Each flow has a dynamic enable signal. This signal is synchronized with the associated fv signal.

- A global enable signal is also available.

- Example of overwritting params in node project

	<io name="usb" >
		<params>
			<param name="IN0_NBWORDS" value="32000" /> 
			<param name="IN1_NBWORDS" value="32000" /> 
			<param name="IN2_NBWORDS" value="1024" />  <!-- value="0" unable flow-->
			<param name="IN3_NBWORDS" value="1024" /> 
			<param name="OUT0_NBWORDS" value="1024"/>
			<param name="OUT1_NBWORDS" value="1024"/>
		</params>

		<flows>
			<flow name="in0"  type="in" size="8" />
			<flow name="in1"  type="in" size="8" />
			<flow name="in2"  type="in" size="16" />
			<flow name="in3"  type="in" size="16" />
			<flow name="out0" type="out" size="16"/>
			<flow name="out1" type="out" size="16"/> 
		</flows>
	</io>

Clocks
=======================================================================
USB driver could support clock cross domain but the system has been mainly tested with the same clock as USB comm (clk_proc = 48Mhz)
