# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Logic Library settings
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
lappend search_path /home/sun/Files/ModelsimProjects/SMIC18/db ../scripts ../../DesignComplier/outputs/
set_app_var target_library "slow.db"
set_app_var link_library "* slow.db SP018W_V1p5_max.db"
set_min_library slow.db -min_version fast.db
set_min_library SP018W_V1p5_max.db -min_version SP018W_V1p5_min.db


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Physical Library settings
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
set mw_path "/home/sun/Files/ModelsimProjects/SMIC18/mw_lib"
set tech_file "/home/sun/Files/ModelsimProjects/SMIC18/tech/smic18_5lm.tf"
set tlup_map "/home/sun/Files/ModelsimProjects/SMIC18/tlup/smic018_5lm_map"
set tlup_max "/home/sun/Files/ModelsimProjects/SMIC18/tlup/smiclog018_5lm_cell_max.tluplus"
set tlup_min "/home/sun/Files/ModelsimProjects/SMIC18/tlup/smiclog018_5lm_cell_min.tluplus"
set verilog_file "/home/sun/Files/ModelsimProjects/IDCTTop/DesignComplier/outputs/idct_chip_clk_with_driving.v"
set sdc_file "/home/sun/Files/ModelsimProjects/IDCTTop/DesignComplier/outputs/idct_chip_clk_with_driving.sdc"

source run_data_setup.tcl
source run_design_planning.tcl
source run_placement.tcl
source run_cts.tcl
source run_route.tcl
#source run_finishing.tcl