# gp_fifo
The standard GPStudio single clock FIFO component used in flow buffering applications.  gp_fifo instantiates the optimal FIFO component depending on the targeted device. For now, only Altera device families are supported as gp_fifo encapsulates an Altera scfifo.

## Prototype

```
entity gp_fifo is
generic (
		DATA_WIDTH	: positive;
		FIFO_DEPTH	: positive
	)
	port (
		clk			: in std_logic;
		reset_n		: in std_logic;

		-- writer
		data_wr		: in std_logic;
		data_in		: in std_logic_vector(DATA_WIDTH-1 downto 0);
		full		   : out std_logic;

		-- reader
		data_rd		: in std_logic;
		data_out	   : out std_logic_vector(DATA_WIDTH-1 downto 0);
		empty		  : out std_logic
	);
end gp_fifo;
```

### Inputs outputs ports

Port 			| Type 		| Required | Description
-----			|------		|----------|------------
clk 			| Input		| Yes 		 | Positive-edge-triggered clock
reset_n 	| Input 	| Yes 		 | Asynchronous reset and clear with negative logic (Reset occurs when resent_n = 0)
data_wr		| Input 	| Yes 		 | Signal to be asserted to request for a write operation on the FIFO (Push request)
data_in		| Input 	| Yes 		 | Input data to be written in the FIFO. This port width should be equal to the DATA_WIDTH parameter.
full			| Output 	| No 		 	 | Indicated when FIFO is full (maximum FIFO_DEPTH reached).
data_rd		| Input 	| Yes 		 | Signal to be asserted to request for a read operation from the FIFO (Pull request)
data_out	| Output	| Yes 		 | Shows the data read from the pull request operation. This port width should be equal to the DATA_WIDTH parameter.
empty			| Output	| No 		   | Indicated when FIFO is empty (maximum FIFO_DEPTH reached).

### Parameters

Parameter 	| Type 		| Required 	| Description
-----				|------		|----------	|------------
DATA_WIDTH	| Integer | Yes 			| Specifies the width of the data_in and data_out ports of gp_fifo
FIFO_DEPTH	| Integer | Yes 			| Specifies the depths of the gp_fifo you require. The value must be at least 4

## Example

The following waveforms show the functional simulation of a gp_fifo with a depth of 4 and an 8 bits width. A Full testbench example can be found in the `support/component/gp_fifo/hdl/tb` directory

![gp_fifo_waveform]
(https://github.com/DreamIP/GPStudio/blob/master/support/component/gp_fifo/doc/wave.svg)
