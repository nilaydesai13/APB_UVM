# APB_UVM

--> This is a project where I have tried to implement APB protocol.                                                                                                        --> The purpose of this project was to understand UVM and how to build a UVM testbench from the scratch.                                                                   --> The design file consist a slave which will be communicating with the master (implemented TB) via APB protocol.                                                          --> In the TB, I have implemented the following:-                                                                                                                             - testbench                                                                                                                                                               - apb_pkg
    - apb_if
    - apb_master_trans
    - apb_seq
    - apb_sequencer
    - apb_master_driver
    - apb_monitor
    - apb_agent
    - apb_scoreboard
    - apb_env
    - apb_test
--> apb_test kickstarts a sequence (apb_seq) which is nothing but randomized values of pdata, paddr and and pwrite.
--> Driver drives the sequence, monitor samples the interface for scoreboard and scoreboard checks the result
