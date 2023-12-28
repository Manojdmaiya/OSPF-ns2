# Create a new simulation instance
set ns [new Simulator]

# Enable NAM tracing
set nf [open out.nam w]
$ns namtrace-all $nf

# Create nodes
set node0 [$ns node]
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]

# Create links between nodes
$ns duplex-link $node0 $node1 1Mb 10ms DropTail
$ns duplex-link $node0 $node2 1Mb 10ms DropTail
$ns duplex-link $node1 $node3 1Mb 10ms DropTail
$ns duplex-link $node2 $node3 1Mb 10ms DropTail

# Create a TCP agent
set tcp [new Agent/TCP]
$ns attach-agent $node0 $tcp

# Create a UDP agent
set udp [new Agent/UDP]
$ns attach-agent $node3 $udp

# Create OSPF routing agent
set ospf0 [new OSPF]
$ospf0 set router-id 1
$node0 attach $ospf0

set ospf1 [new OSPF]
$ospf1 set router-id 2
$node1 attach $ospf1

set ospf2 [new OSPF]
$ospf2 set router-id 3
$node2 attach $ospf2

set ospf3 [new OSPF]
$ospf3 set router-id 4
$node3 attach $ospf3

# Set OSPF neighbors
$ospf0 add-nexthop $node1 $node0 $node1
$ospf0 add-nexthop $node2 $node0 $node2

$ospf1 add-nexthop $node0 $node1 $node0
$ospf1 add-nexthop $node3 $node1 $node3

$ospf2 add-nexthop $node0 $node2 $node0
$ospf2 add-nexthop $node3 $node2 $node3

$ospf3 add-nexthop $node1 $node3 $node1
$ospf3 add-nexthop $node2 $node3 $node2

# Schedule events
$ns at 0.1 "$tcp start"
$ns at 1.0 "$udp start"

# Define simulation duration
$ns at 5.0 "$ns halt"

# Run the simulation
$ns run
