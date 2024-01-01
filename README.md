# SoC_Design_Final
In this project, we seperate the workloads into two groups (computation and communication).


### Simulation for computation workload 
```sh
cd computation_workload/testbench/counter_la
chmod +x run_*
./run_clean
./run_sim
```

### Simulation for communication workload 
```sh
cd communication_workload/testbench/uart
chmod +x run_*
./run_clean
./run_sim
```

## Verification with Vivado
### Synthesis and Generate bitstream
```sh
cd communication_workload/vivado
chmod +x run_*
./run_vivado
```