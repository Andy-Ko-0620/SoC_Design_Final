# SoC_Lab_Final_UART
In this project, we focus on reduce the interrupt frequency to CPU via adding UART Rx and Tx FIFOs.

### Simulation for uart
```sh
cd ./testbench/uart
chmod +x run_*
./run_clean
./run_sim
```

## Verification with Vivado
### Synthesis and Generate bitstream
```sh
cd ./vivado
chmod +x run_*
./run_vivado
```


