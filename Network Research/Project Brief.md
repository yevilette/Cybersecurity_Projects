# NETWORK RESEARCH PROJECT

## Network Remote Control
Scope 1 (Automated): Creating automation that would let cyber units run script from their local devices but would be executed by the remote server. Communicating with a remote server and executing automatic tasks anonymously.

### Project Structure for Scope 1:

1. Installations and Anonymity Check.\
  i) Install the needed applications.\
  ii) If the applications are already installed. If installed, don’t install them again.\
  iii) Check if the network connection is anonymous; if not, alert the user and exit.\
  iv) If the network connection is anonymous, display the spoofed country name.\
  v) Allow the user to specify the address/URL to whois from remote server; save into a variable

2. Automatically Scan the Remote Server for open ports.\
  i) Connect to the Remote Server via SSH\
  ii) Display the details of the remote server (country, IP, and Uptime)\
  iii) Get the remote server to check the Whois of the given address/URL\

3. Results\
  i) Save the Whois data into file on the remote computer\
  ii) Collect the file from the remote computer via FTP or HTTP or any other unsecure protocols.\
  iii) Create a log and audit your data collection.\
  iv) The log needs to be saved on the local machine.\

4. Creativity

## Network Remote Control
Scope 2 (Manual): To better understand network and security, you need to capture and monitor the traffic during the automated attack on the server. Analyse and explain at least 1 unsecure protocol used (telnet or http or ftp), how it impacts the CIA Triad and provide secure alternatives with demonstration.

### Project Structure for Scope 2:

1. Capture Network Traffic\
  i) Use tcpdump to capture the network on the Remote Server as you run the automated script\
  ii) Save the output into a pcap file\
  iii) Analyse the pcap file with Wireshark\

2. Research the selected protocol (Telnet or FTP or HTTP) thoroughly.\
  i) Understand its purpose, key features, and the problem it aims to solve. Gather resources such as RFCs     (Request for Comments), protocol specifications, and relevant literature.\
  ii) Describe the fundamental behaviour of the protocol. Explain how it works, the message exchange process, and  the sequence of events. Use diagrams and flowcharts to illustrate the protocol's behaviour.\
  iii) Dive deeper into the protocol's mechanisms. Explore aspects like header structure, message formats, and any flags or options that affect its behaviour.\
  iv) Discuss the strengths and weaknesses of the protocol and relating it impacting the CIA Triad.\

3. Secure Network Protocol\
  a) Suggest respective the secure protocol (SSH or SFTP or HTTPS), create a basic client-server application that uses the protocol to exchange data and demonstrate the protocol's behaviour.\
  b) Explain how the secure protocol will resolve the impact of CIA triad in part 2iv\

4. Conclusion\
  i) Conclude the project with a reflection on what you've learned. Discuss how the analysis deepened your understanding of networking protocols and their importance.

     

