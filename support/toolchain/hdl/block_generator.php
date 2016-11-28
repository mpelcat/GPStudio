<?php
/*
 * Copyright (C) 2016 Dream IP
 *
 * This file is part of GPStudio.
 *
 * GPStudio is a free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

require_once("block.php");
require_once("vhdl_generator.php");

class Block_generator
{
    public $block;

    private $slave_block;

    private $process_block;

    public $slave_generator;

    public $block_generator;

    public $process_generator;

    function __construct($block = NULL)
    {
        $this->slave_block = NULL;
        $this->process_block = NULL;

        $this->block_generator = NULL;
        $this->slave_generator = NULL;
        $this->process_generator = NULL;

        if ($block != NULL)
            $this->fromBlock($block);
        else
            $block = NULL;
    }

    static function hex($value, $width)
    {
        return 'x"' . str_pad(strtoupper(dechex($value)), ceil($width / 4.0), '0', STR_PAD_LEFT) . '"';
    }

    static function bin($value, $width)
    {
        return '"' . str_pad(strtoupper(decbin($value)), $width, '0', STR_PAD_LEFT) . '"';
    }

    function fromBlock($block)
    {
        // top block creation
        $this->block = $block;

        if ($this->block == NULL)
            return;

        // slave block creation
        if ($this->block->pi_size_addr_rel > 0)
        {
            array_push($this->block->interfaces, new InterfaceBus("bus_sl", $this->block->name, "pi_slave", $this->block->pi_size_addr_rel));

            $this->slave_block = new IO();
            $this->slave_block->name = $this->block->name . '_slave';
            $this->slave_block->driver = $this->block->name . '_slave';
            $this->slave_block->clocks = array();
            $this->slave_block->interfaces = $this->block->interfaces;
        }

        // slave block creation
        $this->process_block = new IO();
        $this->process_block->name = $this->block->name . '_process';
        $this->process_block->driver = $this->block->name . '_process';
        $this->process_block->clocks = array();
        $this->process_block->flows = $this->block->flows;
        $this->process_block->params = $this->block->params;

        // clocks copy
        foreach ($this->block->clocks as $clock)
        {
            $nclock = new Clock();
            $nclock->name = $clock->name;
            $nclock->net = $clock->name;
            $this->process_block->addClock($nclock);
            if ($this->slave_block != NULL)
                $this->slave_block->addClock($nclock);
        }

        // resets copy
        foreach ($this->block->resets as $reset)
        {
            $nreset = new Clock();
            $nreset->name = $reset->name;
            $nreset->group = $reset->name;
            $this->process_block->addReset($nreset);
            if ($this->slave_block != NULL)
                $this->slave_block->addReset($nreset);
        }

        // registers
        if ($this->slave_block != NULL)
        {
            foreach ($this->block->params as $param)
            {
                if ($param->hard == false)
                {
                    if (empty($param->parambitfields))
                    {
                        $size = 32;

                        // port connexion
                        $port_param_in = new Port();
                        $port_param_in->name = $param->name;
                        $port_param_in->type = "in";
                        $port_param_in->size = $size;
                        $this->process_block->addExtPort($port_param_in);

                        $port_param_out = new Port();
                        $port_param_out->name = $param->name;
                        $port_param_out->type = "out";
                        $port_param_out->size = $size;
                        $this->slave_block->addExtPort($port_param_out);
                    }
                    else
                    {
                        foreach ($param->parambitfields as $parambitfields)
                        {
                            $size = count($parambitfields->bitfieldlist);

                            if ($size > 0)
                            {
                                // port connexion
                                $port_param_in = new Port();
                                $port_param_in->name = $param->name . '_' . $parambitfields->name;
                                $port_param_in->type = "in";
                                $port_param_in->size = $size;
                                $this->process_block->addExtPort($port_param_in);

                                $port_param_out = new Port();
                                $port_param_out->name = $param->name . '_' . $parambitfields->name;
                                $port_param_out->type = "out";
                                $port_param_out->size = $size;
                                $this->slave_block->addExtPort($port_param_out);
                            }
                        }
                    }
                }
            }
        }
    }

    public function generateTb($path)
    {
        if ($this->block == NULL)
            return;

        $this->block_generator = new VHDL_generator($this->block->name . '_tb');
        array_push($this->block_generator->libs, "use std.textio.all;");

        // clocks generation
        $codeClks = '';
        foreach ($this->block->clocks as $clock)
        {
            $clock->net = $clock->name;
            $period_name = $clock->name . "_period";

            $this->block_generator->addConstantComment(str_pad(' ' . $clock->name . ' clock constant ', 55, '-', STR_PAD_BOTH));
            $this->block_generator->addConstant($clock->name . "_FREQ", "INTEGER", "1000000");  // TODO give real freq
            $this->block_generator->addConstant($period_name, "TIME", "1 ns");                  // TODO give real freq
            $this->block_generator->addSignalComment(str_pad(' ' . $clock->name . ' clock signal ', 55, '-', STR_PAD_BOTH));
            $this->block_generator->addSignal($clock->name, 1, "std_logic");

            $codeClks.="	" . $clock->name . "_gen_process : process" . "\r\n";
            $codeClks.="	begin" . "\r\n";
            $codeClks.="		" . $clock->name . " <= '0';" . "\r\n";
            $codeClks.="		wait for " . $period_name . " / 2;" . "\r\n";
            $codeClks.="		" . $clock->name . " <= '1';" . "\r\n";
            $codeClks.="		wait for " . $period_name . " / 2;" . "\r\n";
            $codeClks.="	end process;" . "\r\n";
            $codeClks.="" . "\r\n";
        }
        $this->block_generator->addCode($codeClks);
        
        // flow signals
        foreach ($this->block->flows as $flow)
        {
            $this->block_generator->addConstantComment(str_pad(' ' . $flow->name . ' flow constant ', 55, '-', STR_PAD_BOTH));
            $this->block_generator->addConstant(strtoupper($flow->name) . "_SIZE", "INTEGER", $flow->size);
            $this->block_generator->addSignalComment(str_pad(' ' . $flow->name . ' flow signals ', 55, '-', STR_PAD_BOTH));
            $this->block_generator->addSignal($flow->name . "_dv", 1, "std_logic");
            $this->block_generator->addSignal($flow->name . "_fv", 1, "std_logic");
            $this->block_generator->addSignal($flow->name . "_data", strtoupper($flow->name) . "_SIZE", "std_logic_vector");
            
            if($flow->type == "out")
                $this->block_generator->declare .= "    file " . $flow->name . "_data_file : text is out \"" . $flow->name . ".pgm\";" . "\r\n";
            else
                $this->block_generator->declare .= "    file " . $flow->name . "_data_file : text is in \"" . $flow->name . ".img\";" . "\r\n";
        }
        
        // resets signals
        foreach ($this->block->resets as $reset)
        {
            $this->block_generator->addSignalComment(str_pad(' ' . $reset->name . ' reset signal ', 55, '-', STR_PAD_BOTH));
            $this->block_generator->addSignal($reset->name, 1, "std_logic");
        }
        
        // tb_specific
        $this->block_generator->addSignalComment(str_pad(' test bench specific ', 55, '-', STR_PAD_BOTH));
        $this->block_generator->addSignal("endtb", 1, "std_logic", "0");

        // block top level generation
        $this->block_generator->addblock($this->block, TRUE);
        $this->block_generator->save_as_ifdiff($path . DIRECTORY_SEPARATOR . $this->block_generator->name . '.vhd');
    }

    public function generateTopBlock($path)
    {
        if ($this->block == NULL)
            return;

        $this->block_generator = new VHDL_generator($this->block->name);

        // connexions between slave and process
        if ($this->slave_block != NULL)
        {
            foreach ($this->block->params as $param)
            {
                if ($param->hard == false)
                {
                    if (empty($param->parambitfields))
                    {
                        $this->block_generator->addSignal($param->name, 32, 'std_logic_vector');
                    }
                    else
                    {
                        foreach ($param->parambitfields as $parambitfields)
                        {
                            $size = count($parambitfields->bitfieldlist);

                            if ($size == 1)
                                $type = "std_logic";
                            else
                                $type = "std_logic_vector";
                            if ($size > 0)
                                $this->block_generator->addSignal($param->name . '_' . $parambitfields->name, $size, $type);
                        }
                    }
                }
            }
        }

        // block top level generation
        $this->block_generator->fromBlock($this->block);
        $this->block_generator->addblock($this->process_block, TRUE);
        if ($this->slave_block != NULL)
            $this->block_generator->addblock($this->slave_block, TRUE);
        $this->block_generator->save_as_ifdiff($path . DIRECTORY_SEPARATOR . $this->block_generator->name . '.vhd');
    }

    public function generateProcess($path)
    {
        if ($this->block == NULL)
            return;

        $this->process_generator = new VHDL_generator($this->block->name . '_process');

        $code = '';
        $code.="	data_process : process (clk_proc, reset_n)" . "\r\n";
        $code.="	begin" . "\r\n";
        $code.="		if(reset_n='0') then" . "\r\n";
        $code.="			out_data <= (others => '0');" . "\r\n";
        $code.="			out_dv <= '0';" . "\r\n";
        $code.="			out_fv <= '0';" . "\r\n";
        $code.="		elsif(rising_edge(clk_proc)) then" . "\r\n";
        $code.="			out_dv <= in_dv;" . "\r\n";
        $code.="			out_fv <= in_fv;" . "\r\n";
        $code.="\r\n";
        $code.="			if(in_dv='1' and in_fv='1') then" . "\r\n";
        $code.="				out_data <= in_data;" . "\r\n";
        $code.="			end if;" . "\r\n";
        $code.="		end if;" . "\r\n";
        $code.="	end process;";

        $this->process_generator->addCode($code);

        // process generation
        $this->process_generator->fromBlock($this->process_block, TRUE);
        $this->process_generator->save_as_ifdiff($path . DIRECTORY_SEPARATOR . $this->process_generator->name . '.vhd');
    }

    public function generateSlave($path)
    {
        if ($this->slave_block == NULL)
            return;

        $this->slave_generator = new VHDL_generator($this->block->name . '_slave');

        // registers
        usort($this->block->params, "Param::cmp_raddr");

        $this->slave_generator->addSignalComment(" Internal registers");
        $this->slave_generator->addConstantComment(" Registers address");

        $code_rst = "";
        foreach ($this->block->params as $param)
        {
            if ($param->hard == false)
            {
                if ($param->regaddr != '')
                    $regaddr = $param->regaddr;
                else
                    $regaddr = 0;
                $this->slave_generator->addConstant(strtoupper($param->name) . "_REG_ADDR", "natural", $regaddr);

                if (empty($param->parambitfields))
                {
                    $size = 32;

                    // slave internal
                    $this->slave_generator->addSignal($param->name . "_reg", $size, 'std_logic_vector');
                    $code_rst.="			" . $param->name . "_reg <= " . Block_generator::hex($param->value, $size) . ";" . "\r\n";
                }
                else
                {
                    foreach ($param->parambitfields as $parambitfield)
                    {
                        $size = count($parambitfield->bitfieldlist);

                        if ($size > 0)
                        {
                            if ($size == 1)
                                $type = "std_logic";
                            else
                                $type = "std_logic_vector";

                            // slave internal
                            $this->slave_generator->addSignal($param->name . "_" . $parambitfield->name . "_reg", $size, $type);
                            if ($size == 1)
                            {
                                $code_rst.="			" . $param->name . "_" . $parambitfield->name . "_reg <= '" . (int) $parambitfield->value . "';" . "\r\n";
                            }
                            else
                            {
                                $code_rst.="			" . $param->name . "_" . $parambitfield->name . "_reg <= " . Block_generator::bin($parambitfield->value, $size) . ";" . "\r\n";
                            }
                        }
                    }
                }
            }
        }

        $size_master = $this->block->pi_size_addr_rel;

        // write reg code
        $code_wr = "";
        $code_wr.="	write_reg : process (clk_proc, reset_n)" . "\r\n";
        $code_wr.="	begin" . "\r\n";
        $code_wr.="		if(reset_n='0') then" . "\r\n";
        $code_wr.=$code_rst;
        $code_wr.="		elsif(rising_edge(clk_proc)) then" . "\r\n";
        $code_wr.="			if(wr_i='1') then" . "\r\n";
        $code_wr.="				case addr_rel_i is" . "\r\n";
        foreach ($this->block->params as $param)
        {
            if ($param->hard == false)
            {
                $contant_reg_addr = strtoupper($param->name) . "_REG_ADDR";
                $code_wr.="					when std_logic_vector(to_unsigned(" . $contant_reg_addr . ", " . $size_master . "))=>" . "\r\n";

                if (empty($param->parambitfields))
                {
                    $size = 32;
                    $reg_name = $param->name . "_reg";
                    $code_wr.="						" . $reg_name . " <= datawr_i;" . "\r\n";
                }
                else
                {
                    foreach ($param->parambitfields as $parambitfield)
                    {
                        $size = count($parambitfield->bitfieldlist);

                        if ($size > 0)
                        {
                            $bf_name = $param->name . "_" . $parambitfield->name . "_reg";

                            $code_wr.="						" . $bf_name . " <= ";
                            $count = 0;
                            foreach ($parambitfield->bitfieldlist as $bit)
                            {
                                if ($count > 0)
                                    $code_wr.=" & ";
                                $code_wr.="datawr_i(" . $bit . ")";
                                $count++;
                            }
                            $code_wr.=";" . "\r\n";
                        }
                    }
                }
            }
        }

        $code_wr.="					when others=>" . "\r\n";
        $code_wr.="				end case;" . "\r\n";
        $code_wr.="			end if;" . "\r\n";
        $code_wr.="		end if;" . "\r\n";
        $code_wr.="	end process;" . "\r\n";
        $code_wr.="" . "\r\n";

        // read reg code
        $code_rd = "";
        $code_rd.="	read_reg : process (clk_proc, reset_n)" . "\r\n";
        $code_rd.="	begin" . "\r\n";
        $code_rd.="		if(reset_n='0') then" . "\r\n";
        $code_rd.="			datard_o <= (others => '0');" . "\r\n";
        $code_rd.="		elsif(rising_edge(clk_proc)) then" . "\r\n";
        $code_rd.="			if(rd_i='1') then" . "\r\n";
        $code_rd.="				case addr_rel_i is" . "\r\n";
        foreach ($this->block->params as $param)
        {
            if ($param->hard == false)
            {
                $contant_reg_addr = strtoupper($param->name) . "_REG_ADDR";
                $code_rd.="					when std_logic_vector(to_unsigned(" . $contant_reg_addr . ", " . $size_master . "))=>" . "\r\n";

                if (empty($param->parambitfields))
                {
                    $size = 32;

                    $reg_name = $param->name . "_reg";

                    $code_rd.="						datard_o <= " . $reg_name . ";" . "\r\n";
                }
                else
                {
                    $bits = array();
                    foreach ($param->parambitfields as $parambitfield)
                    {
                        $size = count($parambitfield->bitfieldlist);

                        $bf_name = $param->name . "_" . $parambitfield->name . "_reg";

                        if($size==1)
                        {
                            $bits[$parambitfield->bitfieldlist[0]] = $bf_name;
                        }
                        else
                        {
                            $count = $size;
                            foreach ($parambitfield->bitfieldlist as $bit)
                            {
                                $bits[$bit] = $bf_name . "(" . ($count - 1) . ")";
                                $count--;
                            }
                        }
                    }

                    $code_rd.="						datard_o <= ";
                    $prev = 32;
                    $count = 0;
                    ksort($bits);
                    $bits = array_reverse($bits, true);
                    foreach ($bits as $bitpos => $bitname)
                    {
                        if ($count > 0)
                            $code_rd.=" & ";
                        if ($bitpos < $prev - 1)
                            $code_rd.="\"" . str_repeat('0', $prev - $bitpos - 1) . "\" & ";
                        $code_rd.=$bitname;
                        $prev = $bitpos;
                        $count++;
                    }
                    $code_rd.=";" . "\r\n";
                }
            }
        }


        $code_rd.="					when others=>" . "\r\n";
        $code_rd.="						datard_o <= (others => '0');" . "\r\n";
        $code_rd.="				end case;" . "\r\n";
        $code_rd.="			end if;" . "\r\n";
        $code_rd.="		end if;" . "\r\n";
        $code_rd.="	end process;" . "\r\n";
        $code_rd.="" . "\r\n";

        // output connexions
        $code_connect = '';
        foreach ($this->block->params as $param)
        {
            if ($param->hard == false)
            {
                if (empty($param->parambitfields))
                {
                    $reg_name = $param->name . "_reg";
                    $code_connect.="	$param->name <= $reg_name;" . "\r\n";
                }
                else
                {
                    foreach ($param->parambitfields as $parambitfield)
                    {
                        $size = count($parambitfield->bitfieldlist);

                        if ($size > 0)
                        {
                            $bf_name = $param->name . "_" . $parambitfield->name;

                            $code_connect.="	" . $bf_name . " <= " . $bf_name . "_reg;" . "\r\n";
                        }
                    }
                }
            }
        }

        $this->slave_generator->addCode($code_wr);
        $this->slave_generator->addCode($code_rd);
        $this->slave_generator->addCode($code_connect);

        // slave generation
        $this->slave_generator->fromBlock($this->slave_block, TRUE);
        $this->slave_generator->save_as_ifdiff($path . DIRECTORY_SEPARATOR . $this->slave_generator->name . '.vhd');
    }
}
