TCP Reassembly Test Cases
=========================

These are test cases for TCP reassembly libraries.  Notable libraries and programs include libnids/pynids, gopacket, wireshark/tshark, zeek, and suricata.

- ACK before seq data packet (can happen when capture mechanism mis-orders captured packets)
- IPv4
- IPv6
- Out-of-order packets (e.g. SEQ# 12345 arrives before SEQ# 12321), which can happen when window size is greater than one and packets traverse different paths.
- Server drops all packets attempting to connect, then service becomes available.
    - continuous stream of SYN attempts where client IP, server IP, and server port do not change, but client port does.  Then when the service becomes available, one of the client port numbers is used again.  Some stream reassembly engines keep the state open for the SYN-without-reply for too long, causing subsequence flows with the same ip:port quad to be missed.
- ACKs with data
- Partial flows
    - missing three-way-handshake
    - missing three-way-handshake and first few packets of data
    - missing FIN-ACK-FIN
    - missing last few packets of data and FIN-ACK-FIN
    - missing 1+ ACKs in middle of flow
    - missing data packets in middle of flow
- TCP variants (Vegas, CUBIC)
