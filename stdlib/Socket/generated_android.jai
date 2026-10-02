// Public SDK interface transcription; executable code is the system SDK.
SOL_SOCKET :: 1;
SO_DEBUG :: 1;
SO_REUSEADDR :: 2;
SO_TYPE :: 3;
SO_ERROR :: 4;
SO_DONTROUTE :: 5;
SO_BROADCAST :: 6;
SO_SNDBUF :: 7;
SO_RCVBUF :: 8;
SO_SNDBUFFORCE :: 32;
SO_RCVBUFFORCE :: 33;
SO_KEEPALIVE :: 9;
SO_OOBINLINE :: 10;
SO_NO_CHECK :: 11;
SO_PRIORITY :: 12;
SO_LINGER :: 13;
SO_BSDCOMPAT :: 14;
SO_REUSEPORT :: 15;

SO_PASSCRED :: 16;
SO_PEERCRED :: 17;
SO_RCVLOWAT :: 18;
SO_SNDLOWAT :: 19;
SO_RCVTIMEO_OLD :: 20;
SO_SNDTIMEO_OLD :: 21;

SO_SECURITY_AUTHENTICATION :: 22;
SO_SECURITY_ENCRYPTION_TRANSPORT :: 23;
SO_SECURITY_ENCRYPTION_NETWORK :: 24;
SO_BINDTODEVICE :: 25;
SO_ATTACH_FILTER :: 26;
SO_DETACH_FILTER :: 27;
SO_GET_FILTER :: SO_ATTACH_FILTER;
SO_PEERNAME :: 28;
SO_ACCEPTCONN :: 30;
SO_PEERSEC :: 31;
SO_PASSSEC :: 34;
SO_MARK :: 36;
SO_PROTOCOL :: 38;
SO_DOMAIN :: 39;
SO_RXQ_OVFL :: 40;
SO_WIFI_STATUS :: 41;
SCM :: enum u32 {
 WIFI_STATUS :: SO_WIFI_STATUS;
 TIMESTAMPING_OPT_STATS :: 54;
 TIMESTAMPING_PKTINFO :: 58;
 TXTIME :: SO_TXTIME;
 TIMESTAMP :: SO_TIMESTAMP;
 TIMESTAMPNS :: SO_TIMESTAMPNS;
 TIMESTAMPING :: SO_TIMESTAMPING;
 RIGHTS :: 0x01;
 CREDENTIALS :: 0x02;
 SECURITY :: 0x03;

 SCM_WIFI_STATUS :: WIFI_STATUS;
 SCM_TIMESTAMPING_OPT_STATS :: TIMESTAMPING_OPT_STATS;
 SCM_TIMESTAMPING_PKTINFO :: TIMESTAMPING_PKTINFO;
 SCM_TXTIME :: TXTIME;
 SCM_TIMESTAMP :: TIMESTAMP;
 SCM_TIMESTAMPNS :: TIMESTAMPNS;
 SCM_TIMESTAMPING :: TIMESTAMPING;
 SCM_RIGHTS :: RIGHTS;
 SCM_CREDENTIALS :: CREDENTIALS;
 SCM_SECURITY :: SECURITY;
}
SO_PEEK_OFF :: 42;
SO_NOFCS :: 43;
SO_LOCK_FILTER :: 44;
SO_SELECT_ERR_QUEUE :: 45;
SO_BUSY_POLL :: 46;
SO_MAX_PACING_RATE :: 47;
SO_BPF_EXTENSIONS :: 48;
SO_INCOMING_CPU :: 49;
SO_ATTACH_BPF :: 50;
SO_DETACH_BPF :: SO_DETACH_FILTER;
SO_ATTACH_REUSEPORT_CBPF :: 51;
SO_ATTACH_REUSEPORT_EBPF :: 52;
SO_CNX_ADVICE :: 53;

SO_MEMINFO :: 55;
SO_INCOMING_NAPI_ID :: 56;
SO_COOKIE :: 57;

SO_PEERGROUPS :: 59;
SO_ZEROCOPY :: 60;
SO_TXTIME :: 61;

SO_BINDTOIFINDEX :: 62;
SO_TIMESTAMP_OLD :: 29;
SO_TIMESTAMPNS_OLD :: 35;
SO_TIMESTAMPING_OLD :: 37;
SO_TIMESTAMP_NEW :: 63;
SO_TIMESTAMPNS_NEW :: 64;
SO_TIMESTAMPING_NEW :: 65;
SO_RCVTIMEO_NEW :: 66;
SO_SNDTIMEO_NEW :: 67;
SO_DETACH_REUSEPORT_BPF :: 68;
SO_PREFER_BUSY_POLL :: 69;
SO_BUSY_POLL_BUDGET :: 70;
SO_NETNS_COOKIE :: 71;
SO_BUF_LOCK :: 72;
SO_RESERVE_MEM :: 73;
SO_TXREHASH :: 74;
SO_RCVMARK :: 75;

SO_TIMESTAMP :: SO_TIMESTAMP_OLD;
SO_TIMESTAMPNS :: SO_TIMESTAMPNS_OLD;
SO_TIMESTAMPING :: SO_TIMESTAMPING_OLD;
SO_RCVTIMEO :: SO_RCVTIMEO_OLD;
SO_SNDTIMEO :: SO_SNDTIMEO_OLD;

SOCK :: enum u32 {
 STREAM :: 1;
 DGRAM :: 2;
 RAW :: 3;
 RDM :: 4;
 SEQPACKET :: 5;
 DCCP :: 6;
 PACKET :: 10;

 SOCK_STREAM :: STREAM;
 SOCK_DGRAM :: DGRAM;
 SOCK_RAW :: RAW;
 SOCK_RDM :: RDM;
 SOCK_SEQPACKET :: SEQPACKET;
 SOCK_DCCP :: DCCP;
 SOCK_PACKET :: PACKET;
}

AF_UNSPEC :: 0;
AF_UNIX :: 1;
AF_LOCAL :: 1;
AF_INET :: 2;
AF_AX25 :: 3;
AF_IPX :: 4;
AF_APPLETALK :: 5;
AF_NETROM :: 6;
AF_BRIDGE :: 7;
AF_ATMPVC :: 8;
AF_X25 :: 9;
AF_INET6 :: 10;
AF_ROSE :: 11;
AF_DECnet :: 12;
AF_NETBEUI :: 13;
AF_SECURITY :: 14;
AF_KEY :: 15;
AF_NETLINK :: 16;
AF_ROUTE :: AF_NETLINK;
AF_PACKET :: 17;
AF_ASH :: 18;
AF_ECONET :: 19;
AF_ATMSVC :: 20;
AF_RDS :: 21;
AF_SNA :: 22;
AF_IRDA :: 23;
AF_PPPOX :: 24;
AF_WANPIPE :: 25;
AF_LLC :: 26;
AF_CAN :: 29;
AF_TIPC :: 30;
AF_BLUETOOTH :: 31;
AF_IUCV :: 32;
AF_RXRPC :: 33;
AF_ISDN :: 34;
AF_PHONET :: 35;
AF_IEEE802154 :: 36;
AF_CAIF :: 37;
AF_ALG :: 38;
AF_NFC :: 39;
AF_VSOCK :: 40;
AF_KCM :: 41;
AF_QIPCRTR :: 42;
AF_MAX :: 43;

PF_UNSPEC :: AF_UNSPEC;
PF_UNIX :: AF_UNIX;
PF_LOCAL :: AF_LOCAL;
PF_INET :: AF_INET;
PF_AX25 :: AF_AX25;
PF_IPX :: AF_IPX;
PF_APPLETALK :: AF_APPLETALK;
PF_NETROM :: AF_NETROM;
PF_BRIDGE :: AF_BRIDGE;
PF_ATMPVC :: AF_ATMPVC;
PF_X25 :: AF_X25;
PF_INET6 :: AF_INET6;
PF_ROSE :: AF_ROSE;
PF_DECnet :: AF_DECnet;
PF_NETBEUI :: AF_NETBEUI;
PF_SECURITY :: AF_SECURITY;
PF_KEY :: AF_KEY;
PF_NETLINK :: AF_NETLINK;
PF_ROUTE :: AF_ROUTE;
PF_PACKET :: AF_PACKET;
PF_ASH :: AF_ASH;
PF_ECONET :: AF_ECONET;
PF_ATMSVC :: AF_ATMSVC;
PF_RDS :: AF_RDS;
PF_SNA :: AF_SNA;
PF_IRDA :: AF_IRDA;
PF_PPPOX :: AF_PPPOX;
PF_WANPIPE :: AF_WANPIPE;
PF_LLC :: AF_LLC;
PF_CAN :: AF_CAN;
PF_TIPC :: AF_TIPC;
PF_BLUETOOTH :: AF_BLUETOOTH;
PF_IUCV :: AF_IUCV;
PF_RXRPC :: AF_RXRPC;
PF_ISDN :: AF_ISDN;
PF_PHONET :: AF_PHONET;
PF_IEEE802154 :: AF_IEEE802154;
PF_CAIF :: AF_CAIF;
PF_ALG :: AF_ALG;
PF_NFC :: AF_NFC;
PF_VSOCK :: AF_VSOCK;
PF_KCM :: AF_KCM;
PF_QIPCRTR :: AF_QIPCRTR;
PF_MAX :: AF_MAX;

SOMAXCONN :: 128;

MSG :: enum_flags s32 {
 OOB :: 1;
 PEEK :: 2;
 DONTROUTE :: 4;
 TRYHARD :: 4;
 CTRUNC :: 8;
 PROBE :: 0x10;
 TRUNC :: 0x20;
 DONTWAIT :: 0x40;
 EOR :: 0x80;
 WAITALL :: 0x100;
 FIN :: 0x200;
 SYN :: 0x400;
 CONFIRM :: 0x800;
 RST :: 0x1000;
 ERRQUEUE :: 0x2000;
 NOSIGNAL :: 0x4000;
 MORE :: 0x8000;
 WAITFORONE :: 0x10000;
 BATCH :: 0x40000;
 FASTOPEN :: 0x20000000;
 CMSG_CLOEXEC :: 0x40000000;
 EOF :: FIN;
 CMSG_COMPAT :: 0;

 MSG_OOB :: OOB;
 MSG_PEEK :: PEEK;
 MSG_DONTROUTE :: DONTROUTE;
 MSG_TRYHARD :: TRYHARD;
 MSG_CTRUNC :: CTRUNC;
 MSG_PROBE :: PROBE;
 MSG_TRUNC :: TRUNC;
 MSG_DONTWAIT :: DONTWAIT;
 MSG_EOR :: EOR;
 MSG_WAITALL :: WAITALL;
 MSG_FIN :: FIN;
 MSG_SYN :: SYN;
 MSG_CONFIRM :: CONFIRM;
 MSG_RST :: RST;
 MSG_ERRQUEUE :: ERRQUEUE;
 MSG_NOSIGNAL :: NOSIGNAL;
 MSG_MORE :: MORE;
 MSG_WAITFORONE :: WAITFORONE;
 MSG_BATCH :: BATCH;
 MSG_FASTOPEN :: FASTOPEN;
 MSG_CMSG_CLOEXEC :: CMSG_CLOEXEC;
 MSG_EOF :: EOF;
 MSG_CMSG_COMPAT :: CMSG_COMPAT;
}

SOL_IP :: 0;
SOL_TCP :: 6;
SOL_UDP :: 17;
SOL_IPV6 :: 41;
SOL_ICMPV6 :: 58;
SOL_SCTP :: 132;
SOL_RAW :: 255;
SOL_IPX :: 256;
SOL_AX25 :: 257;
SOL_ATALK :: 258;
SOL_NETROM :: 259;
SOL_ROSE :: 260;
SOL_DECNET :: 261;
SOL_X25 :: 262;
SOL_PACKET :: 263;
SOL_ATM :: 264;
SOL_AAL :: 265;
SOL_IRDA :: 266;
SOL_NETBEUI :: 267;
SOL_LLC :: 268;
SOL_DCCP :: 269;
SOL_NETLINK :: 270;
SOL_TIPC :: 271;
SOL_RXRPC :: 272;
SOL_PPPOL2TP :: 273;
SOL_BLUETOOTH :: 274;
SOL_PNPIPE :: 275;
SOL_RDS :: 276;
SOL_IUCV :: 277;
SOL_CAIF :: 278;
SOL_ALG :: 279;
SOL_NFC :: 280;
SOL_KCM :: 281;
SOL_TLS :: 282;

IPX_TYPE :: 1;

IPV6_FL_A_GET :: 0;
IPV6_FL_A_PUT :: 1;
IPV6_FL_A_RENEW :: 2;
IPV6_FL_F_CREATE :: 1;
IPV6_FL_F_EXCL :: 2;
IPV6_FL_F_REFLECT :: 4;
IPV6_FL_F_REMOTE :: 8;
IPV6_FL_S_NONE :: 0;
IPV6_FL_S_EXCL :: 1;
IPV6_FL_S_PROCESS :: 2;
IPV6_FL_S_USER :: 3;
IPV6_FL_S_ANY :: 255;
IPV6_FLOWINFO_FLOWLABEL :: 0x000fffff;
IPV6_FLOWINFO_PRIORITY :: 0x0ff00000;
IPV6_PRIORITY_UNCHARACTERIZED :: 0x0000;
IPV6_PRIORITY_FILLER :: 0x0100;
IPV6_PRIORITY_UNATTENDED :: 0x0200;
IPV6_PRIORITY_RESERVED1 :: 0x0300;
IPV6_PRIORITY_BULK :: 0x0400;
IPV6_PRIORITY_RESERVED2 :: 0x0500;
IPV6_PRIORITY_INTERACTIVE :: 0x0600;
IPV6_PRIORITY_CONTROL :: 0x0700;
IPV6_PRIORITY_8 :: 0x0800;
IPV6_PRIORITY_9 :: 0x0900;
IPV6_PRIORITY_10 :: 0x0a00;
IPV6_PRIORITY_11 :: 0x0b00;
IPV6_PRIORITY_12 :: 0x0c00;
IPV6_PRIORITY_13 :: 0x0d00;
IPV6_PRIORITY_14 :: 0x0e00;
IPV6_PRIORITY_15 :: 0x0f00;

IPV6_TLV_PAD1 :: 0;
IPV6_TLV_PADN :: 1;
IPV6_TLV_ROUTERALERT :: 5;
IPV6_TLV_CALIPSO :: 7;
IPV6_TLV_IOAM :: 49;
IPV6_TLV_JUMBO :: 194;
IPV6_TLV_HAO :: 201;

IPV6_ADDRFORM :: 1;
IPV6_2292PKTINFO :: 2;
IPV6_2292HOPOPTS :: 3;
IPV6_2292DSTOPTS :: 4;
IPV6_2292RTHDR :: 5;
IPV6_2292PKTOPTIONS :: 6;
IPV6_CHECKSUM :: 7;
IPV6_2292HOPLIMIT :: 8;
IPV6_NEXTHOP :: 9;
IPV6_AUTHHDR :: 10;
IPV6_FLOWINFO :: 11;
IPV6_UNICAST_HOPS :: 16;
IPV6_MULTICAST_IF :: 17;
IPV6_MULTICAST_HOPS :: 18;
IPV6_MULTICAST_LOOP :: 19;
IPV6_ADD_MEMBERSHIP :: 20;
IPV6_DROP_MEMBERSHIP :: 21;
IPV6_ROUTER_ALERT :: 22;
IPV6_MTU_DISCOVER :: 23;
IPV6_MTU :: 24;
IPV6_RECVERR :: 25;
IPV6_V6ONLY :: 26;
IPV6_JOIN_ANYCAST :: 27;
IPV6_LEAVE_ANYCAST :: 28;
IPV6_MULTICAST_ALL :: 29;
IPV6_ROUTER_ALERT_ISOLATE :: 30;
IPV6_RECVERR_RFC4884 :: 31;
IPV6_PMTUDISC_DONT :: 0;
IPV6_PMTUDISC_WANT :: 1;
IPV6_PMTUDISC_DO :: 2;
IPV6_PMTUDISC_PROBE :: 3;
IPV6_PMTUDISC_INTERFACE :: 4;
IPV6_PMTUDISC_OMIT :: 5;
IPV6_FLOWLABEL_MGR :: 32;
IPV6_FLOWINFO_SEND :: 33;
IPV6_IPSEC_POLICY :: 34;
IPV6_XFRM_POLICY :: 35;
IPV6_HDRINCL :: 36;

IPV6_RECVPKTINFO :: 49;
IPV6_PKTINFO :: 50;
IPV6_RECVHOPLIMIT :: 51;
IPV6_HOPLIMIT :: 52;
IPV6_RECVHOPOPTS :: 53;
IPV6_HOPOPTS :: 54;
IPV6_RTHDRDSTOPTS :: 55;
IPV6_RECVRTHDR :: 56;
IPV6_RTHDR :: 57;
IPV6_RECVDSTOPTS :: 58;
IPV6_DSTOPTS :: 59;
IPV6_RECVPATHMTU :: 60;
IPV6_PATHMTU :: 61;
IPV6_DONTFRAG :: 62;
IPV6_RECVTCLASS :: 66;
IPV6_TCLASS :: 67;
IPV6_AUTOFLOWLABEL :: 70;
IPV6_ADDR_PREFERENCES :: 72;
IPV6_PREFER_SRC_TMP :: 0x0001;
IPV6_PREFER_SRC_PUBLIC :: 0x0002;
IPV6_PREFER_SRC_PUBTMP_DEFAULT :: 0x0100;
IPV6_PREFER_SRC_COA :: 0x0004;
IPV6_PREFER_SRC_HOME :: 0x0400;
IPV6_PREFER_SRC_CGA :: 0x0008;
IPV6_PREFER_SRC_NONCGA :: 0x0800;
IPV6_MINHOPCOUNT :: 73;
IPV6_ORIGDSTADDR :: 74;
IPV6_RECVORIGDSTADDR :: IPV6_ORIGDSTADDR;
IPV6_TRANSPARENT :: 75;
IPV6_UNICAST_IF :: 76;
IPV6_RECVFRAGSIZE :: 77;
IPV6_FREEBIND :: 78;

IPV6_ADDR_SCOPE_NODELOCAL :: 0x01;
IPV6_ADDR_SCOPE_INTFACELOCAL :: 0x01;
IPV6_ADDR_SCOPE_LINKLOCAL :: 0x02;
IPV6_ADDR_SCOPE_SITELOCAL :: 0x05;
IPV6_ADDR_SCOPE_ORGLOCAL :: 0x08;
IPV6_ADDR_SCOPE_GLOBAL :: 0x0e;

INET6_ADDRSTRLEN :: 46;

IPV6_JOIN_GROUP :: IPV6_ADD_MEMBERSHIP;
IPV6_LEAVE_GROUP :: IPV6_DROP_MEMBERSHIP;

__kernel_sockaddr_storage :: sockaddr_storage;

IP_TOS :: 1;
IP_TTL :: 2;
IP_HDRINCL :: 3;
IP_OPTIONS :: 4;
IP_ROUTER_ALERT :: 5;
IP_RECVOPTS :: 6;
IP_RETOPTS :: 7;
IP_PKTINFO :: 8;
IP_PKTOPTIONS :: 9;
IP_MTU_DISCOVER :: 10;
IP_RECVERR :: 11;
IP_RECVTTL :: 12;
IP_RECVTOS :: 13;
IP_MTU :: 14;
IP_FREEBIND :: 15;
IP_IPSEC_POLICY :: 16;
IP_XFRM_POLICY :: 17;
IP_PASSSEC :: 18;
IP_TRANSPARENT :: 19;
IP_RECVRETOPTS :: IP_RETOPTS;
IP_ORIGDSTADDR :: 20;
IP_RECVORIGDSTADDR :: IP_ORIGDSTADDR;
IP_MINTTL :: 21;
IP_NODEFRAG :: 22;
IP_CHECKSUM :: 23;
IP_BIND_ADDRESS_NO_PORT :: 24;
IP_RECVFRAGSIZE :: 25;
IP_RECVERR_RFC4884 :: 26;
IP_PMTUDISC_DONT :: 0;
IP_PMTUDISC_WANT :: 1;
IP_PMTUDISC_DO :: 2;
IP_PMTUDISC_PROBE :: 3;
IP_PMTUDISC_INTERFACE :: 4;
IP_PMTUDISC_OMIT :: 5;
IP_MULTICAST_IF :: 32;
IP_MULTICAST_TTL :: 33;
IP_MULTICAST_LOOP :: 34;
IP_ADD_MEMBERSHIP :: 35;
IP_DROP_MEMBERSHIP :: 36;
IP_UNBLOCK_SOURCE :: 37;
IP_BLOCK_SOURCE :: 38;
IP_ADD_SOURCE_MEMBERSHIP :: 39;
IP_DROP_SOURCE_MEMBERSHIP :: 40;
IP_MSFILTER :: 41;
MCAST_JOIN_GROUP :: 42;
MCAST_BLOCK_SOURCE :: 43;
MCAST_UNBLOCK_SOURCE :: 44;
MCAST_LEAVE_GROUP :: 45;
MCAST_JOIN_SOURCE_GROUP :: 46;
MCAST_LEAVE_SOURCE_GROUP :: 47;
MCAST_MSFILTER :: 48;
IP_MULTICAST_ALL :: 49;
IP_UNICAST_IF :: 50;
IP_LOCAL_PORT_RANGE :: 51;
MCAST_EXCLUDE :: 0;
MCAST_INCLUDE :: 1;
IP_DEFAULT_MULTICAST_TTL :: 1;
IP_DEFAULT_MULTICAST_LOOP :: 1;

__SOCK_SIZE__ :: 16;

IN_CLASSA_NET :: 0xff000000;
IN_CLASSA_NSHIFT :: 24;
IN_CLASSA_HOST :: 0xffffffff & ~IN_CLASSA_NET;
IN_CLASSA_MAX :: 128;

IN_CLASSB_NET :: 0xffff0000;
IN_CLASSB_NSHIFT :: 16;
IN_CLASSB_HOST :: 0xffffffff & ~IN_CLASSB_NET;
IN_CLASSB_MAX :: 65536;

IN_CLASSC_NET :: 0xffffff00;
IN_CLASSC_NSHIFT :: 8;
IN_CLASSC_HOST :: 0xffffffff & ~IN_CLASSC_NET;

IN_MULTICAST_NET :: 0xe0000000;

IN_CLASSE_NET :: 0xffffffff;
IN_CLASSE_NSHIFT :: 0;

IN_LOOPBACKNET :: 127;
INADDR_LOOPBACK :: 0x7f000001;

INADDR_UNSPEC_GROUP :: 0xe0000000;
INADDR_ALLHOSTS_GROUP :: 0xe0000001;
INADDR_ALLRTRS_GROUP :: 0xe0000002;
INADDR_ALLSNOOPERS_GROUP :: 0xe000006a;
INADDR_MAX_LOCAL_GROUP :: 0xe00000ff;

INET_ADDRSTRLEN :: 16;

TH_FIN :: 0x01;
TH_SYN :: 0x02;
TH_RST :: 0x04;
TH_PUSH :: 0x08;
TH_ACK :: 0x10;
TH_URG :: 0x20;

TCPOPT_EOL :: 0;
TCPOPT_NOP :: 1;
TCPOPT_MAXSEG :: 2;
TCPOLEN_MAXSEG :: 4;
TCPOPT_WINDOW :: 3;
TCPOLEN_WINDOW :: 3;
TCPOPT_SACK_PERMITTED :: 4;
TCPOLEN_SACK_PERMITTED :: 2;
TCPOPT_SACK :: 5;
TCPOPT_TIMESTAMP :: 8;
TCPOLEN_TIMESTAMP :: 10;
TCPOLEN_TSTAMP_APPA :: TCPOLEN_TIMESTAMP+2;

TCPOPT_TSTAMP_HDR :: TCPOPT_NOP<<24|TCPOPT_NOP<<16|TCPOPT_TIMESTAMP<<8|TCPOLEN_TIMESTAMP;

_PATH_HEQUIV :: "/system/etc/hosts.equiv";

_PATH_HOSTS :: "/system/etc/hosts";
_PATH_NETWORKS :: "/system/etc/networks";
_PATH_PROTOCOLS :: "/system/etc/protocols";
_PATH_SERVICES :: "/system/etc/services";

NETDB_INTERNAL :: -1;
NETDB_SUCCESS :: 0;
HOST_NOT_FOUND :: 1;
TRY_AGAIN :: 2;
NO_RECOVERY :: 3;
NO_DATA :: 4;
NO_ADDRESS :: NO_DATA;

EAI_ADDRFAMILY :: 1;
EAI_AGAIN :: 2;
EAI_BADFLAGS :: 3;
EAI_FAIL :: 4;
EAI_FAMILY :: 5;
EAI_MEMORY :: 6;
EAI_NODATA :: 7;
EAI_NONAME :: 8;
EAI_SERVICE :: 9;
EAI_SOCKTYPE :: 10;
EAI_SYSTEM :: 11;
EAI_BADHINTS :: 12;
EAI_PROTOCOL :: 13;
EAI_OVERFLOW :: 14;
EAI_MAX :: 15;

AI :: enum_flags u32 {
 PASSIVE :: 0x00000001;
 CANONNAME :: 0x00000002;
 NUMERICHOST :: 0x00000004;
 NUMERICSERV :: 0x00000008;
 MASK :: PASSIVE | CANONNAME | NUMERICHOST | NUMERICSERV | ADDRCONFIG;
 ALL :: 0x00000100;
 V4MAPPED_CFG :: 0x00000200;
 ADDRCONFIG :: 0x00000400;
 V4MAPPED :: 0x00000800;
 DEFAULT :: V4MAPPED_CFG | ADDRCONFIG;

 AI_PASSIVE :: PASSIVE;
 AI_CANONNAME :: CANONNAME;
 AI_NUMERICHOST :: NUMERICHOST;
 AI_NUMERICSERV :: NUMERICSERV;
 AI_MASK :: MASK;
 AI_ALL :: ALL;
 AI_V4MAPPED_CFG :: V4MAPPED_CFG;
 AI_ADDRCONFIG :: ADDRCONFIG;
 AI_V4MAPPED :: V4MAPPED;
 AI_DEFAULT :: DEFAULT;
}

NI_MAXHOST :: 1025;
NI_MAXSERV :: 32;

NI_NOFQDN :: 0x00000001;
NI_NUMERICHOST :: 0x00000002;
NI_NAMEREQD :: 0x00000004;
NI_NUMERICSERV :: 0x00000008;
NI_DGRAM :: 0x00000010;

IPPORT_RESERVED :: 1024;

FD_SETSIZE :: 1024;

socklen_t :: u32;

sa_family_t :: u16;

SHUT :: enum u32 {
 RD :: 0;

 WR :: 1;

 RDWR :: 2;

 SHUT_RD :: RD;

 SHUT_WR :: WR;

 SHUT_RDWR :: RDWR;
}

sockaddr :: struct {
 sa_family: sa_family_t;
 sa_data: [14] u8;
}

sockaddr_storage :: struct {
 union {
 struct {
 ss_family: sa_family_t;
 __data: [126] u8;
 }

 __align: *void;
 }
}

linger :: struct {
 l_onoff: s32;
 l_linger: s32;
}

msghdr :: struct {
 msg_name: *void;
 msg_namelen: socklen_t;
 msg_iov: *iovec;
 msg_iovlen: u64;
 msg_control: *void;
 msg_controllen: u64;
 msg_flags: s32;
}

mmsghdr :: struct {
 msg_hdr: msghdr;
 msg_len: u32;
}

cmsghdr :: struct {
 cmsg_len: u64;
 cmsg_level: s32;
 cmsg_type: s32;
}

__cmsg_nxthdr :: (__msg: *msghdr, __cmsg: *cmsghdr) -> *cmsghdr #foreign libc;

ucred :: struct {
 pid: pid_t;
 uid: uid_t;
 gid: gid_t;
}

accept :: (__fd: s32, __addr: *sockaddr, __addr_length: *socklen_t) -> s32 #foreign libc;

accept4 :: (__fd: s32, __addr: *sockaddr, __addr_length: *socklen_t, __flags: SOCK) -> s32 #foreign libc;

bind :: (__fd: s32, __addr: *sockaddr, __addr_length: socklen_t) -> s32 #foreign libc;
connect :: (__fd: s32, __addr: *sockaddr, __addr_length: socklen_t) -> s32 #foreign libc;
getpeername :: (__fd: s32, __addr: *sockaddr, __addr_length: *socklen_t) -> s32 #foreign libc;
getsockname :: (__fd: s32, __addr: *sockaddr, __addr_length: *socklen_t) -> s32 #foreign libc;
getsockopt :: (__fd: s32, __level: s32, __option: s32, __value: *void, __value_length: *socklen_t) -> s32 #foreign libc;
listen :: (__fd: s32, __backlog: s32) -> s32 #foreign libc;

recvmmsg :: (__fd: s32, __msgs: *mmsghdr, __msg_count: u32, __flags: MSG, __timeout: *timespec) -> s32 #foreign libc;

recvmsg :: (__fd: s32, __msg: *msghdr, __flags: MSG) -> s64 #foreign libc;

sendmmsg :: (__fd: s32, __msgs: *mmsghdr, __msg_count: u32, __flags: MSG) -> s32 #foreign libc;

sendmsg :: (__fd: s32, __msg: *msghdr, __flags: MSG) -> s64 #foreign libc;
setsockopt :: (__fd: s32, __level: s32, __option: s32, __value: *void, __value_length: socklen_t) -> s32 #foreign libc;
shutdown :: (__fd: s32, __how: SHUT) -> s32 #foreign libc;
socket :: (__af: s32, __type: SOCK, __protocol: IPPROTO) -> s32 #foreign libc;
socketpair :: (__af: s32, __type: SOCK, __protocol: IPPROTO, __fds: *[2] s32) -> s32 #foreign libc;

recv :: (__fd: s32, __buf: *void, __n: u64, __flags: MSG) -> s64 #foreign libc;
send :: (__fd: s32, __buf: *void, __n: u64, __flags: MSG) -> s64 #foreign libc;

sendto :: (__fd: s32, __buf: *void, __n: u64, __flags: MSG, __dst_addr: *sockaddr, __dst_addr_length: socklen_t) -> s64 #foreign libc;
recvfrom :: (__fd: s32, __buf: *void, __n: u64, __flags: MSG, __src_addr: *sockaddr, __src_addr_length: *socklen_t) -> s64 #foreign libc;

in6_addr :: struct {
 in6_u: union {
 u6_addr8: [16] u8;

 u6_addr16: [8] u16;
 u6_addr32: [4] u32;
 };
}

sockaddr_in6 :: struct {
 sin6_family: u16;
 sin6_port: u16;
 sin6_flowinfo: u32;
 sin6_addr: in6_addr;
 sin6_scope_id: u32;
}

ipv6_mreq :: struct {
 ipv6mr_multiaddr: in6_addr;
 ipv6mr_ifindex: s32;
}

in6_flowlabel_req :: struct {
 flr_dst: in6_addr;
 flr_label: u32;
 flr_action: u8;
 flr_share: u8;
 flr_flags: u16;
 flr_expires: u16;
 flr_linger: u16;
 __flr_pad: u32;
}

in_addr_t :: u32;

in_addr :: struct {
 s_addr: in_addr_t;
}

IPPROTO :: enum u32 {
 IP :: 0;
 ICMP :: 1;
 IGMP :: 2;
 IPIP :: 4;
 TCP :: 6;
 EGP :: 8;
 PUP :: 12;
 UDP :: 17;
 IDP :: 22;
 TP :: 29;
 DCCP :: 33;
 IPV6 :: 41;
 RSVP :: 46;
 GRE :: 47;
 ESP :: 50;
 AH :: 51;
 MTP :: 92;
 BEETPH :: 94;
 ENCAP :: 98;
 PIM :: 103;
 COMP :: 108;
 L2TP :: 115;
 SCTP :: 132;
 UDPLITE :: 136;
 MPLS :: 137;
 ETHERNET :: 143;
 RAW :: 255;
 MPTCP :: 262;
 MAX :: 263;
 IPPROTO_HOPOPTS :: 0;
 IPPROTO_ROUTING :: 43;
 IPPROTO_FRAGMENT :: 44;
 IPPROTO_ICMPV6 :: 58;
 IPPROTO_NONE :: 59;
 IPPROTO_DSTOPTS :: 60;
 IPPROTO_MH :: 135;

 IPPROTO_IP :: IP;
 IPPROTO_ICMP :: ICMP;
 IPPROTO_IGMP :: IGMP;
 IPPROTO_IPIP :: IPIP;
 IPPROTO_TCP :: TCP;
 IPPROTO_EGP :: EGP;
 IPPROTO_PUP :: PUP;
 IPPROTO_UDP :: UDP;
 IPPROTO_IDP :: IDP;
 IPPROTO_TP :: TP;
 IPPROTO_DCCP :: DCCP;
 IPPROTO_IPV6 :: IPV6;
 IPPROTO_RSVP :: RSVP;
 IPPROTO_GRE :: GRE;
 IPPROTO_ESP :: ESP;
 IPPROTO_AH :: AH;
 IPPROTO_MTP :: MTP;
 IPPROTO_BEETPH :: BEETPH;
 IPPROTO_ENCAP :: ENCAP;
 IPPROTO_PIM :: PIM;
 IPPROTO_COMP :: COMP;
 IPPROTO_L2TP :: L2TP;
 IPPROTO_SCTP :: SCTP;
 IPPROTO_UDPLITE :: UDPLITE;
 IPPROTO_MPLS :: MPLS;
 IPPROTO_ETHERNET :: ETHERNET;
 IPPROTO_RAW :: RAW;
 IPPROTO_MPTCP :: MPTCP;
 IPPROTO_MAX :: MAX;
}

ip_mreq :: struct {
 imr_multiaddr: in_addr;
 imr_interface: in_addr;
}

ip_mreqn :: struct {
 imr_multiaddr: in_addr;
 imr_address: in_addr;
 imr_ifindex: s32;
}

group_req :: struct {
 gr_interface: u32;
 gr_group: sockaddr_storage #align 4;
}

group_source_req :: struct {
 gsr_interface: u32;
 gsr_group: sockaddr_storage #align 4;
 gsr_source: sockaddr_storage;
}

group_filter :: struct {
 union {
 struct {
 gf_interface_aux: u32;
 gf_group_aux: sockaddr_storage #align 4;
 gf_fmode_aux: u32;
 gf_numsrc_aux: u32;
 gf_slist: [1] sockaddr_storage;
 }

 struct {
 gf_interface: u32;
 gf_group: sockaddr_storage #align 4;
 gf_fmode: u32;
 gf_numsrc: u32;

 }
 }
}

in_pktinfo :: struct {
 ipi_ifindex: s32;
 ipi_spec_dst: in_addr;
 ipi_addr: in_addr;
}

sockaddr_in :: struct {
 sin_family: u16;
 sin_port: u16;
 sin_addr: in_addr;
 __pad: [8] u8;
}

in_port_t :: u16;

bindresvport :: (__fd: s32, __sin: *sockaddr_in) -> s32 #foreign libc;

in6addr_any: in6_addr;
in6addr_loopback: in6_addr;

tcphdr :: struct {
 union {
 struct {
 th_sport: u16;
 th_dport: u16;
 th_seq: u32;
 th_ack: u32;
 __bitfield: u8;

 th_flags: u8;
 th_win: u16;
 th_sum: u16;
 th_urp: u16;
 }

 struct {
 source: u16;
 dest: u16;
 seq: u32;
 ack_seq: u32;
 __bitfield_1: u16;

 window: u16;
 check: u16;
 urg_ptr: u16;
 }
 }
}

TCP_2 :: enum u32 {
 ESTABLISHED :: 1;
 SYN_SENT :: 2;
 SYN_RECV :: 3;
 FIN_WAIT1 :: 4;
 FIN_WAIT2 :: 5;
 TIME_WAIT :: 6;
 CLOSE :: 7;
 CLOSE_WAIT :: 8;
 LAST_ACK :: 9;
 LISTEN :: 10;
 CLOSING :: 11;

 TCP_ESTABLISHED :: ESTABLISHED;
 TCP_SYN_SENT :: SYN_SENT;
 TCP_SYN_RECV :: SYN_RECV;
 TCP_FIN_WAIT1 :: FIN_WAIT1;
 TCP_FIN_WAIT2 :: FIN_WAIT2;
 TCP_TIME_WAIT :: TIME_WAIT;
 TCP_CLOSE :: CLOSE;
 TCP_CLOSE_WAIT :: CLOSE_WAIT;
 TCP_LAST_ACK :: LAST_ACK;
 TCP_LISTEN :: LISTEN;
 TCP_CLOSING :: CLOSING;
}

hostent :: struct {
 h_name: *u8;
 h_aliases: **u8;
 h_addrtype: s32;
 h_length: s32;
 h_addr_list: **u8;
}

netent :: struct {
 n_name: *u8;
 n_aliases: **u8;
 n_addrtype: s32;
 n_net: u32;
}

servent :: struct {
 s_name: *u8;
 s_aliases: **u8;
 s_port: s32;
 s_proto: *u8;
}

protoent :: struct {
 p_name: *u8;
 p_aliases: **u8;
 p_proto: s32;
}

addrinfo :: struct {
 ai_flags: AI;
 ai_family: s32;
 ai_socktype: SOCK;
 ai_protocol: IPPROTO;
 ai_addrlen: socklen_t;
 ai_canonname: *u8;
 ai_addr: *sockaddr;
 ai_next: *addrinfo;
}

getaddrinfo :: (__node: *u8, __service: *u8, __hints: *addrinfo, __result: **addrinfo) -> s32 #foreign libc;
freeaddrinfo :: (__ptr: *addrinfo) -> void #foreign libc;

getnameinfo :: (__sa: *sockaddr, __sa_length: socklen_t, __host: *u8, __host_length: u64, __service: *u8, __service_length: u64, __flags: s32) -> s32 #foreign libc;
gai_strerror :: (__error: s32) -> *u8 #foreign libc;

__get_h_errno :: () -> *s32 #foreign libc;
herror :: (__s: *u8) -> void #foreign libc;
hstrerror :: (__error: s32) -> *u8 #foreign libc;
gethostbyaddr :: (__addr: *void, __length: socklen_t, __type: s32) -> *hostent #foreign libc;

gethostbyaddr_r :: (__addr: *void, __length: socklen_t, __type: s32, __ret: *hostent, __buf: *u8, __buf_size: u64, __result: **hostent, __h_errno_ptr: *s32) -> s32 #foreign libc;

gethostbyname :: (__name: *u8) -> *hostent #foreign libc;
gethostbyname_r :: (__name: *u8, __ret: *hostent, __buf: *u8, __buf_size: u64, __result: **hostent, __h_errno_ptr: *s32) -> s32 #foreign libc;
gethostbyname2 :: (__name: *u8, __af: s32) -> *hostent #foreign libc;

gethostbyname2_r :: (__name: *u8, __af: s32, __ret: *hostent, __buf: *u8, __buf_size: u64, __result: **hostent, __h_errno_ptr: *s32) -> s32 #foreign libc;

endhostent :: () -> void #foreign libc;

gethostent :: () -> *hostent #foreign libc;

sethostent :: (__stay_open: s32) -> void #foreign libc;

endnetent :: () -> void #foreign libc;

getnetbyaddr :: (__net: u32, __type: s32) -> *netent #foreign libc;
getnetbyname :: (__name: *u8) -> *netent #foreign libc;

getnetent :: () -> *netent #foreign libc;
setnetent :: (__stay_open: s32) -> void #foreign libc;

endprotoent :: () -> void #foreign libc;

getprotobyname :: (__name: *u8) -> *protoent #foreign libc;
getprotobynumber :: (__proto: s32) -> *protoent #foreign libc;

getprotoent :: () -> *protoent #foreign libc;
setprotoent :: (__stay_open: s32) -> void #foreign libc;

endservent :: () -> void #foreign libc;
getservbyname :: (__name: *u8, __proto: *u8) -> *servent #foreign libc;
getservbyport :: (__port_in_network_order: s32, __proto: *u8) -> *servent #foreign libc;
getservent :: () -> *servent #foreign libc;
setservent :: (__stay_open: s32) -> void #foreign libc;

inet_addr :: (__s: *u8) -> in_addr_t #foreign libc;
inet_aton :: (__s: *u8, __addr: *in_addr) -> s32 #foreign libc;

inet_lnaof :: (__addr: in_addr) -> in_addr_t #foreign libc;
inet_makeaddr :: (__net: in_addr_t, __host: in_addr_t) -> in_addr #foreign libc;
inet_netof :: (__addr: in_addr) -> in_addr_t #foreign libc;
inet_network :: (__s: *u8) -> in_addr_t #foreign libc;

inet_ntoa :: (__addr: in_addr) -> *u8 #foreign libc;
inet_ntop :: (__af: s32, __src: *void, __dst: *u8, __size: socklen_t) -> *u8 #foreign libc;
inet_nsap_addr :: (__ascii: *u8, __binary: *u8, __n: s32) -> u32 #foreign libc;
inet_nsap_ntoa :: (__binary_length: s32, __binary: *u8, __ascii: *u8) -> *u8 #foreign libc;
inet_pton :: (__af: s32, __src: *u8, __dst: *void) -> s32 #foreign libc;

if_nameindex :: struct {
 if_index: u32;
 if_name: *u8;
}

if_indextoname :: (__index: u32, __buf: *u8) -> *u8 #foreign libc;
if_nametoindex :: (__name: *u8) -> u32 #foreign libc;

if_nameindex_ :: () -> *if_nameindex #foreign libc "if_nameindex";
if_freenameindex :: (__ptr: *if_nameindex) -> void #foreign libc;

ifaddrs :: struct {

 ifa_next: *ifaddrs;

 ifa_name: *u8;

 ifa_flags: u32;

 ifa_addr: *sockaddr;

 ifa_netmask: *sockaddr;

 ifa_ifu: union {

 ifu_broadaddr: *sockaddr;

 ifu_dstaddr: *sockaddr;
 };

 ifa_data: *void;
}

getifaddrs :: (__list_ptr: **ifaddrs) -> s32 #foreign libc;

freeifaddrs :: (__ptr: *ifaddrs) -> void #foreign libc;

fd_mask :: u64;

fd_set :: struct {
 fds_bits: [16] fd_mask;
}

__FD_CLR_chk :: (unknown0: s32, unknown1: *fd_set, unknown2: u64) -> void #foreign libc;
__FD_SET_chk :: (unknown0: s32, unknown1: *fd_set, unknown2: u64) -> void #foreign libc;
__FD_ISSET_chk :: (unknown0: s32, unknown1: *fd_set, unknown2: u64) -> s32 #foreign libc;

select :: (__max_fd_plus_one: s32, __read_fds: *fd_set, __write_fds: *fd_set, __exception_fds: *fd_set, __timeout: *timeval) -> s32 #foreign libc;

pselect :: (__max_fd_plus_one: s32, __read_fds: *fd_set, __write_fds: *fd_set, __exception_fds: *fd_set, __timeout: *timespec, __mask: *sigset_t) -> s32 #foreign libc;

pselect64 :: (__max_fd_plus_one: s32, __read_fds: *fd_set, __write_fds: *fd_set, __exception_fds: *fd_set, __timeout: *timespec, __mask: *sigset64_t) -> s32 #foreign libc;

#scope_file

libc :: #system_library "c";
