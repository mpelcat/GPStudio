<?xml version="1.0" encoding="UTF-8"?>
<io driver="leds" categ="imagesensor" master_count="0" pi_size_addr_rel="2" desc="" configscriptfile="config.php">
  <parts>
    <part name="main">
      <svg width="160" height="110">
        <rect width="160" height="110" x="0" y="0" fill="lightgray"/>
        <text x="50" y="50">Led</text>
      </svg>
    </part>
  </parts>
  <files>
    <file name="leds.vhd" type="vhdl" group="hdl" path="hdl/leds.vhd"/>
    <file name="leds.io" type="io" group="blockdef" path="leds.io"/>
  </files>
  <resets>
    <reset name="reset_n" group="reset_n" direction="in"/>
  </resets>
  <params>
    <param name="LEDCOUNT" type="integer" hard="1" value="1"/>
    <param name="ENABLE" regaddr="0"/>
  </params>
  <ports>
    <port name="o" type="out" size="LEDCOUNT"/>
  </ports>
  <pins/>
</io>
