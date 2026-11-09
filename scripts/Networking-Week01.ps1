
[CmdletBinding()]
param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# ============================================================
# NETFLEET | NETWORKING WEEK 01 BUILDER
# Five independent engineering lessons
# ============================================================

$Root = (Get-Location).Path

if (-not (Test-Path (Join-Path $Root "_quarto.yml"))) {
    throw "Run this script from C:\Netfleet-Docs"
}

$LessonDir = Join-Path $Root "learning\networking\week-01"
$BackupDir = Join-Path $Root "backups\networking-week-01"

New-Item -ItemType Directory -Path $LessonDir -Force | Out-Null

$Lessons = @{}

# ============================================================
# DAY 01: NETWORK FUNDAMENTALS
# ============================================================

$Lessons["day-01.qmd"] = @'
---
title: "Computer Network Fundamentals"
subtitle: "Networking | Week 01 | Day 01"
lang: en
toc: true
number-sections: true
format:
  html:
    code-copy: true
    code-overflow: wrap
---

::: {.persian}
# مبانی شبکه‌های کامپیوتری

**سطح:** Foundation

**زمان مطالعه:** ۳ تا ۴ ساعت

**هدف:** شناخت معماری شبکه، اجزای ارتباطی و مسیر انتقال داده.
:::

# 1. Learning Objectives

By the end of this lesson, you should be able to:

- Define a computer network.
- Identify network components.
- Compare PAN, LAN, MAN and WAN.
- Explain client-server architecture.
- Distinguish switching and routing.
- Understand the purpose of network protocols.
- Inspect a Windows network configuration.

# 2. What Is a Computer Network?

A computer network is a collection of interconnected devices that exchange information using communication protocols.

A network requires several elements:

| Component | Responsibility |
|---|---|
| Endpoints | Generate or consume information |
| NIC | Connects a device to a network |
| Media | Carries signals |
| Switches | Forward Layer 2 frames |
| Routers | Forward Layer 3 packets |
| Protocols | Define communication rules |
| Addressing | Identifies devices and destinations |

A network is not simply a collection of connected computers. It is a system of interfaces, addressing, forwarding decisions, protocols and operational policies.

## 2.1 Why Networks Exist

Networks enable:

- Resource sharing.
- Communication.
- Centralized authentication.
- Application delivery.
- Distributed computing.
- Remote administration.
- Monitoring and automation.

## 2.2 Enterprise Example

Consider an organization with 80 employees, two floors and five servers.

Its infrastructure may include:

- Access switches.
- Wireless access points.
- Routers.
- Firewalls.
- DNS and DHCP services.
- Application servers.
- Monitoring systems.

The engineering challenge is ensuring that every authorized device can communicate with the correct destination while unauthorized communication is controlled.

# 3. Network Types

## 3.1 PAN

Personal Area Network.

Examples include Bluetooth connections between a phone, laptop and headphones.

## 3.2 LAN

Local Area Network.

A LAN commonly connects devices within a home, office, laboratory or building.

Ethernet and Wi-Fi are common LAN technologies.

## 3.3 MAN

Metropolitan Area Network.

A MAN connects networks across a metropolitan region.

Examples include municipal and university campus infrastructure.

## 3.4 WAN

Wide Area Network.

A WAN connects geographically distant networks.

Enterprise WAN technologies may include leased lines, MPLS and VPN connections.

| Type | Scope | Example |
|---|---|---|
| PAN | Personal | Bluetooth |
| LAN | Local | Office |
| MAN | Metropolitan | City infrastructure |
| WAN | Wide area | International enterprise |

These classifications describe geographical scope, not necessarily performance or ownership.

# 4. Network Architectures

## 4.1 Client-Server

A client requests a service from a server.

Examples:

- Browser requesting a webpage.
- DNS client requesting name resolution.
- Python application requesting an API response.

```text
CLIENTS
   |
   v
NETWORK
   |
   v
SERVICES
   |
   +---- Web Server
   |
   +---- DNS Server
   |
   +---- API Server
```

## 4.2 Peer-to-Peer

In peer-to-peer systems, devices can provide and consume resources directly.

A device may act as both client and provider.

Peer-to-peer does not eliminate the need for network infrastructure.

# 5. Network Components

## 5.1 NIC

A Network Interface Card provides connectivity.

Common types:

- Ethernet.
- Wi-Fi.
- Virtual network adapter.

A NIC can expose MAC addresses and link-state information.

## 5.2 Switch

An Ethernet switch forwards frames using MAC address information.

Its main operations include:

1. Learning source MAC addresses.
2. Updating the MAC address table.
3. Forwarding known unicast frames.
4. Flooding eligible unknown unicast and broadcast traffic.
5. Applying VLAN membership rules.

Example:

```text
          SWITCH
       +-----------+
       |           |
       +--+-----+--+
          |     |
        PC-A   PC-B
```

A switch learns that a source MAC address is reachable through the port where the frame arrived.

If the destination is unknown, the switch can flood the frame within the relevant VLAN.

## 5.3 Router

A router forwards IP packets between networks.

Its routing decisions may consider:

- Destination prefix.
- Prefix length.
- Next hop.
- Outgoing interface.
- Route metric.

A router commonly uses longest prefix matching to select the most specific matching route.

## 5.4 Access Point

An access point connects wireless clients to a network.

Important concepts include:

- SSID.
- Channels.
- Authentication.
- Encryption.
- Signal strength.
- Roaming.

An access point is not necessarily a router.

## 5.5 Firewall

A firewall enforces traffic policies.

Depending on its capabilities, it may inspect addresses, ports, connection state and application information.

## 5.6 Modem and ONT

A modem adapts signals for an access technology.

Fiber deployments commonly use an Optical Network Terminal, or ONT.

The exact equipment depends on the service-provider architecture.

# 6. Network Topologies

## 6.1 Star

Endpoints connect to a central device.

Advantages:

- Easy expansion.
- Simple access-link troubleshooting.
- Failure isolation.

Disadvantages:

- Central-device dependency.
- Additional cabling.

## 6.2 Mesh

Devices have multiple possible interconnections.

Advantages:

- Redundant paths.
- Improved resilience.

Disadvantages:

- More configuration.
- Higher operational complexity.

## 6.3 Hierarchical Design

Traditional enterprise designs use:

- Access Layer.
- Distribution Layer.
- Core Layer.

Modern data centers may instead use spine-leaf architectures.

# 7. How Network Data Travels

A browser opening a website may involve:

1. DNS resolution.
2. Destination selection.
3. Transport communication.
4. Application request.
5. IP packet forwarding.
6. Server response.

The exact sequence depends on caching, DNS configuration, transport protocol and security settings.

## 7.1 Data Units

| Layer | Common Data Unit |
|---|---|
| Application | Data |
| Transport | Segment or Datagram |
| Network | Packet |
| Data Link | Frame |
| Physical | Bits |

## 7.2 Encapsulation

Each protocol layer adds control information required for communication.

```text
Application Data
       |
       v
TCP Header + Data
       |
       v
IP Header + TCP Segment
       |
       v
Ethernet Header + IP Packet + Trailer
       |
       v
Bits
```

The receiving device processes these headers in reverse order. This is decapsulation.

# 8. Protocols

A protocol defines rules for communication.

| Protocol | Purpose |
|---|---|
| Ethernet | Local link communication |
| IP | Addressing and packet forwarding |
| TCP | Reliable transport |
| UDP | Connectionless transport |
| DNS | Name resolution |
| DHCP | Dynamic configuration |
| HTTP | Web communication |
| TLS | Cryptographic security |

Important standards organizations include IEEE, IETF, ISO and ITU-T.

# 9. Practical Lab: Windows Network Inspection

## 9.1 Inspect Interfaces

```powershell
ipconfig /all
```

Identify:

- Adapter name.
- IPv4 address.
- Subnet mask.
- Default gateway.
- DNS servers.
- Physical address.

## 9.2 Inspect Routes

```powershell
route print
```

Observe destination prefixes, gateways, interfaces and metrics.

## 9.3 Inspect Adapters

```powershell
Get-NetAdapter
```

Check interface status and link information.

## 9.4 Inspect IP Configuration

```powershell
Get-NetIPConfiguration
```

Compare the output with `ipconfig /all`.

## 9.5 Inspect DNS

```powershell
Get-DnsClientServerAddress
```

Identify the DNS servers configured on each interface.

## 9.6 Inspect ARP

```powershell
arp -a
```

Inspect IPv4-to-MAC mappings currently present in the ARP cache.

## 9.7 Test Connectivity

```powershell
ping 8.8.8.8
```

A successful response indicates ICMP reachability at that moment.

A failed ping does not necessarily prove that a service is unavailable.

# 10. Troubleshooting Methodology

Follow a controlled process:

1. Identify the affected endpoint.
2. Check physical or wireless connectivity.
3. Inspect IP configuration.
4. Test local connectivity.
5. Check the default gateway.
6. Inspect routing.
7. Test DNS.
8. Test the destination service.
9. Compare with a working endpoint.

Avoid changing several settings simultaneously.

# 11. Network Automation Connection

Network automation converts repetitive operational work into controlled workflows.

Examples:

- Collecting interface status.
- Generating inventory.
- Detecting incorrect configurations.
- Monitoring errors.
- Comparing actual and desired state.

```text
NETWORK DEVICES
       |
       v
DATA COLLECTION
       |
       v
NORMALIZATION
       |
       v
VALIDATION
       |
       v
REPORTING
       |
       v
HUMAN REVIEW
```

Automation should improve consistency, observability and auditability.

# 12. Knowledge Check

1. What makes a collection of devices a network?
2. What is the difference between LAN and WAN?
3. How does a switch learn MAC addresses?
4. What information does a router use?
5. What is a default gateway?
6. What is encapsulation?
7. What is the purpose of DNS?
8. Why might ping fail while a web service remains available?
9. What does the ARP cache contain?
10. Give three examples of network automation.

# 13. Practical Assignment

Create a network inventory for your Windows computer.

Run:

```powershell
hostname
Get-NetAdapter
Get-NetIPConfiguration
Get-DnsClientServerAddress
route print
```

Record:

- Hostname.
- Active adapter.
- MAC address.
- IPv4 address.
- Prefix or subnet mask.
- Gateway.
- DNS servers.

Explain how your computer reaches a remote IP address.

# 14. Completion Criteria

- [ ] Explain network fundamentals.
- [ ] Identify major network components.
- [ ] Distinguish routing and switching.
- [ ] Understand encapsulation.
- [ ] Inspect Windows network configuration.
- [ ] Interpret basic troubleshooting results.
- [ ] Explain the role of automation.

# 15. References

- [RFC 1122](https://www.rfc-editor.org/rfc/rfc1122)
- [RFC 791](https://www.rfc-editor.org/rfc/rfc791)
- [RFC 9293](https://www.rfc-editor.org/rfc/rfc9293)
- [IEEE Standards](https://standards.ieee.org/)
- [IETF RFC Editor](https://www.rfc-editor.org/)
- [Microsoft ipconfig](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/ipconfig)
- [Microsoft Get-NetIPConfiguration](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-netipconfiguration)

::: {.persian}
**پایان جلسه اول**

در جلسه بعدی مدل‌های OSI و TCP/IP را به‌صورت عمیق بررسی می‌کنیم.
:::
'@

# ============================================================
# DAY 02: OSI AND TCP/IP
# ============================================================

$Lessons["day-02.qmd"] = @'
---
title: "OSI and TCP/IP Models"
subtitle: "Networking | Week 01 | Day 02"
lang: en
toc: true
number-sections: true
format:
  html:
    code-copy: true
    code-overflow: wrap
---

::: {.persian}
# مدل‌های OSI و TCP/IP

**هدف:** درک معماری لایه‌ای، Encapsulation و ارتباط پروتکل‌ها.
:::

# 1. Learning Objectives

- Explain why layered networking exists.
- Identify the seven OSI layers.
- Compare OSI and TCP/IP.
- Understand encapsulation and decapsulation.
- Map common protocols to their layers.
- Troubleshoot using a layered methodology.

# 2. Why Layered Models Exist

Networking contains many independent responsibilities.

A single application should not need to implement electrical signaling, Ethernet framing, routing and transport reliability.

Layering separates these responsibilities.

Benefits include:

- Modularity.
- Interoperability.
- Easier troubleshooting.
- Independent protocol development.
- Vendor interoperability.

A layered model is a conceptual framework. Real protocol implementations do not always fit perfectly into textbook boundaries.

# 3. OSI Model

The Open Systems Interconnection model defines seven conceptual layers.

| Layer | Name | Main Responsibility |
|---|---|---|
| 7 | Application | Network services for applications |
| 6 | Presentation | Data representation and transformation |
| 5 | Session | Dialog and session coordination |
| 4 | Transport | End-to-end transport |
| 3 | Network | Logical addressing and routing |
| 2 | Data Link | Local frame delivery |
| 1 | Physical | Signal transmission |

# 4. Layer 1: Physical

The Physical layer concerns the transmission of bits over a medium.

Examples:

- Copper Ethernet.
- Fiber optics.
- Radio frequencies.
- Connectors.
- Electrical and optical signaling.

Engineering considerations:

- Cable category.
- Distance.
- Signal attenuation.
- Interference.
- Link speed.
- Duplex settings.

A physical-layer problem may cause link failure, errors or unstable connectivity.

# 5. Layer 2: Data Link

The Data Link layer provides communication over a local link.

Ethernet is a major Layer 2 technology.

An Ethernet frame contains:

- Destination MAC address.
- Source MAC address.
- EtherType or length field.
- Payload.
- Frame Check Sequence.

Switches commonly operate at this layer.

Important concepts:

- MAC addressing.
- VLANs.
- Ethernet framing.
- Broadcast domains.
- Switching.
- Spanning Tree Protocol.

# 6. Layer 3: Network

Layer 3 provides logical addressing and packet forwarding.

IP is the principal Internet-layer protocol.

Important concepts:

- IPv4 and IPv6.
- Subnets.
- Routing tables.
- Next hops.
- Prefixes.
- ICMP.
- TTL or Hop Limit.

Routers use destination information to select forwarding paths.

# 7. Layer 4: Transport

The transport layer supports communication between application endpoints.

## 7.1 TCP

TCP provides:

- Connection establishment.
- Ordered byte-stream delivery.
- Retransmission.
- Flow control.
- Congestion control.

## 7.2 UDP

UDP provides:

- Datagram transport.
- Minimal transport overhead.
- No built-in retransmission.
- No built-in ordering guarantee.

Applications choose transport behavior according to their requirements.

# 8. Layers 5, 6 and 7

## 8.1 Session

The OSI Session layer describes dialog management and session coordination.

In practical TCP/IP implementations, these responsibilities are often handled by application protocols or libraries.

## 8.2 Presentation

The Presentation layer describes data representation.

Examples of related concerns:

- Encoding.
- Serialization.
- Compression.
- Encryption.

TLS is commonly associated with secure application communication, although it does not map perfectly to one OSI layer.

## 8.3 Application

The Application layer provides network services to applications.

Examples:

- HTTP.
- DNS.
- DHCP.
- SMTP.
- SSH.

These are application protocols, not the same thing as user applications.

# 9. TCP/IP Model

A common four-layer representation is:

| TCP/IP Layer | Typical Responsibilities |
|---|---|
| Application | Application protocols and data representation |
| Transport | TCP and UDP |
| Internet | IP and routing |
| Link | Local network communication |

Some references use a five-layer teaching model by separating Physical from Link.

# 10. OSI vs TCP/IP

| OSI | TCP/IP |
|---|---|
| Application | Application |
| Presentation | Application |
| Session | Application |
| Transport | Transport |
| Network | Internet |
| Data Link | Link |
| Physical | Link / Physical |

OSI is a conceptual reference model. TCP/IP describes the protocol architecture used by the Internet.

# 11. Encapsulation

Suppose an application sends data through TCP over IPv4 and Ethernet.

The process is conceptually:

```text
Application Data
       |
       v
TCP Segment
       |
       v
IPv4 Packet
       |
       v
Ethernet Frame
       |
       v
Physical Signals
```

Each layer adds information required by the corresponding protocol.

The receiving system performs decapsulation.

## 11.1 Why Headers Matter

A TCP header contains transport information such as ports and sequence numbers.

An IPv4 header contains logical addressing and forwarding-related fields.

An Ethernet header contains local-link addressing.

Each layer solves a different communication problem.

# 12. Addressing at Different Layers

| Layer | Identifier |
|---|---|
| Layer 2 | MAC address |
| Layer 3 | IP address |
| Layer 4 | TCP or UDP port |
| Application | Application-specific identifier |

A MAC address does not replace an IP address.

A port does not identify a physical computer by itself.

The identifiers work together.

# 13. Practical Lab: Observe the Layers

## 13.1 Inspect Local Interfaces

```powershell
Get-NetAdapter
```

This reveals interface names, status and link information.

## 13.2 Inspect IP Addresses

```powershell
Get-NetIPAddress
```

Identify address family, interface and prefix length.

## 13.3 Inspect Routes

```powershell
Get-NetRoute
```

Observe route destinations, next hops and metrics.

## 13.4 Inspect Listening Ports

```powershell
Get-NetTCPConnection -State Listen
```

This shows local TCP listeners.

## 13.5 Inspect DNS

```powershell
Resolve-DnsName example.com
```

This tests DNS resolution through the Windows resolver.

## 13.6 Trace a Destination

```powershell
tracert 1.1.1.1
```

This provides evidence about the Layer 3 path.

# 14. Troubleshooting by Layer

| Layer | Example Problem | Useful Evidence |
|---|---|---|
| Physical | Cable disconnected | Adapter status |
| Data Link | VLAN mismatch | Switch configuration |
| Network | Incorrect route | Routing table |
| Transport | Port unavailable | TCP connection test |
| Application | HTTP error | Application logs |

Troubleshooting should begin with evidence rather than assumptions.

A failed application request does not automatically mean the physical network is broken.

# 15. Practical Assignment

Choose one application on your computer that uses the network.

Document:

1. Which application is involved?
2. Which destination does it contact?
3. Which transport protocol is used?
4. Which local and remote ports are involved?
5. What route is selected?
6. Which local interface is used?

Useful commands:

```powershell
Get-NetTCPConnection
```

```powershell
Get-NetRoute
```

```powershell
Get-NetIPConfiguration
```

# 16. Knowledge Check

1. Why do network models use layers?
2. What is the main responsibility of Layer 2?
3. How does Layer 3 differ from Layer 2?
4. What does TCP provide that UDP does not?
5. Where does IP belong in the OSI model?
6. What information does a port identify?
7. What is encapsulation?
8. Why is OSI useful even though TCP/IP is widely deployed?
9. Why can a protocol be difficult to map to one OSI layer?
10. Describe a layer-by-layer troubleshooting strategy.

# 17. Completion Criteria

- [ ] Identify all seven OSI layers.
- [ ] Compare OSI and TCP/IP.
- [ ] Explain protocol data units.
- [ ] Explain encapsulation.
- [ ] Identify MAC, IP and port addressing.
- [ ] Use Windows commands to inspect network layers.
- [ ] Apply a layered troubleshooting approach.

# 18. References

- [RFC 1122](https://www.rfc-editor.org/rfc/rfc1122)
- [RFC 791](https://www.rfc-editor.org/rfc/rfc791)
- [RFC 9293](https://www.rfc-editor.org/rfc/rfc9293)
- [RFC 768: User Datagram Protocol](https://www.rfc-editor.org/rfc/rfc768)
- [IETF RFC Editor](https://www.rfc-editor.org/)
- [IEEE 802 Standards](https://standards.ieee.org/)

::: {.persian}
**پایان جلسه دوم**

در جلسه بعدی وارد دنیای Ethernet، آدرس‌های MAC و منطق سوئیچینگ می‌شویم.
:::
'@

# ============================================================
# DAY 03: ETHERNET AND SWITCHING
# ============================================================

$Lessons["day-03.qmd"] = @'
---
title: "Ethernet, MAC Addressing and Switching"
subtitle: "Networking | Week 01 | Day 03"
lang: en
toc: true
number-sections: true
format:
  html:
    code-copy: true
    code-overflow: wrap
---

::: {.persian}
# Ethernet، آدرس MAC و Switching

**هدف:** درک ساختار فریم Ethernet، یادگیری MAC و رفتار سوئیچ.
:::

# 1. Learning Objectives

- Explain Ethernet communication.
- Understand MAC address structure.
- Read basic Ethernet frame fields.
- Explain MAC address learning.
- Distinguish unicast, multicast and broadcast.
- Understand VLAN segmentation.
- Diagnose common Layer 2 problems.

# 2. Ethernet Overview

Ethernet is a family of technologies standardized primarily through IEEE 802.3.

It defines important aspects of wired local network communication.

Ethernet operates at the Data Link and Physical layers of common networking models.

# 3. MAC Addresses

A MAC address identifies a network interface at the local-link layer.

A common representation is:

```text
00:1A:2B:3C:4D:5E
```

A conventional 48-bit MAC address contains:

- 48 total bits.
- Six octets.
- Hexadecimal notation.

## 3.1 Unicast, Multicast and Broadcast

**Unicast**

A frame intended for one destination interface.

**Multicast**

A frame intended for a group of interfaces.

**Broadcast**

An Ethernet broadcast frame uses:

```text
FF:FF:FF:FF:FF:FF
```

Broadcast traffic is delivered within the relevant Layer 2 broadcast domain.

# 4. Ethernet Frame Structure

A simplified Ethernet II frame contains:

| Field | Purpose |
|---|---|
| Destination MAC | Receiving interface |
| Source MAC | Sending interface |
| EtherType | Identifies upper-layer protocol |
| Payload | Carried data |
| FCS | Frame error detection |

The preamble and Start Frame Delimiter are also transmitted on the medium but are not normally included in the standard frame-size calculation.

# 5. How a Switch Learns MAC Addresses

A Layer 2 switch builds a forwarding database by examining source MAC addresses.

Consider:

```text
PC-A -------- Port 1
                 |
              SWITCH
                 |
PC-B -------- Port 2
```

PC-A sends a frame.

The switch:

1. Receives the frame on Port 1.
2. Reads the source MAC address.
3. Associates that MAC with Port 1.
4. Looks up the destination MAC.
5. Forwards or floods according to its forwarding information and VLAN.

When PC-B responds, its source MAC can be learned on Port 2.

# 6. Unknown Unicast Flooding

If the destination MAC is not present in the forwarding database, a switch normally floods the frame to eligible ports in the same VLAN, excluding the ingress port.

This behavior allows communication to proceed before the destination has been learned.

Broadcast frames are also flooded within their VLAN.

# 7. MAC Address Table

A forwarding table may contain:

| VLAN | MAC Address | Port |
|---|---|---|
| 10 | 00:11:22:33:44:55 | Gi0/1 |
| 10 | 00:11:22:33:44:66 | Gi0/2 |
| 20 | 00:11:22:33:44:77 | Gi0/3 |

The same MAC may be represented differently in different VLAN contexts.

Entries can be dynamically learned and later age out.

# 8. VLANs

A Virtual LAN creates a logical Layer 2 broadcast domain.

VLANs help separate traffic.

Examples:

- VLAN 10: Employees.
- VLAN 20: Servers.
- VLAN 30: Guest wireless.
- VLAN 40: Management.

A VLAN is not a complete security boundary by itself. Inter-VLAN routing and security policies must be designed carefully.

## 8.1 Access Ports

An access port normally carries traffic for one assigned VLAN.

## 8.2 Trunk Ports

A trunk can carry multiple VLANs between compatible network devices.

IEEE 802.1Q defines VLAN tagging commonly used on Ethernet trunks.

# 9. Spanning Tree

Redundant Layer 2 links can create switching loops.

A Layer 2 loop can cause:

- Broadcast storms.
- Duplicate frames.
- MAC address instability.

Spanning Tree Protocol helps create a loop-free logical topology while preserving redundancy.

Modern deployments commonly use variants such as Rapid Spanning Tree Protocol.

# 10. Practical Lab: Inspect Windows MAC Information

## 10.1 List Adapters

```powershell
Get-NetAdapter
```

## 10.2 Show MAC Addresses

```powershell
Get-NetAdapter |
    Select-Object Name, Status, MacAddress, LinkSpeed
```

## 10.3 Inspect ARP

```powershell
arp -a
```

## 10.4 Clear Dynamic ARP Entries

This changes local cache state. Do not run it unless you understand the impact.

```powershell
arp -d *
```

Then generate local network traffic and inspect the cache again.

## 10.5 Inspect Neighbor Information

```powershell
Get-NetNeighbor
```

Look for:

- IP address.
- Link-layer address.
- Interface index.
- Neighbor state.

# 11. Troubleshooting Layer 2

Common problems include:

- Incorrect VLAN assignment.
- Disabled switch port.
- Physical cable failure.
- Duplex or speed mismatch.
- MAC address flapping.
- Switching loops.
- Incorrect trunk allowed VLAN list.

A Windows endpoint cannot directly reveal every switch-side issue. Switch management access and telemetry are often required.

# 12. Network Automation Connection

Switching information can be collected and analyzed automatically.

Example workflow:

```text
SWITCH INVENTORY
       |
       v
MAC TABLE COLLECTION
       |
       v
VLAN VALIDATION
       |
       v
ANOMALY DETECTION
       |
       v
REPORT GENERATION
```

Future automation tasks may collect:

- Interface status.
- MAC address tables.
- VLAN configuration.
- Error counters.
- Spanning Tree status.

# 13. Knowledge Check

1. What is a MAC address?
2. What is the size of a conventional MAC address?
3. What is the purpose of EtherType?
4. How does a switch learn a source MAC?
5. What happens when a destination MAC is unknown?
6. What is a VLAN?
7. Why are switching loops dangerous?
8. What problem does Spanning Tree address?
9. How does a trunk differ from an access port?
10. Which data could an automation system collect from switches?

# 14. Practical Assignment

Use Windows to collect:

```powershell
Get-NetAdapter |
    Select-Object Name, Status, MacAddress, LinkSpeed
```

```powershell
Get-NetNeighbor
```

```powershell
arp -a
```

Document:

- Your active interface.
- Its MAC address.
- At least one neighbor entry if available.
- The difference between an IP address and a MAC address.
- Why your endpoint's neighbor table is not the same as a switch MAC table.

# 15. Completion Criteria

- [ ] Understand Ethernet framing.
- [ ] Explain MAC learning.
- [ ] Distinguish unicast, multicast and broadcast.
- [ ] Understand VLANs.
- [ ] Explain Layer 2 loops.
- [ ] Inspect local neighbor information.
- [ ] Identify common switching problems.

# 16. References

- [IEEE 802.3 Ethernet](https://standards.ieee.org/standard/802_3-2022.html)
- [IEEE 802.1Q](https://standards.ieee.org/standard/802_1Q-2022.html)
- [RFC 826: ARP](https://www.rfc-editor.org/rfc/rfc826)
- [Microsoft Get-NetNeighbor](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-netneighbor)
- [IETF RFC Editor](https://www.rfc-editor.org/)

::: {.persian}
**پایان جلسه سوم**

در جلسه بعدی سراغ IPv4، Subnet Mask و محاسبات Subnetting می‌رویم.
:::
'@

# ============================================================
# DAY 04: IPV4 AND SUBNETTING
# ============================================================

$Lessons["day-04.qmd"] = @'
---
title: "IPv4 Addressing and Subnetting"
subtitle: "Networking | Week 01 | Day 04"
lang: en
toc: true
number-sections: true
format:
  html:
    code-copy: true
    code-overflow: wrap
---

::: {.persian}
# IPv4 Addressing و Subnetting

**هدف:** درک آدرس‌دهی IPv4، Prefix، Network ID و محاسبات Subnetting.
:::

# 1. Learning Objectives

- Explain IPv4 addressing.
- Understand binary representation.
- Distinguish network and host portions.
- Interpret prefix lengths.
- Calculate network and broadcast addresses.
- Identify usable host ranges.
- Understand private address ranges.
- Inspect Windows IP configuration.

# 2. IPv4 Fundamentals

IPv4 uses 32-bit addresses.

A common dotted-decimal representation is:

```text
192.168.10.25
```

An IPv4 address contains four octets.

Each octet represents eight bits and ranges from 0 to 255.

# 3. Binary Representation

An octet uses these bit weights:

| Bit | Value |
|---|---:|
| 1 | 128 |
| 2 | 64 |
| 3 | 32 |
| 4 | 16 |
| 5 | 8 |
| 6 | 4 |
| 7 | 2 |
| 8 | 1 |

For example:

```text
192 = 128 + 64
192 = 11000000
```

Another example:

```text
10 = 8 + 2
10 = 00001010
```

Binary understanding is essential for subnet calculations.

# 4. Network and Host Portions

An IPv4 prefix defines how many leading bits represent the network.

Example:

```text
192.168.10.25/24
```

A `/24` prefix means:

- 24 network bits.
- 8 host bits.

The subnet mask is:

```text
255.255.255.0
```

The network address is:

```text
192.168.10.0
```

The conventional broadcast address is:

```text
192.168.10.255
```

The conventional usable host range is:

```text
192.168.10.1 - 192.168.10.254
```

These host-range conventions apply to ordinary IPv4 subnets, with special handling for certain prefix lengths and network types.

# 5. CIDR Notation

Classless Inter-Domain Routing represents prefixes using slash notation.

Examples:

| Prefix | Subnet Mask |
|---|---|
| /8 | 255.0.0.0 |
| /16 | 255.255.0.0 |
| /24 | 255.255.255.0 |
| /25 | 255.255.255.128 |
| /26 | 255.255.255.192 |
| /27 | 255.255.255.224 |
| /28 | 255.255.255.240 |
| /30 | 255.255.255.252 |

# 6. Subnet Size

For conventional IPv4 subnets, the number of addresses is:

\[
2^{(32-prefix)}
\]

For most ordinary subnets, two addresses are reserved for network and broadcast purposes.

The traditional usable-host calculation is:

\[
2^{(32-prefix)} - 2
\]

Example:

A `/26` subnet has six host bits.

\[
2^6 = 64
\]

It contains 64 total addresses and conventionally 62 usable host addresses.

# 7. Subnetting Example

Given:

```text
192.168.10.64/26
```

The block size in the final octet is:

```text
256 - 192 = 64
```

The network range begins at `.64`.

Therefore:

| Item | Value |
|---|---|
| Network | 192.168.10.64 |
| First Host | 192.168.10.65 |
| Last Host | 192.168.10.126 |
| Broadcast | 192.168.10.127 |
| Total Addresses | 64 |
| Usable Hosts | 62 |

# 8. Private IPv4 Address Ranges

RFC 1918 defines three private IPv4 ranges:

| Range | Prefix |
|---|---|
| 10.0.0.0 - 10.255.255.255 | /8 |
| 172.16.0.0 - 172.31.255.255 | /12 |
| 192.168.0.0 - 192.168.255.255 | /16 |

Private addresses are not globally routed across the public Internet.

Organizations commonly use Network Address Translation at network boundaries.

# 9. Default Gateway

A host determines whether a destination is local or remote based on its IP configuration.

For a remote destination, it normally sends traffic to a configured router.

Example:

```text
Host:       192.168.10.25/24
Gateway:    192.168.10.1
Destination: 8.8.8.8
```

The destination is outside the local `/24`, so the host uses its routing table to select the gateway.

# 10. Practical Lab: Windows IP Configuration

## 10.1 Inspect Addresses

```powershell
Get-NetIPAddress -AddressFamily IPv4
```

## 10.2 Inspect Interfaces

```powershell
Get-NetIPConfiguration
```

## 10.3 Inspect Routes

```powershell
Get-NetRoute -AddressFamily IPv4
```

## 10.4 Inspect Subnet Information

```powershell
ipconfig /all
```

Compare the prefix length with the subnet mask.

# 11. Subnetting Practice

Calculate the following networks.

**Exercise A**

```text
192.168.1.0/25
```

Find:

- Network address.
- Broadcast address.
- First usable address.
- Last usable address.
- Total addresses.
- Usable hosts.

**Exercise B**

```text
10.20.30.64/27
```

Find the same six values.

**Exercise C**

```text
172.16.8.128/28
```

Find the same six values.

# 12. Network Automation Connection

IP address management is a major operational task.

Automation can:

- Detect duplicate IP assignments.
- Validate subnet membership.
- Identify unused address space.
- Generate IP inventory.
- Compare device addresses with intended configuration.
- Detect inconsistent gateway settings.

A future NetFleet IPAM module will use structured records rather than manually maintained spreadsheets.

# 13. Knowledge Check

1. How many bits are in IPv4?
2. What does `/24` mean?
3. How many addresses exist in a `/26`?
4. What is the broadcast address?
5. Why do hosts use a default gateway?
6. Which ranges are private under RFC 1918?
7. What is CIDR?
8. What is the difference between a network address and a host address?
9. Why is subnetting useful?
10. How could an automation system detect an IP conflict?

# 14. Completion Criteria

- [ ] Understand IPv4 binary representation.
- [ ] Interpret CIDR prefixes.
- [ ] Calculate subnet sizes.
- [ ] Identify network and broadcast addresses.
- [ ] Recognize private address ranges.
- [ ] Inspect Windows IP settings.
- [ ] Explain the default gateway.
- [ ] Solve subnetting exercises.

# 15. References

- [RFC 791: Internet Protocol](https://www.rfc-editor.org/rfc/rfc791)
- [RFC 1918: Private Address Allocation](https://www.rfc-editor.org/rfc/rfc1918)
- [RFC 4632: CIDR](https://www.rfc-editor.org/rfc/rfc4632)
- [Microsoft Get-NetIPAddress](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-netipaddress)
- [Microsoft Get-NetRoute](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-netroute)

::: {.persian}
**پایان جلسه چهارم**

در جلسه بعدی به TCP، UDP، پورت‌ها و روش‌های عیب‌یابی می‌پردازیم.
:::
'@

# ============================================================
# DAY 05: TCP, UDP AND TROUBLESHOOTING
# ============================================================

$Lessons["day-05.qmd"] = @'
---
title: "TCP, UDP and Network Troubleshooting"
subtitle: "Networking | Week 01 | Day 05"
lang: en
toc: true
number-sections: true
format:
  html:
    code-copy: true
    code-overflow: wrap
---

::: {.persian}
# TCP، UDP و عیب‌یابی شبکه

**هدف:** شناخت ارتباط انتقالی، پورت‌ها و روش سیستماتیک عیب‌یابی.
:::

# 1. Learning Objectives

- Explain transport-layer communication.
- Compare TCP and UDP.
- Understand ports and sockets.
- Explain the TCP handshake.
- Understand TCP reliability.
- Inspect connections on Windows.
- Diagnose basic connectivity problems.

# 2. Transport Layer

The transport layer enables communication between application endpoints.

It allows multiple applications to communicate through one host network interface.

Two major transport protocols are TCP and UDP.

# 3. TCP Fundamentals

Transmission Control Protocol provides a reliable, ordered byte stream.

Its features include:

- Connection establishment.
- Sequence numbers.
- Acknowledgments.
- Retransmission.
- Flow control.
- Congestion control.

TCP does not guarantee that an application will always succeed. It provides transport-level mechanisms for reliable delivery.

# 4. TCP Three-Way Handshake

TCP normally establishes a connection using three steps.

```text
CLIENT                  SERVER
  |                        |
  |------ SYN ------------>|
  |                        |
  |<----- SYN-ACK ----------|
  |                        |
  |------ ACK ------------>|
  |                        |
  |     CONNECTION         |
  |      ESTABLISHED       |
```

## Step 1: SYN

The client requests connection establishment.

## Step 2: SYN-ACK

The server acknowledges the request and sends its own synchronization information.

## Step 3: ACK

The client acknowledges the server's response.

Both sides can now exchange application data.

# 5. TCP Sequence and Acknowledgment Numbers

TCP uses sequence numbers to track bytes in the stream.

Acknowledgment information indicates which data has been received successfully.

This enables retransmission and ordered delivery.

TCP segments may arrive through different paths or in different orders. TCP handles reassembly at the receiving endpoint.

# 6. UDP Fundamentals

User Datagram Protocol provides connectionless datagram transport.

UDP does not provide TCP-style:

- Connection establishment.
- Retransmission guarantees.
- Ordered delivery.
- Built-in flow control.

UDP has a smaller transport header and is useful when applications need low overhead or implement their own reliability mechanisms.

Examples include:

- DNS queries.
- Real-time voice.
- Video communication.
- Certain streaming and gaming protocols.

UDP does not automatically make an application faster. Performance depends on application behavior and network conditions.

# 7. TCP vs UDP

| Feature | TCP | UDP |
|---|---|---|
| Connection setup | Yes | No |
| Reliable delivery | Built in | Not guaranteed |
| Ordering | Yes | Not guaranteed |
| Retransmission | Yes | No built-in mechanism |
| Data model | Byte stream | Datagram |
| Header size | Minimum 20 bytes | 8 bytes |

# 8. Ports and Sockets

A port identifies a transport endpoint on a host.

Examples of common service ports:

| Service | Typical Port |
|---|---:|
| HTTP | TCP 80 |
| HTTPS | TCP 443 |
| SSH | TCP 22 |
| DNS | UDP/TCP 53 |
| DHCP Server | UDP 67 |
| DHCP Client | UDP 68 |
| NTP | UDP 123 |

DNS can use both UDP and TCP.

Port numbers are not security boundaries by themselves. Firewall rules and application configuration determine actual access.

A socket commonly combines addressing and transport information to identify a communication endpoint.

# 9. TCP Connection State

TCP connections move through states.

Common examples:

- LISTEN.
- SYN-SENT.
- ESTABLISHED.
- FIN-WAIT.
- CLOSE-WAIT.
- TIME-WAIT.

These states provide useful evidence during troubleshooting.

# 10. Practical Lab: Inspect TCP Connections

## 10.1 List Established Connections

```powershell
Get-NetTCPConnection -State Established
```

## 10.2 Inspect Listening Ports

```powershell
Get-NetTCPConnection -State Listen
```

## 10.3 Show Process IDs

```powershell
Get-NetTCPConnection |
    Select-Object LocalAddress, LocalPort,
                  RemoteAddress, RemotePort,
                  State, OwningProcess
```

## 10.4 Identify the Owning Process

```powershell
Get-Process -Id 1234
```

Replace `1234` with an actual process ID from the previous command.

## 10.5 Inspect UDP Endpoints

```powershell
Get-NetUDPEndpoint
```

# 11. Test Service Connectivity

PowerShell includes a useful TCP connectivity test.

```powershell
Test-NetConnection example.com -Port 443
```

Important output:

- RemoteAddress.
- RemotePort.
- InterfaceAlias.
- SourceAddress.
- TcpTestSucceeded.

A successful TCP test confirms that the TCP connection attempt succeeded at that moment. It does not validate the full application behavior.

# 12. DNS Troubleshooting

Run:

```powershell
Resolve-DnsName example.com
```

Then:

```powershell
nslookup example.com
```

Compare the results.

A DNS problem may cause a hostname to fail while direct IP connectivity still works.

However, HTTPS applications may also depend on certificates, hostnames and application-layer behavior.

# 13. Traceroute and Path Analysis

Run:

```powershell
tracert 1.1.1.1
```

Traceroute uses probe packets with progressively increasing TTL values.

Routers may return ICMP Time Exceeded messages.

Some networks filter or rate-limit these messages.

Therefore, missing traceroute responses do not necessarily indicate a forwarding failure.

# 14. A Structured Troubleshooting Scenario

Scenario:

A user reports that a website does not open.

Use this order:

1. Verify the adapter is connected.
2. Inspect IP configuration.
3. Test the local gateway.
4. Inspect the route.
5. Resolve the hostname.
6. Test the destination TCP port.
7. Check browser and application errors.

Example commands:

```powershell
Get-NetAdapter
```

```powershell
Get-NetIPConfiguration
```

```powershell
route print
```

```powershell
Resolve-DnsName example.com
```

```powershell
Test-NetConnection example.com -Port 443
```

Do not assume that one failed test identifies the root cause.

# 15. Network Automation Connection

A monitoring platform can regularly collect:

- Connection states.
- Listening ports.
- Reachability tests.
- DNS resolution results.
- Interface state.
- Route information.

A monitoring system should distinguish:

- Failure to resolve a name.
- Failure to establish a TCP connection.
- Application response errors.
- Packet loss.
- High latency.

These are different failure categories.

# 16. Practical Assignment

Choose a reachable HTTPS website.

Run:

```powershell
Test-NetConnection example.com -Port 443
```

Then inspect:

```powershell
Get-NetTCPConnection -State Established
```

Answer:

1. Which destination IP was selected?
2. Which local interface was used?
3. Was TCP connectivity successful?
4. What is the difference between a TCP port and an IP address?
5. Why does successful TCP connectivity not guarantee a successful webpage response?

# 17. Knowledge Check

1. What is the purpose of TCP?
2. What does UDP provide?
3. Explain the TCP three-way handshake.
4. What is a sequence number?
5. What is an acknowledgment?
6. What does a port identify?
7. Why can DNS use both UDP and TCP?
8. What does LISTEN mean?
9. What does Test-NetConnection verify?
10. Why should troubleshooting use multiple independent tests?

# 18. Completion Criteria

- [ ] Explain TCP and UDP.
- [ ] Understand the TCP handshake.
- [ ] Identify common ports.
- [ ] Understand connection states.
- [ ] Inspect TCP and UDP endpoints.
- [ ] Test TCP connectivity.
- [ ] Diagnose basic DNS and routing problems.
- [ ] Explain how these checks can be automated.

# 19. References

- [RFC 9293: TCP](https://www.rfc-editor.org/rfc/rfc9293)
- [RFC 768: UDP](https://www.rfc-editor.org/rfc/rfc768)
- [RFC 1035: DNS](https://www.rfc-editor.org/rfc/rfc1035)
- [RFC 792: ICMP](https://www.rfc-editor.org/rfc/rfc792)
- [Microsoft Test-NetConnection](https://learn.microsoft.com/en-us/powershell/module/nettcpip/test-netconnection)
- [Microsoft Get-NetTCPConnection](https://learn.microsoft.com/en-us/powershell/module/nettcpip/get-nettcpconnection)

::: {.persian}
**پایان هفته اول Networking**

در هفته اول با مبانی شبکه، مدل‌های ارتباطی، Ethernet، آدرس‌دهی IPv4 و انتقال داده آشنا شدیم.

در هفته دوم وارد مباحث عمیق‌تر شبکه و طراحی ارتباطات خواهیم شد.
:::
'@

# ============================================================
# 4. Validate lesson set
# ============================================================

$ExpectedFiles = @(
    "day-01.qmd",
    "day-02.qmd",
    "day-03.qmd",
    "day-04.qmd",
    "day-05.qmd"
)

foreach ($Name in $ExpectedFiles) {
    if (-not $Lessons.ContainsKey($Name)) {
        throw "Missing lesson: $Name"
    }

    $Content = $Lessons[$Name]

    if ($Content.Length -lt 1000) {
        throw "Lesson content unexpectedly short: $Name"
    }

    if ($Content -notmatch "Learning Objectives") {
        throw "Missing learning objectives: $Name"
    }

    if ($Content -notmatch "References") {
        throw "Missing references: $Name"
    }
}

# ============================================================
# 5. Write files with backups
# ============================================================

$Utf8 = New-Object System.Text.UTF8Encoding($false)

$Created = 0
$Updated = 0
$Preserved = 0

foreach ($Name in $ExpectedFiles) {

    $Destination = Join-Path $LessonDir $Name

    if (Test-Path $Destination) {

        $ExistingContent = Get-Content $Destination -Raw

        if (-not $Force) {

            if ($ExistingContent.Length -gt 1800) {

                Write-Host "Preserved existing lesson: $Name" `
                    -ForegroundColor Yellow

                $Preserved++
                continue
            }
        }

        New-Item -ItemType Directory `
            -Path $BackupDir -Force | Out-Null

        $Stamp = Get-Date -Format "yyyyMMdd-HHmmss"

        $BackupName = $Name -replace "\.qmd$", "-$Stamp.qmd"

        Copy-Item $Destination `
            (Join-Path $BackupDir $BackupName)

        $Updated++
    }
    else {
        $Created++
    }

    $Temp = "$Destination.tmp"

    [System.IO.File]::WriteAllText(
        $Temp,
        $Lessons[$Name],
        $Utf8
    )

    Move-Item -Path $Temp -Destination $Destination -Force

    Write-Host "Generated: $Name" -ForegroundColor Green
}

# ============================================================
# 6. Generate weekly index
# ============================================================

$IndexFile = Join-Path $LessonDir "index.qmd"

$Index = @'
---
title: "Networking - Week 01"
subtitle: "Network Foundations"
lang: en
toc: true
---

::: {.persian}
# هفته اول: مبانی شبکه
در این هفته پایه‌های ارتباطات شبکه‌ای را یاد می‌گیریم.
:::

## Lessons

1. [Computer Network Fundamentals](day-01.qmd)
2. [OSI and TCP/IP Models](day-02.qmd)
3. [Ethernet and Switching](day-03.qmd)
4. [IPv4 and Subnetting](day-04.qmd)
5. [TCP, UDP and Troubleshooting](day-05.qmd)

## Weekly Goals

- Understand basic network architecture.
- Explain layered communication.
- Understand Ethernet switching.
- Calculate basic IPv4 subnets.
- Troubleshoot basic connectivity.

## Weekly Practical Project

Create a technical inventory of your Windows computer.

Collect:

- Hostname.
- Network interfaces.
- MAC addresses.
- IPv4 addresses.
- Routing information.
- DNS configuration.
- Active TCP connections.

Write a short report explaining how your computer reaches a remote service.
'@

if ((-not (Test-Path $IndexFile)) -or $Force) {

    if (Test-Path $IndexFile) {

        New-Item -ItemType Directory `
            -Path $BackupDir -Force | Out-Null

        Copy-Item $IndexFile `
            (Join-Path $BackupDir "index-$(Get-Date -Format 'yyyyMMdd-HHmmss').qmd")
    }

    [System.IO.File]::WriteAllText(
        $IndexFile,
        $Index,
        $Utf8
    )
}

# ============================================================
# 7. Final report
# ============================================================

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " NETFLEET NETWORKING WEEK 01 BUILDER" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

Write-Host "Lessons expected: 5"
Write-Host "Created:          $Created"
Write-Host "Updated:          $Updated"
Write-Host "Preserved:        $Preserved"
Write-Host "Output:           $LessonDir"

Write-Host ""
Write-Host "Review all five lessons before rendering." -ForegroundColor Green
Write-Host "Run: quarto render" -ForegroundColor Yellow
