// Public SDK interface transcription; executable code is the system SDK.
INCL_WINSOCK_API_PROTOTYPES :: 1;

INCL_WINSOCK_API_TYPEDEFS :: 0;

AF_UNSPEC :: 0;
AF_UNIX :: 1;
AF_INET :: 2;
AF_IMPLINK :: 3;
AF_PUP :: 4;
AF_CHAOS :: 5;
AF_NS :: 6;
AF_IPX :: AF_NS;
AF_ISO :: 7;
AF_OSI :: AF_ISO;
AF_ECMA :: 8;
AF_DATAKIT :: 9;
AF_CCITT :: 10;
AF_SNA :: 11;
AF_DECnet :: 12;
AF_DLI :: 13;
AF_LAT :: 14;
AF_HYLINK :: 15;
AF_APPLETALK :: 16;
AF_NETBIOS :: 17;
AF_VOICEVIEW :: 18;
AF_FIREFOX :: 19;
AF_UNKNOWN1 :: 20;
AF_BAN :: 21;
AF_ATM :: 22;
AF_INET6 :: 23;
AF_CLUSTER :: 24;
AF_12844 :: 25;
AF_IRDA :: 26;
AF_NETDES :: 28;

AF_TCNPROCESS :: 29;
AF_TCNMESSAGE :: 30;
AF_ICLFXBM :: 31;

AF_BTH :: 32;

AF_LINK :: 33;

AF_HYPERV :: 34;
AF_MAX :: 35;

SOCK :: enum s32 {
    STREAM :: 1;
    DGRAM :: 2;
    RAW :: 3;
    RDM :: 4;
    SEQPACKET :: 5;

    SOCK_STREAM :: STREAM;
    SOCK_DGRAM :: DGRAM;
    SOCK_RAW :: RAW;
    SOCK_RDM :: RDM;
    SOCK_SEQPACKET :: SEQPACKET;
}

SOL_SOCKET :: 0xffff;
SOL_IP :: SOL_SOCKET - 4;
SOL_IPV6 :: SOL_SOCKET - 5;

SO_DEBUG :: 0x0001;
SO_ACCEPTCONN :: 0x0002;
SO_REUSEADDR :: 0x0004;
SO_KEEPALIVE :: 0x0008;
SO_DONTROUTE :: 0x0010;
SO_BROADCAST :: 0x0020;
SO_USELOOPBACK :: 0x0040;
SO_LINGER :: 0x0080;
SO_OOBINLINE :: 0x0100;

SO_DONTLINGER :: cast,trunc(s32) (~SO_LINGER);
SO_EXCLUSIVEADDRUSE :: cast,trunc(s32) (~SO_REUSEADDR);

SO_SNDBUF :: 0x1001;
SO_RCVBUF :: 0x1002;
SO_SNDLOWAT :: 0x1003;
SO_RCVLOWAT :: 0x1004;
SO_SNDTIMEO :: 0x1005;
SO_RCVTIMEO :: 0x1006;
SO_ERROR :: 0x1007;
SO_TYPE :: 0x1008;
SO_BSP_STATE :: 0x1009;

SO_GROUP_ID :: 0x2001;
SO_GROUP_PRIORITY :: 0x2002;
SO_MAX_MSG_SIZE :: 0x2003;

SO_CONDITIONAL_ACCEPT :: 0x3002;

SO_PAUSE_ACCEPT :: 0x3003;
SO_COMPARTMENT_ID :: 0x3004;

SO_RANDOMIZE_PORT :: 0x3005;
SO_PORT_SCALABILITY :: 0x3006;
SO_REUSE_UNICASTPORT :: 0x3007;

SO_REUSE_MULTICASTPORT :: 0x3008;

SO_ORIGINAL_DST :: 0x300F;

IP6T_SO_ORIGINAL_DST :: SO_ORIGINAL_DST;

WSK_SO_BASE :: 0x4000;

TCP_NODELAY :: 0x0001;

_SS_MAXSIZE :: 128;

IOC_UNIX :: 0x00000000;
IOC_WS2 :: 0x08000000;
IOC_PROTOCOL :: 0x10000000;
IOC_VENDOR :: 0x18000000;

IOC_WSK :: IOC_WS2 | 0x07000000;

IPPROTO_IP :: 0;

IPPORT_TCPMUX :: 1;
IPPORT_ECHO :: 7;
IPPORT_DISCARD :: 9;
IPPORT_SYSTAT :: 11;
IPPORT_DAYTIME :: 13;
IPPORT_NETSTAT :: 15;
IPPORT_QOTD :: 17;
IPPORT_MSP :: 18;
IPPORT_CHARGEN :: 19;
IPPORT_FTP_DATA :: 20;
IPPORT_FTP :: 21;
IPPORT_TELNET :: 23;
IPPORT_SMTP :: 25;
IPPORT_TIMESERVER :: 37;
IPPORT_NAMESERVER :: 42;
IPPORT_WHOIS :: 43;
IPPORT_MTP :: 57;

IPPORT_TFTP :: 69;
IPPORT_RJE :: 77;
IPPORT_FINGER :: 79;
IPPORT_TTYLINK :: 87;
IPPORT_SUPDUP :: 95;

IPPORT_POP3 :: 110;
IPPORT_NTP :: 123;
IPPORT_EPMAP :: 135;
IPPORT_NETBIOS_NS :: 137;
IPPORT_NETBIOS_DGM :: 138;
IPPORT_NETBIOS_SSN :: 139;
IPPORT_IMAP :: 143;
IPPORT_SNMP :: 161;
IPPORT_SNMP_TRAP :: 162;
IPPORT_IMAP3 :: 220;
IPPORT_LDAP :: 389;
IPPORT_HTTPS :: 443;
IPPORT_MICROSOFT_DS :: 445;
IPPORT_EXECSERVER :: 512;
IPPORT_LOGINSERVER :: 513;
IPPORT_CMDSERVER :: 514;
IPPORT_EFSSERVER :: 520;

IPPORT_BIFFUDP :: 512;
IPPORT_WHOSERVER :: 513;
IPPORT_ROUTESERVER :: 520;

IPPORT_RESERVED :: 1024;

IPPORT_REGISTERED_MIN :: IPPORT_RESERVED;
IPPORT_REGISTERED_MAX :: 0xbfff;
IPPORT_DYNAMIC_MIN :: 0xc000;
IPPORT_DYNAMIC_MAX :: 0xffff;

IN_CLASSA_NET :: 0xff000000;
IN_CLASSA_NSHIFT :: 24;
IN_CLASSA_HOST :: 0x00ffffff;
IN_CLASSA_MAX :: 128;

IN_CLASSB_NET :: 0xffff0000;
IN_CLASSB_NSHIFT :: 16;
IN_CLASSB_HOST :: 0x0000ffff;
IN_CLASSB_MAX :: 65536;

IN_CLASSC_NET :: 0xffffff00;
IN_CLASSC_NSHIFT :: 8;
IN_CLASSC_HOST :: 0x000000ff;

IN_CLASSD_NET :: 0xf0000000;
IN_CLASSD_NSHIFT :: 28;
IN_CLASSD_HOST :: 0x0fffffff;

INADDR_ANY :: cast(u32) 0x00000000;
INADDR_LOOPBACK :: 0x7f000001;
INADDR_BROADCAST :: cast(u32) 0xffffffff;
INADDR_NONE :: 0xffffffff;

IOCPARM_MASK :: 0x7f;
IOC_VOID :: 0x20000000;
IOC_OUT :: 0x40000000;
IOC_IN :: 0x80000000;
IOC_INOUT :: IOC_IN | IOC_OUT;

_WSACMSGHDR :: cmsghdr;

MSG :: enum_flags s32 {
    TRUNC :: 0x0100;
    CTRUNC :: 0x0200;
    BCAST :: 0x0400;
    MCAST :: 0x0800;
    ERRQUEUE :: 0x1000;
    OOB :: 0x1;
    PEEK :: 0x2;
    DONTROUTE :: 0x4;
    WAITALL :: 0x8;
    PUSH_IMMEDIATE :: 0x20;
    PARTIAL :: 0x8000;
    INTERRUPT :: 0x10;
    MAXIOVLEN :: 16;

    MSG_TRUNC :: TRUNC;
    MSG_CTRUNC :: CTRUNC;
    MSG_BCAST :: BCAST;
    MSG_MCAST :: MCAST;
    MSG_ERRQUEUE :: ERRQUEUE;
    MSG_OOB :: OOB;
    MSG_PEEK :: PEEK;
    MSG_DONTROUTE :: DONTROUTE;
    MSG_WAITALL :: WAITALL;
    MSG_PUSH_IMMEDIATE :: PUSH_IMMEDIATE;
    MSG_PARTIAL :: PARTIAL;
    MSG_INTERRUPT :: INTERRUPT;
    MSG_MAXIOVLEN :: MAXIOVLEN;
}

AI :: enum_flags s32 {
    PASSIVE :: 0x00000001;
    CANONNAME :: 0x00000002;
    NUMERICHOST :: 0x00000004;
    NUMERICSERV :: 0x00000008;
    DNS_ONLY :: 0x00000010;
    FORCE_CLEAR_TEXT :: 0x00000020;
    BYPASS_DNS_CACHE :: 0x00000040;
    RETURN_TTL :: 0x00000080;
    ALL :: 0x00000100;
    ADDRCONFIG :: 0x00000400;
    V4MAPPED :: 0x00000800;
    NON_AUTHORITATIVE :: 0x00004000;
    SECURE :: 0x00008000;
    RETURN_PREFERRED_NAMES :: 0x00010000;
    FQDN :: 0x00020000;
    FILESERVER :: 0x00040000;
    DISABLE_IDN_ENCODING :: 0x00080000;
    SECURE_WITH_FALLBACK :: 0x00100000;
    EXCLUSIVE_CUSTOM_SERVERS :: 0x00200000;
    RETURN_RESPONSE_FLAGS :: 0x10000000;
    REQUIRE_SECURE :: 0x20000000;
    RESOLUTION_HANDLE :: 0x40000000;
    EXTENDED :: 0x80000000;
    DNS_SERVER_TYPE_UDP :: 0x1;
    DNS_SERVER_TYPE_DOH :: 0x2;
    DNS_SERVER_UDP_FALLBACK :: 0x1;
    DNS_RESPONSE_SECURE :: 0x1;
    DNS_RESPONSE_HOSTFILE :: 0x2;

    AI_PASSIVE :: PASSIVE;
    AI_CANONNAME :: CANONNAME;
    AI_NUMERICHOST :: NUMERICHOST;
    AI_NUMERICSERV :: NUMERICSERV;
    AI_DNS_ONLY :: DNS_ONLY;
    AI_FORCE_CLEAR_TEXT :: FORCE_CLEAR_TEXT;
    AI_BYPASS_DNS_CACHE :: BYPASS_DNS_CACHE;
    AI_RETURN_TTL :: RETURN_TTL;
    AI_ALL :: ALL;
    AI_ADDRCONFIG :: ADDRCONFIG;
    AI_V4MAPPED :: V4MAPPED;
    AI_NON_AUTHORITATIVE :: NON_AUTHORITATIVE;
    AI_SECURE :: SECURE;
    AI_RETURN_PREFERRED_NAMES :: RETURN_PREFERRED_NAMES;
    AI_FQDN :: FQDN;
    AI_FILESERVER :: FILESERVER;
    AI_DISABLE_IDN_ENCODING :: DISABLE_IDN_ENCODING;
    AI_SECURE_WITH_FALLBACK :: SECURE_WITH_FALLBACK;
    AI_EXCLUSIVE_CUSTOM_SERVERS :: EXCLUSIVE_CUSTOM_SERVERS;
    AI_RETURN_RESPONSE_FLAGS :: RETURN_RESPONSE_FLAGS;
    AI_REQUIRE_SECURE :: REQUIRE_SECURE;
    AI_RESOLUTION_HANDLE :: RESOLUTION_HANDLE;
    AI_EXTENDED :: EXTENDED;
    AI_DNS_SERVER_TYPE_UDP :: DNS_SERVER_TYPE_UDP;
    AI_DNS_SERVER_TYPE_DOH :: DNS_SERVER_TYPE_DOH;
    AI_DNS_SERVER_UDP_FALLBACK :: DNS_SERVER_UDP_FALLBACK;
    AI_DNS_RESPONSE_SECURE :: DNS_RESPONSE_SECURE;
    AI_DNS_RESPONSE_HOSTFILE :: DNS_RESPONSE_HOSTFILE;
}

ADDRINFOEX_VERSION_2 :: 2;
ADDRINFOEX_VERSION_3 :: 3;
ADDRINFOEX_VERSION_4 :: 4;
ADDRINFOEX_VERSION_5 :: 5;
ADDRINFOEX_VERSION_6 :: 6;

NS_ALL :: 0;

NS_SAP :: 1;
NS_NDS :: 2;
NS_PEER_BROWSE :: 3;
NS_SLP :: 5;
NS_DHCP :: 6;

NS_TCPIP_LOCAL :: 10;
NS_TCPIP_HOSTS :: 11;
NS_DNS :: 12;
NS_NETBT :: 13;
NS_WINS :: 14;

NS_NLA :: 15;

NS_BTH :: 16;

NS_NBP :: 20;

NS_MS :: 30;
NS_STDA :: 31;
NS_NTDS :: 32;

NS_EMAIL :: 37;
NS_PNRPNAME :: 38;
NS_PNRPCLOUD :: 39;

NS_X500 :: 40;
NS_NIS :: 41;
NS_NISPLUS :: 42;

NS_WRQ :: 50;

NS_NETDES :: 60;

NI_NOFQDN :: 0x01;
NI_NUMERICHOST :: 0x02;
NI_NAMEREQD :: 0x04;
NI_NUMERICSERV :: 0x08;
NI_DGRAM :: 0x10;

NI_MAXHOST :: 1025;
NI_MAXSERV :: 32;

FD_SETSIZE :: 64;

IMPLINK_IP :: 155;
IMPLINK_LOWEXPER :: 156;
IMPLINK_HIGHEXPER :: 158;

ADDR_ANY :: INADDR_ANY;

WSADESCRIPTION_LEN :: 256;
WSASYS_STATUS_LEN :: 128;

INVALID_SOCKET :: cast,trunc(SOCKET) (~0);
SOCKET_ERROR :: -1;

FROM_PROTOCOL_INFO :: -1;

SO_PROTOCOL_INFOA :: 0x2004;
SO_PROTOCOL_INFOW :: 0x2005;

SO_PROTOCOL_INFO :: SO_PROTOCOL_INFOA;

PVD_CONFIG :: 0x3001;

PF_UNSPEC :: AF_UNSPEC;
PF_UNIX :: AF_UNIX;
PF_INET :: AF_INET;
PF_IMPLINK :: AF_IMPLINK;
PF_PUP :: AF_PUP;
PF_CHAOS :: AF_CHAOS;
PF_NS :: AF_NS;
PF_IPX :: AF_IPX;
PF_ISO :: AF_ISO;
PF_OSI :: AF_OSI;
PF_ECMA :: AF_ECMA;
PF_DATAKIT :: AF_DATAKIT;
PF_CCITT :: AF_CCITT;
PF_SNA :: AF_SNA;
PF_DECnet :: AF_DECnet;
PF_DLI :: AF_DLI;
PF_LAT :: AF_LAT;
PF_HYLINK :: AF_HYLINK;
PF_APPLETALK :: AF_APPLETALK;
PF_VOICEVIEW :: AF_VOICEVIEW;
PF_FIREFOX :: AF_FIREFOX;
PF_UNKNOWN1 :: AF_UNKNOWN1;
PF_BAN :: AF_BAN;
PF_ATM :: AF_ATM;
PF_INET6 :: AF_INET6;

PF_BTH :: AF_BTH;

PF_MAX :: AF_MAX;

SOMAXCONN :: 0x7fffffff;

MAXGETHOSTSTRUCT :: 1024;

FD_READ_BIT :: 0;
FD_READ :: 1 << FD_READ_BIT;

FD_WRITE_BIT :: 1;
FD_WRITE :: 1 << FD_WRITE_BIT;

FD_OOB_BIT :: 2;
FD_OOB :: 1 << FD_OOB_BIT;

FD_ACCEPT_BIT :: 3;
FD_ACCEPT :: 1 << FD_ACCEPT_BIT;

FD_CONNECT_BIT :: 4;
FD_CONNECT :: 1 << FD_CONNECT_BIT;

FD_CLOSE_BIT :: 5;
FD_CLOSE :: 1 << FD_CLOSE_BIT;

FD_QOS_BIT :: 6;
FD_QOS :: 1 << FD_QOS_BIT;

FD_GROUP_QOS_BIT :: 7;
FD_GROUP_QOS :: 1 << FD_GROUP_QOS_BIT;

FD_ROUTING_INTERFACE_CHANGE_BIT :: 8;
FD_ROUTING_INTERFACE_CHANGE :: 1 << FD_ROUTING_INTERFACE_CHANGE_BIT;

FD_ADDRESS_LIST_CHANGE_BIT :: 9;
FD_ADDRESS_LIST_CHANGE :: 1 << FD_ADDRESS_LIST_CHANGE_BIT;

FD_MAX_EVENTS :: 10;
FD_ALL_EVENTS :: (1 << FD_MAX_EVENTS) - 1;

SERVICETYPE_NOTRAFFIC :: 0x00000000;

SERVICETYPE_BESTEFFORT :: 0x00000001;
SERVICETYPE_CONTROLLEDLOAD :: 0x00000002;
SERVICETYPE_GUARANTEED :: 0x00000003;

SERVICETYPE_NETWORK_UNAVAILABLE :: 0x00000004;

SERVICETYPE_GENERAL_INFORMATION :: 0x00000005;

SERVICETYPE_NOCHANGE :: 0x00000006;

SERVICETYPE_NONCONFORMING :: 0x00000009;
SERVICETYPE_NETWORK_CONTROL :: 0x0000000A;
SERVICETYPE_QUALITATIVE :: 0x0000000D;

SERVICE_BESTEFFORT :: 0x80010000;
SERVICE_CONTROLLEDLOAD :: 0x80020000;
SERVICE_GUARANTEED :: 0x80040000;
SERVICE_QUALITATIVE :: 0x80200000;

SERVICE_NO_TRAFFIC_CONTROL :: 0x81000000;

SERVICE_NO_QOS_SIGNALING :: 0x40000000;

QOS_NOT_SPECIFIED :: 0xFFFFFFFF;

POSITIVE_INFINITY_RATE :: 0xFFFFFFFE;

QOS_GENERAL_ID_BASE :: 2000;

QOS_OBJECT_END_OF_LIST :: 0x00000001 + QOS_GENERAL_ID_BASE;

QOS_OBJECT_SD_MODE :: 0x00000002 + QOS_GENERAL_ID_BASE;

QOS_OBJECT_SHAPING_RATE :: 0x00000003 + QOS_GENERAL_ID_BASE;

QOS_OBJECT_DESTADDR :: 0x00000004 + QOS_GENERAL_ID_BASE;

TC_NONCONF_BORROW :: 0;
TC_NONCONF_SHAPE :: 1;
TC_NONCONF_DISCARD :: 2;
TC_NONCONF_BORROW_PLUS :: 3;

CF_ACCEPT :: 0x0000;
CF_REJECT :: 0x0001;
CF_DEFER :: 0x0002;

SD_RECEIVE :: 0x00;
SD_SEND :: 0x01;
SD_BOTH :: 0x02;

SG_UNCONSTRAINED_GROUP :: 0x01;
SG_CONSTRAINED_GROUP :: 0x02;

MAX_PROTOCOL_CHAIN :: 7;

BASE_PROTOCOL :: 1;
LAYERED_PROTOCOL :: 0;

WSAPROTOCOL_LEN :: 255;

PFL_MULTIPLE_PROTO_ENTRIES :: 0x00000001;
PFL_RECOMMENDED_PROTO_ENTRY :: 0x00000002;
PFL_HIDDEN :: 0x00000004;
PFL_MATCHES_PROTOCOL_ZERO :: 0x00000008;
PFL_NETWORKDIRECT_PROVIDER :: 0x00000010;

XP1_CONNECTIONLESS :: 0x00000001;
XP1_GUARANTEED_DELIVERY :: 0x00000002;
XP1_GUARANTEED_ORDER :: 0x00000004;
XP1_MESSAGE_ORIENTED :: 0x00000008;
XP1_PSEUDO_STREAM :: 0x00000010;
XP1_GRACEFUL_CLOSE :: 0x00000020;
XP1_EXPEDITED_DATA :: 0x00000040;
XP1_CONNECT_DATA :: 0x00000080;
XP1_DISCONNECT_DATA :: 0x00000100;
XP1_SUPPORT_BROADCAST :: 0x00000200;
XP1_SUPPORT_MULTIPOINT :: 0x00000400;
XP1_MULTIPOINT_CONTROL_PLANE :: 0x00000800;
XP1_MULTIPOINT_DATA_PLANE :: 0x00001000;
XP1_QOS_SUPPORTED :: 0x00002000;
XP1_INTERRUPT :: 0x00004000;
XP1_UNI_SEND :: 0x00008000;
XP1_UNI_RECV :: 0x00010000;
XP1_IFS_HANDLES :: 0x00020000;
XP1_PARTIAL_MESSAGE :: 0x00040000;
XP1_SAN_SUPPORT_SDP :: 0x00080000;

BIGENDIAN :: 0x0000;
LITTLEENDIAN :: 0x0001;

SECURITY_PROTOCOL_NONE :: 0x0000;

JL_SENDER_ONLY :: 0x01;
JL_RECEIVER_ONLY :: 0x02;
JL_BOTH :: 0x04;

WSA_FLAG_OVERLAPPED :: 0x01;
WSA_FLAG_MULTIPOINT_C_ROOT :: 0x02;
WSA_FLAG_MULTIPOINT_C_LEAF :: 0x04;
WSA_FLAG_MULTIPOINT_D_ROOT :: 0x08;
WSA_FLAG_MULTIPOINT_D_LEAF :: 0x10;
WSA_FLAG_ACCESS_SYSTEM_SECURITY :: 0x40;
WSA_FLAG_NO_HANDLE_INHERIT :: 0x80;
WSA_FLAG_REGISTERED_IO :: 0x100;

TH_NETDEV :: 0x00000001;
TH_TAPI :: 0x00000002;

SERVICE_MULTIPLE :: 0x00000001;

NS_LOCALNAME :: 19;

RES_UNUSED_1 :: 0x00000001;
RES_FLUSH_CACHE :: 0x00000002;

RES_SERVICE :: 0x00000004;

SERVICE_TYPE_VALUE_IPXPORTA :: "IpxSocket";

SERVICE_TYPE_VALUE_SAPIDA :: "SapId";

SERVICE_TYPE_VALUE_TCPPORTA :: "TcpPort";

SERVICE_TYPE_VALUE_UDPPORTA :: "UdpPort";

SERVICE_TYPE_VALUE_OBJECTIDA :: "ObjectId";

SERVICE_TYPE_VALUE_SAPID :: SERVICE_TYPE_VALUE_SAPIDA;
SERVICE_TYPE_VALUE_TCPPORT :: SERVICE_TYPE_VALUE_TCPPORTA;
SERVICE_TYPE_VALUE_UDPPORT :: SERVICE_TYPE_VALUE_UDPPORTA;
SERVICE_TYPE_VALUE_OBJECTID :: SERVICE_TYPE_VALUE_OBJECTIDA;

LUP_DEEP :: 0x00000001;
LUP_CONTAINERS :: 0x00000002;
LUP_NOCONTAINERS :: 0x00000004;
LUP_NEAREST :: 0x00000008;
LUP_RETURN_NAME :: 0x00000010;
LUP_RETURN_TYPE :: 0x00000020;
LUP_RETURN_VERSION :: 0x00000040;
LUP_RETURN_COMMENT :: 0x00000080;
LUP_RETURN_ADDR :: 0x00000100;
LUP_RETURN_BLOB :: 0x00000200;
LUP_RETURN_ALIASES :: 0x00000400;
LUP_RETURN_QUERY_STRING :: 0x00000800;
LUP_RETURN_ALL :: 0x00000FF0;
LUP_RES_SERVICE :: 0x00008000;

LUP_FLUSHCACHE :: 0x00001000;
LUP_FLUSHPREVIOUS :: 0x00002000;

LUP_NON_AUTHORITATIVE :: 0x00004000;
LUP_SECURE :: 0x00008000;
LUP_RETURN_PREFERRED_NAMES :: 0x00010000;
LUP_DNS_ONLY :: 0x00020000;
LUP_RETURN_RESPONSE_FLAGS :: 0x00040000;

LUP_ADDRCONFIG :: 0x00100000;
LUP_DUAL_ADDR :: 0x00200000;
LUP_FILESERVER :: 0x00400000;
LUP_DISABLE_IDN_ENCODING :: 0x00800000;
LUP_API_ANSI :: 0x01000000;

LUP_EXTENDED_QUERYSET :: 0x02000000;
LUP_SECURE_WITH_FALLBACK :: 0x04000000;
LUP_EXCLUSIVE_CUSTOM_SERVERS :: 0x08000000;
LUP_REQUIRE_SECURE :: 0x10000000;
LUP_RETURN_TTL :: 0x20000000;
LUP_FORCE_CLEAR_TEXT :: 0x40000000;
LUP_RESOLUTION_HANDLE :: 0x80000000;

RESULT_IS_ALIAS :: 0x0001;

RESULT_IS_ADDED :: 0x0010;
RESULT_IS_CHANGED :: 0x0020;
RESULT_IS_DELETED :: 0x0040;

POLLRDNORM :: 0x0100;
POLLRDBAND :: 0x0200;
POLLIN :: POLLRDNORM | POLLRDBAND;
POLLPRI :: 0x0400;

POLLWRNORM :: 0x0010;
POLLOUT :: POLLWRNORM;
POLLWRBAND :: 0x0020;

POLLERR :: 0x0001;
POLLHUP :: 0x0002;
POLLNVAL :: 0x0004;

WSAConnectByName :: WSAConnectByNameA;

WSADuplicateSocket :: WSADuplicateSocketA;

WSAEnumProtocols :: WSAEnumProtocolsA;

WSASocket :: WSASocketA;

WSAAddressToString :: WSAAddressToStringA;

WSAStringToAddress :: WSAStringToAddressA;

WSAInstallServiceClass :: WSAInstallServiceClassA;

WSAGetServiceClassInfo :: WSAGetServiceClassInfoA;

WSAGetServiceClassNameByClassId :: WSAGetServiceClassNameByClassIdA;

SOCK_NOTIFY_REGISTER_EVENT_NONE :: 0x00;
SOCK_NOTIFY_REGISTER_EVENT_IN :: 0x01;
SOCK_NOTIFY_REGISTER_EVENT_OUT :: 0x02;
SOCK_NOTIFY_REGISTER_EVENT_HANGUP :: 0x04;

SOCK_NOTIFY_REGISTER_EVENTS_ALL :: SOCK_NOTIFY_REGISTER_EVENT_IN | SOCK_NOTIFY_REGISTER_EVENT_OUT | SOCK_NOTIFY_REGISTER_EVENT_HANGUP;

SOCK_NOTIFY_EVENT_IN :: SOCK_NOTIFY_REGISTER_EVENT_IN;
SOCK_NOTIFY_EVENT_OUT :: SOCK_NOTIFY_REGISTER_EVENT_OUT;
SOCK_NOTIFY_EVENT_HANGUP :: SOCK_NOTIFY_REGISTER_EVENT_HANGUP;
SOCK_NOTIFY_EVENT_ERR :: 0x40;
SOCK_NOTIFY_EVENT_REMOVE :: 0x80;

SOCK_NOTIFY_EVENTS_ALL :: SOCK_NOTIFY_REGISTER_EVENTS_ALL | SOCK_NOTIFY_EVENT_ERR | SOCK_NOTIFY_EVENT_REMOVE;

SOCK_NOTIFY_OP_NONE :: 0x00;
SOCK_NOTIFY_OP_ENABLE :: 0x01;
SOCK_NOTIFY_OP_DISABLE :: 0x02;
SOCK_NOTIFY_OP_REMOVE :: 0x04;

SOCK_NOTIFY_TRIGGER_ONESHOT :: 0x01;
SOCK_NOTIFY_TRIGGER_PERSISTENT :: 0x02;
SOCK_NOTIFY_TRIGGER_LEVEL :: 0x04;
SOCK_NOTIFY_TRIGGER_EDGE :: 0x08;

SOCK_NOTIFY_TRIGGER_ALL :: SOCK_NOTIFY_TRIGGER_ONESHOT | SOCK_NOTIFY_TRIGGER_PERSISTENT | SOCK_NOTIFY_TRIGGER_LEVEL | SOCK_NOTIFY_TRIGGER_EDGE;

in_addr6 :: in6_addr;

IFF_UP :: 0x00000001;
IFF_BROADCAST :: 0x00000002;
IFF_LOOPBACK :: 0x00000004;
IFF_POINTTOPOINT :: 0x00000008;
IFF_MULTICAST :: 0x00000010;

IP_OPTIONS :: 1;
IP_HDRINCL :: 2;
IP_TOS :: 3;
IP_TTL :: 4;
IP_MULTICAST_IF :: 9;
IP_MULTICAST_TTL :: 10;
IP_MULTICAST_LOOP :: 11;
IP_ADD_MEMBERSHIP :: 12;
IP_DROP_MEMBERSHIP :: 13;
IP_DONTFRAGMENT :: 14;
IP_ADD_SOURCE_MEMBERSHIP :: 15;
IP_DROP_SOURCE_MEMBERSHIP :: 16;
IP_BLOCK_SOURCE :: 17;
IP_UNBLOCK_SOURCE :: 18;
IP_PKTINFO :: 19;
IP_HOPLIMIT :: 21;
IP_RECVTTL :: 21;
IP_RECEIVE_BROADCAST :: 22;
IP_RECVIF :: 24;
IP_RECVDSTADDR :: 25;
IP_IFLIST :: 28;
IP_ADD_IFLIST :: 29;
IP_DEL_IFLIST :: 30;
IP_UNICAST_IF :: 31;
IP_RTHDR :: 32;
IP_GET_IFLIST :: 33;
IP_RECVRTHDR :: 38;
IP_TCLASS :: 39;
IP_RECVTCLASS :: 40;
IP_RECVTOS :: 40;
IP_ORIGINAL_ARRIVAL_IF :: 47;
IP_ECN :: 50;
IP_RECVECN :: 50;
IP_PKTINFO_EX :: 51;
IP_WFP_REDIRECT_RECORDS :: 60;
IP_WFP_REDIRECT_CONTEXT :: 70;
IP_MTU_DISCOVER :: 71;
IP_MTU :: 73;
IP_NRT_INTERFACE :: 74;
IP_RECVERR :: 75;
IP_USER_MTU :: 76;

IP_UNSPECIFIED_TYPE_OF_SERVICE :: -1;

IN6ADDR_LINKLOCALPREFIX_LENGTH :: 64;

IN6ADDR_MULTICASTPREFIX_LENGTH :: 8;

IN6ADDR_SOLICITEDNODEMULTICASTPREFIX_LENGTH :: 104;

IN6ADDR_V4MAPPEDPREFIX_LENGTH :: 96;

IN6ADDR_6TO4PREFIX_LENGTH :: 16;

IN6ADDR_TEREDOPREFIX_LENGTH :: 32;

MCAST_JOIN_GROUP :: 41;
MCAST_LEAVE_GROUP :: 42;
MCAST_BLOCK_SOURCE :: 43;
MCAST_UNBLOCK_SOURCE :: 44;
MCAST_JOIN_SOURCE_GROUP :: 45;
MCAST_LEAVE_SOURCE_GROUP :: 46;

IPV6_HOPOPTS :: 1;
IPV6_HDRINCL :: 2;
IPV6_UNICAST_HOPS :: 4;
IPV6_MULTICAST_IF :: 9;
IPV6_MULTICAST_HOPS :: 10;
IPV6_MULTICAST_LOOP :: 11;
IPV6_ADD_MEMBERSHIP :: 12;
IPV6_JOIN_GROUP :: IPV6_ADD_MEMBERSHIP;
IPV6_DROP_MEMBERSHIP :: 13;
IPV6_LEAVE_GROUP :: IPV6_DROP_MEMBERSHIP;
IPV6_DONTFRAG :: 14;
IPV6_PKTINFO :: 19;
IPV6_HOPLIMIT :: 21;
IPV6_PROTECTION_LEVEL :: 23;
IPV6_RECVIF :: 24;
IPV6_RECVDSTADDR :: 25;
IPV6_CHECKSUM :: 26;
IPV6_V6ONLY :: 27;
IPV6_IFLIST :: 28;
IPV6_ADD_IFLIST :: 29;
IPV6_DEL_IFLIST :: 30;
IPV6_UNICAST_IF :: 31;
IPV6_RTHDR :: 32;
IPV6_GET_IFLIST :: 33;
IPV6_RECVRTHDR :: 38;
IPV6_TCLASS :: 39;
IPV6_RECVTCLASS :: 40;
IPV6_ECN :: 50;
IPV6_RECVECN :: 50;
IPV6_PKTINFO_EX :: 51;
IPV6_WFP_REDIRECT_RECORDS :: 60;
IPV6_WFP_REDIRECT_CONTEXT :: 70;
IPV6_MTU_DISCOVER :: 71;
IPV6_MTU :: 72;
IPV6_NRT_INTERFACE :: 74;
IPV6_RECVERR :: 75;
IPV6_USER_MTU :: 76;

IP_UNSPECIFIED_HOP_LIMIT :: -1;

IP_PROTECTION_LEVEL :: IPV6_PROTECTION_LEVEL;

PROTECTION_LEVEL_UNRESTRICTED :: 10;
PROTECTION_LEVEL_EDGERESTRICTED :: 20;

PROTECTION_LEVEL_RESTRICTED :: 30;

PROTECTION_LEVEL_DEFAULT :: cast,trunc(u32) -1;

INET_ADDRSTRLEN :: 22;
INET6_ADDRSTRLEN :: 65;

TCP_OFFLOAD_NO_PREFERENCE :: 0;
TCP_OFFLOAD_NOT_PREFERRED :: 1;
TCP_OFFLOAD_PREFERRED :: 2;

TCP_EXPEDITED_1122 :: 0x0002;
TCP_KEEPALIVE :: 3;
TCP_MAXSEG :: 4;
TCP_MAXRT :: 5;
TCP_STDURG :: 6;
TCP_NOURG :: 7;
TCP_ATMARK :: 8;
TCP_NOSYNRETRIES :: 9;
TCP_TIMESTAMPS :: 10;
TCP_OFFLOAD_PREFERENCE :: 11;
TCP_CONGESTION_ALGORITHM :: 12;
TCP_DELAY_FIN_ACK :: 13;
TCP_MAXRTMS :: 14;
TCP_FASTOPEN :: 15;
TCP_KEEPCNT :: 16;
TCP_KEEPIDLE :: TCP_KEEPALIVE;
TCP_KEEPINTVL :: 17;
TCP_FAIL_CONNECT_ON_ICMP_ERROR :: 18;
TCP_ICMP_ERROR_INFO :: 19;

UDP_SEND_MSG_SIZE :: 2;
UDP_RECV_MAX_COALESCED_SIZE :: 3;

UDP_COALESCED_INFO :: 3;

UDP_NOCHECKSUM :: 1;
UDP_CHECKSUM_COVERAGE :: 20;

GetAddrInfoA :: getaddrinfo;

GetAddrInfo :: GetAddrInfoA;

GetAddrInfoEx :: GetAddrInfoExA;

SetAddrInfoEx :: SetAddrInfoExA;

FreeAddrInfoA :: freeaddrinfo;

FreeAddrInfo :: FreeAddrInfoA;

FreeAddrInfoExA :: FreeAddrInfoEx;

GetNameInfoA :: getnameinfo;

GetNameInfo :: GetNameInfoA;

InetPtonA :: inet_pton;
InetNtopA :: inet_ntop;

InetPton :: InetPtonA;
InetNtop :: InetNtopA;

GAI_STRERROR_BUFFER_SIZE :: 1024;

TIMESTAMPING_FLAG_RX :: 0x1;
TIMESTAMPING_FLAG_TX :: 0x2;

SO_TIMESTAMP :: 0x300A;

SO_TIMESTAMP_ID :: 0x300B;

TCP_INITIAL_RTO_UNSPECIFIED_RTT :: cast,trunc(u16) -1;
TCP_INITIAL_RTO_UNSPECIFIED_MAX_SYN_RETRANSMISSIONS :: cast,trunc(u8) -1;

TCP_INITIAL_RTO_DEFAULT_RTT :: 0;
TCP_INITIAL_RTO_DEFAULT_MAX_SYN_RETRANSMISSIONS :: 0;
TCP_INITIAL_RTO_NO_SYN_RETRANSMISSIONS :: cast,trunc(u8) -2;

INVALID_PORT_RESERVATION_TOKEN :: cast(u64) 0;

SOCKET_SETTINGS_GUARANTEE_ENCRYPTION :: 0x1;
SOCKET_SETTINGS_ALLOW_INSECURE :: 0x2;

SOCKET_SETTINGS_IPSEC_SKIP_FILTER_INSTANTIATION :: 0x1;

SOCKET_SETTINGS_IPSEC_OPTIONAL_PEER_NAME_VERIFICATION :: 0x2;
SOCKET_SETTINGS_IPSEC_ALLOW_FIRST_INBOUND_PKT_UNENCRYPTED :: 0x4;
SOCKET_SETTINGS_IPSEC_PEER_NAME_IS_RAW_FORMAT :: 0x8;

SOCKET_QUERY_IPSEC2_ABORT_CONNECTION_ON_FIELD_CHANGE :: 0x1;

SOCKET_QUERY_IPSEC2_FIELD_MASK_MM_SA_ID :: 0x1;
SOCKET_QUERY_IPSEC2_FIELD_MASK_QM_SA_ID :: 0x2;

SOCKET_INFO_CONNECTION_SECURED :: 0x1;
SOCKET_INFO_CONNECTION_ENCRYPTED :: 0x2;
SOCKET_INFO_CONNECTION_IMPERSONATED :: 0x4;

IN4ADDR_ANY :: INADDR_ANY;
IN4ADDR_LOOPBACK :: 0x0100007f;
IN4ADDR_BROADCAST :: INADDR_BROADCAST;
IN4ADDR_NONE :: INADDR_NONE;

IN4ADDR_LOOPBACKPREFIX_LENGTH :: 8;
IN4ADDR_LINKLOCALPREFIX_LENGTH :: 16;
IN4ADDR_MULTICASTPREFIX_LENGTH :: 4;

u_int64 :: u64;

in_addr :: struct {
    S_un: union {
        S_un_b: struct {
            s_b1: u8;
            s_b2: u8;
            s_b3: u8;
            s_b4: u8;
        };
        S_un_w: struct {
            s_w1: u16;
            s_w2: u16;
        };
        S_addr: u32;
    };
}

IN_ADDR :: in_addr;

ADDRESS_FAMILY :: u16;

sockaddr :: struct {
    sa_family: ADDRESS_FAMILY;

    sa_data: [14] u8;
}

SOCKADDR :: sockaddr;

SOCKET_ADDRESS :: struct {
    lpSockaddr: *sockaddr;

    iSockaddrLength: s32;
}

SOCKET_ADDRESS_LIST :: struct {
    iAddressCount: s32;
    Address: [1] SOCKET_ADDRESS;
}

CSADDR_INFO :: struct {
    LocalAddr: SOCKET_ADDRESS;
    RemoteAddr: SOCKET_ADDRESS;
    iSocketType: s32;
    iProtocol: s32;
}

sockaddr_storage :: struct {
    ss_family: ADDRESS_FAMILY;

    __ss_pad1: [6] u8;

    __ss_align: s64;
    __ss_pad2: [112] u8;
}

SOCKADDR_STORAGE_LH :: sockaddr_storage;

sockaddr_storage_xp :: struct {
    ss_family: s16;

    __ss_pad1: [6] u8;

    __ss_align: s64;
    __ss_pad2: [112] u8;
}

SOCKADDR_STORAGE_XP :: sockaddr_storage_xp;

SOCKADDR_STORAGE :: SOCKADDR_STORAGE_LH;

IPPROTO :: enum s32 {
    HOPOPTS :: 0;
    ICMP :: 1;
    IGMP :: 2;
    GGP :: 3;
    IPV4 :: 4;
    ST :: 5;
    TCP :: 6;
    CBT :: 7;
    EGP :: 8;
    IGP :: 9;
    PUP :: 12;
    UDP :: 17;
    IDP :: 22;
    RDP :: 27;
    IPV6 :: 41;
    ROUTING :: 43;
    FRAGMENT :: 44;
    ESP :: 50;
    AH :: 51;
    ICMPV6 :: 58;
    NONE :: 59;
    DSTOPTS :: 60;
    ND :: 77;
    ICLFXBM :: 78;
    PIM :: 103;
    PGM :: 113;
    L2TP :: 115;
    SCTP :: 132;
    RAW :: 255;
    MAX :: 256;
    RESERVED_RAW :: 257;
    RESERVED_IPSEC :: 258;
    RESERVED_IPSECOFFLOAD :: 259;
    RESERVED_WNV :: 260;
    RESERVED_MAX :: 261;

    IPPROTO_HOPOPTS :: HOPOPTS;
    IPPROTO_ICMP :: ICMP;
    IPPROTO_IGMP :: IGMP;
    IPPROTO_GGP :: GGP;
    IPPROTO_IPV4 :: IPV4;
    IPPROTO_ST :: ST;
    IPPROTO_TCP :: TCP;
    IPPROTO_CBT :: CBT;
    IPPROTO_EGP :: EGP;
    IPPROTO_IGP :: IGP;
    IPPROTO_PUP :: PUP;
    IPPROTO_UDP :: UDP;
    IPPROTO_IDP :: IDP;
    IPPROTO_RDP :: RDP;
    IPPROTO_IPV6 :: IPV6;
    IPPROTO_ROUTING :: ROUTING;
    IPPROTO_FRAGMENT :: FRAGMENT;
    IPPROTO_ESP :: ESP;
    IPPROTO_AH :: AH;
    IPPROTO_ICMPV6 :: ICMPV6;
    IPPROTO_NONE :: NONE;
    IPPROTO_DSTOPTS :: DSTOPTS;
    IPPROTO_ND :: ND;
    IPPROTO_ICLFXBM :: ICLFXBM;
    IPPROTO_PIM :: PIM;
    IPPROTO_PGM :: PGM;
    IPPROTO_L2TP :: L2TP;
    IPPROTO_SCTP :: SCTP;
    IPPROTO_RAW :: RAW;
    IPPROTO_MAX :: MAX;
    IPPROTO_RESERVED_RAW :: RESERVED_RAW;
    IPPROTO_RESERVED_IPSEC :: RESERVED_IPSEC;
    IPPROTO_RESERVED_IPSECOFFLOAD :: RESERVED_IPSECOFFLOAD;
    IPPROTO_RESERVED_WNV :: RESERVED_WNV;
    IPPROTO_RESERVED_MAX :: RESERVED_MAX;
}

SCOPE_LEVEL :: enum s32 {
    Interface :: 1;
    Link :: 2;
    Subnet :: 3;
    Admin :: 4;
    Site :: 5;
    Organization :: 8;
    Global :: 14;
    Count :: 16;

    ScopeLevelInterface :: Interface;
    ScopeLevelLink :: Link;
    ScopeLevelSubnet :: Subnet;
    ScopeLevelAdmin :: Admin;
    ScopeLevelSite :: Site;
    ScopeLevelOrganization :: Organization;
    ScopeLevelGlobal :: Global;
    ScopeLevelCount :: Count;
}

SCOPE_ID :: struct {
    union {
        struct {
            __bitfield: u32;

        }

        Value: u32;
    }
}

sockaddr_in :: struct {
    sin_family: ADDRESS_FAMILY;

    sin_port: u16;
    sin_addr: IN_ADDR;
    sin_zero: [8] u8;
}

SOCKADDR_IN :: sockaddr_in;

sockaddr_dl :: struct {
    sdl_family: ADDRESS_FAMILY;
    sdl_data: [8] u8;
    sdl_zero: [4] u8;
}

SOCKADDR_DL :: sockaddr_dl;

WSABUF :: struct {
    len: u32;
    buf: *u8;
}

WSAMSG :: struct {
    name: *sockaddr;
    namelen: s32;
    lpBuffers: *WSABUF;

    dwBufferCount: u32;

    Control: WSABUF;

    dwFlags: u32;
}

cmsghdr :: struct {
    cmsg_len: SIZE_T;
    cmsg_level: s32;
    cmsg_type: s32;
}

WSACMSGHDR :: cmsghdr;

CMSGHDR :: WSACMSGHDR;

addrinfo :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *u8;
    ai_addr: *sockaddr;
    ai_next: *addrinfo;
}

ADDRINFOA :: addrinfo;

addrinfoW :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *s16;
    ai_addr: *sockaddr;
    ai_next: *addrinfoW;
}

ADDRINFOW :: addrinfoW;

addrinfoexA :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *u8;
    ai_addr: *sockaddr;
    ai_blob: *void;
    ai_bloblen: u64;
    ai_provider: *GUID;
    ai_next: *addrinfoexA;
}

ADDRINFOEXA :: addrinfoexA;

addrinfoexW :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *s16;
    ai_addr: *sockaddr;
    ai_blob: *void;
    ai_bloblen: u64;
    ai_provider: *GUID;
    ai_next: *addrinfoexW;
}

ADDRINFOEXW :: addrinfoexW;

addrinfoex2A :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *u8;
    ai_addr: *sockaddr;
    ai_blob: *void;
    ai_bloblen: u64;
    ai_provider: *GUID;
    ai_next: *addrinfoex2A;
    ai_version: s32;
    ai_fqdn: *u8;
}

ADDRINFOEX2A :: addrinfoex2A;

addrinfoex2W :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *s16;
    ai_addr: *sockaddr;
    ai_blob: *void;
    ai_bloblen: u64;
    ai_provider: *GUID;
    ai_next: *addrinfoex2W;
    ai_version: s32;
    ai_fqdn: *s16;
}

ADDRINFOEX2W :: addrinfoex2W;

addrinfoex3 :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *s16;
    ai_addr: *sockaddr;
    ai_blob: *void;
    ai_bloblen: u64;
    ai_provider: *GUID;
    ai_next: *addrinfoex3;
    ai_version: s32;
    ai_fqdn: *s16;
    ai_interfaceindex: s32;
}

ADDRINFOEX3 :: addrinfoex3;

addrinfoex4 :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *s16;
    ai_addr: *sockaddr;
    ai_blob: *void;
    ai_bloblen: u64;
    ai_provider: *GUID;
    ai_next: *addrinfoex4;
    ai_version: s32;
    ai_fqdn: *s16;
    ai_interfaceindex: s32;
    ai_resolutionhandle: HANDLE;
}

ADDRINFOEX4 :: addrinfoex4;

addrinfoex5 :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *s16;
    ai_addr: *sockaddr;
    ai_blob: *void;
    ai_bloblen: u64;
    ai_provider: *GUID;
    ai_next: *addrinfoex5;
    ai_version: s32;
    ai_fqdn: *s16;
    ai_interfaceindex: s32;
    ai_resolutionhandle: HANDLE;
    ai_ttl: u32;
}

ADDRINFOEX5 :: addrinfoex5;

addrinfo_dns_server :: struct {
    ai_servertype: u32;
    ai_flags: AI #align 8;
    ai_addrlen: u32 #align 8;
    ai_addr: *sockaddr;

    union {
        ai_template: *s16;
    }
}

ADDRINFO_DNS_SERVER :: addrinfo_dns_server;

addrinfoex6 :: struct {
    ai_flags: AI;
    ai_family: s32;
    ai_socktype: SOCK;
    ai_protocol: IPPROTO;
    ai_addrlen: u64;
    ai_canonname: *s16;
    ai_addr: *sockaddr;
    ai_blob: *void;
    ai_bloblen: u64;
    ai_provider: *GUID;
    ai_next: *addrinfoex5;
    ai_version: s32;
    ai_fqdn: *s16;
    ai_interfaceindex: s32;
    ai_resolutionhandle: HANDLE;
    ai_ttl: u32;
    ai_numservers: u32;
    ai_servers: *ADDRINFO_DNS_SERVER;
    ai_responseflags: u64;
}

ADDRINFOEX6 :: addrinfoex6;

SOCKET :: u64;

fd_set :: struct {
    fd_count: u32;
    fd_array: [64] SOCKET;
}

__WSAFDIsSet :: (fd: SOCKET, unknown0: *fd_set) -> s32 #foreign ws2_32;

timeval :: struct {
    tv_sec: s32;
    tv_usec: s32;
}

hostent :: struct {
    h_name: *u8;
    h_aliases: **u8;
    h_addrtype: s16;
    h_length: s16;
    h_addr_list: **u8;
}

netent :: struct {
    n_name: *u8;
    n_aliases: **u8;
    n_addrtype: s16;
    n_net: u32;
}

servent :: struct {
    s_name: *u8;
    s_aliases: **u8;

    s_proto: *u8;
    s_port: s16;
}

protoent :: struct {
    p_name: *u8;
    p_aliases: **u8;
    p_proto: s16;
}

WSAData :: struct {
    wVersion: u16;
    wHighVersion: u16;

    iMaxSockets: u16;
    iMaxUdpDg: u16;
    lpVendorInfo: *u8;
    szDescription: [257] u8;
    szSystemStatus: [129] u8;
}

WSADATA :: WSAData;

sockproto :: struct {
    sp_family: u16;
    sp_protocol: u16;
}

linger :: struct {
    l_onoff: u16;
    l_linger: u16;
}

SERVICETYPE :: u32;

flowspec :: struct {
    TokenRate: u32;
    TokenBucketSize: u32;
    PeakBandwidth: u32;
    Latency: u32;
    DelayVariation: u32;
    ServiceType: SERVICETYPE;
    MaxSduSize: u32;
    MinimumPolicedSize: u32;
}

FLOWSPEC :: flowspec;

QOS_OBJECT_HDR :: struct {
    ObjectType: u32;
    ObjectLength: u32;
}

QOS_SD_MODE :: struct {
    ObjectHdr: QOS_OBJECT_HDR;
    ShapeDiscardMode: u32;
}

QOS_SHAPING_RATE :: struct {
    ObjectHdr: QOS_OBJECT_HDR;
    ShapingRate: u32;
}

QualityOfService :: struct {
    SendingFlowspec: FLOWSPEC;
    ReceivingFlowspec: FLOWSPEC;
    ProviderSpecific: WSABUF;
}

QOS :: QualityOfService;

GROUP :: u32;

WSANETWORKEVENTS :: struct {
    lNetworkEvents: s32;
    iErrorCode: [10] s32;
}

WSAPROTOCOLCHAIN :: struct {
    ChainLen: s32;

    ChainEntries: [7] u32;
}

WSAPROTOCOL_INFOA :: struct {
    dwServiceFlags1: u32;
    dwServiceFlags2: u32;
    dwServiceFlags3: u32;
    dwServiceFlags4: u32;
    dwProviderFlags: u32;
    ProviderId: GUID;
    dwCatalogEntryId: u32;
    ProtocolChain: WSAPROTOCOLCHAIN;
    iVersion: s32;
    iAddressFamily: s32;
    iMaxSockAddr: s32;
    iMinSockAddr: s32;
    iSocketType: s32;
    iProtocol: s32;
    iProtocolMaxOffset: s32;
    iNetworkByteOrder: s32;
    iSecurityScheme: s32;
    dwMessageSize: u32;
    dwProviderReserved: u32;
    szProtocol: [256] u8;
}

WSAPROTOCOL_INFOW :: struct {
    dwServiceFlags1: u32;
    dwServiceFlags2: u32;
    dwServiceFlags3: u32;
    dwServiceFlags4: u32;
    dwProviderFlags: u32;
    ProviderId: GUID;
    dwCatalogEntryId: u32;
    ProtocolChain: WSAPROTOCOLCHAIN;
    iVersion: s32;
    iAddressFamily: s32;
    iMaxSockAddr: s32;
    iMinSockAddr: s32;
    iSocketType: s32;
    iProtocol: s32;
    iProtocolMaxOffset: s32;
    iNetworkByteOrder: s32;
    iSecurityScheme: s32;
    dwMessageSize: u32;
    dwProviderReserved: u32;
    szProtocol: [256] s16;
}

WSAPROTOCOL_INFO :: WSAPROTOCOL_INFOA;

LPCONDITIONPROC :: #type (lpCallerId: *WSABUF, lpCallerData: *WSABUF, lpSQOS: *QualityOfService, lpGQOS: *QualityOfService, lpCalleeId: *WSABUF, lpCalleeData: *WSABUF, g: *GROUP, dwCallbackData: u64) -> s32 #c_call;

LPWSAOVERLAPPED_COMPLETION_ROUTINE :: #type (dwError: u32, cbTransferred: u32, lpOverlapped: *OVERLAPPED, dwFlags: u32) -> void #c_call;

WSACOMPLETIONTYPE :: enum s32 {
    IMMEDIATELY :: 0;
    HWND :: 1;
    EVENT :: 2;
    PORT :: 3;
    APC :: 4;

    NSP_NOTIFY_IMMEDIATELY :: IMMEDIATELY;
    NSP_NOTIFY_HWND :: HWND;
    NSP_NOTIFY_EVENT :: EVENT;
    NSP_NOTIFY_PORT :: PORT;
    NSP_NOTIFY_APC :: APC;
}

WSACOMPLETION :: struct {
    Type: WSACOMPLETIONTYPE;
    Parameters: union {
        WindowMessage: struct {
            hWnd: HWND;
            uMsg: u32;
            _context: WPARAM;
        };

        Event: struct {
            lpOverlapped: *OVERLAPPED;
        };

        Apc: struct {
            lpOverlapped: *OVERLAPPED;
            lpfnCompletionProc: LPWSAOVERLAPPED_COMPLETION_ROUTINE;
        };

        Port: struct {
            lpOverlapped: *OVERLAPPED;
            hPort: HANDLE;
            Key: u64;
        };
    };
}

BLOB :: struct {
    cbSize: u32;

    pBlobData: *u8;
}

AFPROTOCOLS :: struct {
    iAddressFamily: s32;
    iProtocol: s32;
}

WSAEcomparator :: enum s32 {
    EQUAL :: 0;
    NOTLESS :: 1;

    COMP_EQUAL :: EQUAL;
    COMP_NOTLESS :: NOTLESS;
}

WSAECOMPARATOR :: WSAEcomparator;

WSAVersion :: struct {
    dwVersion: u32;
    ecHow: WSAECOMPARATOR;
}

WSAVERSION :: WSAVersion;

WSAESETSERVICEOP :: enum s32 {
    REGISTER :: 0;
    DEREGISTER :: 1;
    DELETE :: 2;

    RNRSERVICE_REGISTER :: REGISTER;
    RNRSERVICE_DEREGISTER :: DEREGISTER;
    RNRSERVICE_DELETE :: DELETE;
}

WSANSClassInfoA :: struct {
    lpszName: *u8;
    dwNameSpace: u32;
    dwValueType: u32;
    dwValueSize: u32;
    lpValue: *void;
}

WSANSCLASSINFOA :: WSANSClassInfoA;

WSANSClassInfoW :: struct {
    lpszName: *s16;
    dwNameSpace: u32;
    dwValueType: u32;
    dwValueSize: u32;
    lpValue: *void;
}

WSANSCLASSINFOW :: WSANSClassInfoW;

WSANSCLASSINFO :: WSANSCLASSINFOA;

WSAServiceClassInfoA :: struct {
    lpServiceClassId: *GUID;
    lpszServiceClassName: *u8;
    dwCount: u32;
    lpClassInfos: *WSANSClassInfoA;
}

WSAServiceClassInfoW :: struct {
    lpServiceClassId: *GUID;
    lpszServiceClassName: *s16;
    dwCount: u32;
    lpClassInfos: *WSANSClassInfoW;
}

pollfd :: struct {
    fd: SOCKET;
    events: s16;
    revents: s16;
}

WSAPOLLFD :: pollfd;

accept :: (s: SOCKET, addr: *sockaddr, addrlen: *s32) -> SOCKET #foreign ws2_32;

bind :: (s: SOCKET, name: *sockaddr, namelen: s32) -> s32 #foreign ws2_32;

closesocket :: (s: SOCKET) -> s32 #foreign ws2_32;

connect :: (s: SOCKET, name: *sockaddr, namelen: s32) -> s32 #foreign ws2_32;

ioctlsocket :: (s: SOCKET, cmd: s32, argp: *u32) -> s32 #foreign ws2_32;

getpeername :: (s: SOCKET, name: *sockaddr, namelen: *s32) -> s32 #foreign ws2_32;

getsockname :: (s: SOCKET, name: *sockaddr, namelen: *s32) -> s32 #foreign ws2_32;

getsockopt :: (s: SOCKET, level: s32, optname: s32, optval: *u8, optlen: *s32) -> s32 #foreign ws2_32;

htonl :: (hostlong: u32) -> u32 #foreign ws2_32;

htons :: (hostshort: u16) -> u16 #foreign ws2_32;

inet_addr :: (cp: *u8) -> u32 #foreign ws2_32;

inet_ntoa :: (in: in_addr) -> *u8 #foreign ws2_32;

listen :: (s: SOCKET, backlog: s32) -> s32 #foreign ws2_32;

ntohl :: (netlong: u32) -> u32 #foreign ws2_32;

ntohs :: (netshort: u16) -> u16 #foreign ws2_32;

recv :: (s: SOCKET, buf: *u8, len: s32, flags: MSG) -> s32 #foreign ws2_32;

recvfrom :: (s: SOCKET, buf: *u8, len: s32, flags: MSG, from: *sockaddr, fromlen: *s32) -> s32 #foreign ws2_32;

select :: (nfds: s32, readfds: *fd_set, writefds: *fd_set, exceptfds: *fd_set, timeout: *timeval) -> s32 #foreign ws2_32;

send :: (s: SOCKET, buf: *u8, len: s32, flags: MSG) -> s32 #foreign ws2_32;

sendto :: (s: SOCKET, buf: *u8, len: s32, flags: MSG, to: *sockaddr, tolen: s32) -> s32 #foreign ws2_32;

setsockopt :: (s: SOCKET, level: s32, optname: s32, optval: *u8, optlen: s32) -> s32 #foreign ws2_32;

shutdown :: (s: SOCKET, how: s32) -> s32 #foreign ws2_32;

socket :: (af: s32, type: SOCK, protocol: IPPROTO) -> SOCKET #foreign ws2_32;

gethostbyaddr :: (addr: *u8, len: s32, type: s32) -> *hostent #foreign ws2_32;

gethostbyname :: (name: *u8) -> *hostent #foreign ws2_32;

gethostname :: (name: *u8, namelen: s32) -> s32 #foreign ws2_32;

GetHostNameW :: (name: *s16, namelen: s32) -> s32 #foreign ws2_32;

getservbyport :: (port: s32, proto: *u8) -> *servent #foreign ws2_32;

getservbyname :: (name: *u8, proto: *u8) -> *servent #foreign ws2_32;

getprotobynumber :: (number: s32) -> *protoent #foreign ws2_32;

getprotobyname :: (name: *u8) -> *protoent #foreign ws2_32;

WSAStartup :: (wVersionRequested: u16, lpWSAData: *WSAData) -> s32 #foreign ws2_32;

WSACleanup :: () -> s32 #foreign ws2_32;

WSASetLastError :: (iError: s32) -> void #foreign ws2_32;

WSAGetLastError :: () -> OS_Error_Code #foreign ws2_32;

WSAIsBlocking :: () -> BOOL #foreign ws2_32;

WSAUnhookBlockingHook :: () -> s32 #foreign ws2_32;

WSASetBlockingHook :: (lpBlockFunc: #type () -> s64 #c_call) -> (() -> s64 #c_call) #foreign ws2_32;

WSACancelBlockingCall :: () -> s32 #foreign ws2_32;

WSAAsyncGetServByName :: (hWnd: HWND, wMsg: u32, name: *u8, proto: *u8, buf: *u8, buflen: s32) -> HANDLE #foreign ws2_32;

WSAAsyncGetServByPort :: (hWnd: HWND, wMsg: u32, port: s32, proto: *u8, buf: *u8, buflen: s32) -> HANDLE #foreign ws2_32;

WSAAsyncGetProtoByName :: (hWnd: HWND, wMsg: u32, name: *u8, buf: *u8, buflen: s32) -> HANDLE #foreign ws2_32;

WSAAsyncGetProtoByNumber :: (hWnd: HWND, wMsg: u32, number: s32, buf: *u8, buflen: s32) -> HANDLE #foreign ws2_32;

WSAAsyncGetHostByName :: (hWnd: HWND, wMsg: u32, name: *u8, buf: *u8, buflen: s32) -> HANDLE #foreign ws2_32;

WSAAsyncGetHostByAddr :: (hWnd: HWND, wMsg: u32, addr: *u8, len: s32, type: s32, buf: *u8, buflen: s32) -> HANDLE #foreign ws2_32;

WSACancelAsyncRequest :: (hAsyncTaskHandle: HANDLE) -> s32 #foreign ws2_32;

WSAAsyncSelect :: (s: SOCKET, hWnd: HWND, wMsg: u32, lEvent: s32) -> s32 #foreign ws2_32;

WSAAccept :: (s: SOCKET, addr: *sockaddr, addrlen: *s32, lpfnCondition: LPCONDITIONPROC, dwCallbackData: u64) -> SOCKET #foreign ws2_32;

WSACloseEvent :: (hEvent: HANDLE) -> BOOL #foreign ws2_32;

WSAConnect :: (s: SOCKET, name: *sockaddr, namelen: s32, lpCallerData: *WSABUF, lpCalleeData: *WSABUF, lpSQOS: *QualityOfService, lpGQOS: *QualityOfService) -> s32 #foreign ws2_32;

WSAConnectByNameW :: (s: SOCKET, nodename: *s16, servicename: *s16, LocalAddressLength: *u32, LocalAddress: *sockaddr, RemoteAddressLength: *u32, RemoteAddress: *sockaddr, timeout: *timeval, Reserved: *OVERLAPPED) -> BOOL #foreign ws2_32;

WSAConnectByNameA :: (s: SOCKET, nodename: *u8, servicename: *u8, LocalAddressLength: *u32, LocalAddress: *sockaddr, RemoteAddressLength: *u32, RemoteAddress: *sockaddr, timeout: *timeval, Reserved: *OVERLAPPED) -> BOOL #foreign ws2_32;

WSAConnectByList :: (s: SOCKET, SocketAddress: *SOCKET_ADDRESS_LIST, LocalAddressLength: *u32, LocalAddress: *sockaddr, RemoteAddressLength: *u32, RemoteAddress: *sockaddr, timeout: *timeval, Reserved: *OVERLAPPED) -> BOOL #foreign ws2_32;

WSACreateEvent :: () -> HANDLE #foreign ws2_32;

WSADuplicateSocketA :: (s: SOCKET, dwProcessId: u32, lpProtocolInfo: *WSAPROTOCOL_INFOA) -> s32 #foreign ws2_32;

WSADuplicateSocketW :: (s: SOCKET, dwProcessId: u32, lpProtocolInfo: *WSAPROTOCOL_INFOW) -> s32 #foreign ws2_32;

WSAEnumNetworkEvents :: (s: SOCKET, hEventObject: HANDLE, lpNetworkEvents: *WSANETWORKEVENTS) -> s32 #foreign ws2_32;

WSAEnumProtocolsA :: (lpiProtocols: *s32, lpProtocolBuffer: *WSAPROTOCOL_INFOA, lpdwBufferLength: *u32) -> s32 #foreign ws2_32;

WSAEnumProtocolsW :: (lpiProtocols: *s32, lpProtocolBuffer: *WSAPROTOCOL_INFOW, lpdwBufferLength: *u32) -> s32 #foreign ws2_32;

WSAEventSelect :: (s: SOCKET, hEventObject: HANDLE, lNetworkEvents: s32) -> s32 #foreign ws2_32;

WSAGetOverlappedResult :: (s: SOCKET, lpOverlapped: *OVERLAPPED, lpcbTransfer: *u32, fWait: BOOL, lpdwFlags: *u32) -> BOOL #foreign ws2_32;

WSAGetQOSByName :: (s: SOCKET, lpQOSName: *WSABUF, lpQOS: *QualityOfService) -> BOOL #foreign ws2_32;

WSAHtonl :: (s: SOCKET, hostlong: u32, lpnetlong: *u32) -> s32 #foreign ws2_32;

WSAHtons :: (s: SOCKET, hostshort: u16, lpnetshort: *u16) -> s32 #foreign ws2_32;

WSAIoctl :: (s: SOCKET, dwIoControlCode: u32, lpvInBuffer: *void, cbInBuffer: u32, lpvOutBuffer: *void, cbOutBuffer: u32, lpcbBytesReturned: *u32, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE) -> s32 #foreign ws2_32;

WSAJoinLeaf :: (s: SOCKET, name: *sockaddr, namelen: s32, lpCallerData: *WSABUF, lpCalleeData: *WSABUF, lpSQOS: *QualityOfService, lpGQOS: *QualityOfService, dwFlags: u32) -> SOCKET #foreign ws2_32;

WSANtohl :: (s: SOCKET, netlong: u32, lphostlong: *u32) -> s32 #foreign ws2_32;

WSANtohs :: (s: SOCKET, netshort: u16, lphostshort: *u16) -> s32 #foreign ws2_32;

WSARecv :: (s: SOCKET, lpBuffers: *WSABUF, dwBufferCount: u32, lpNumberOfBytesRecvd: *u32, lpFlags: *u32, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE) -> s32 #foreign ws2_32;

WSARecvDisconnect :: (s: SOCKET, lpInboundDisconnectData: *WSABUF) -> s32 #foreign ws2_32;

WSARecvFrom :: (s: SOCKET, lpBuffers: *WSABUF, dwBufferCount: u32, lpNumberOfBytesRecvd: *u32, lpFlags: *u32, lpFrom: *sockaddr, lpFromlen: *s32, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE) -> s32 #foreign ws2_32;

WSAResetEvent :: (hEvent: HANDLE) -> BOOL #foreign ws2_32;

WSASend :: (s: SOCKET, lpBuffers: *WSABUF, dwBufferCount: u32, lpNumberOfBytesSent: *u32, dwFlags: u32, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE) -> s32 #foreign ws2_32;

WSASendMsg :: (Handle: SOCKET, lpMsg: *WSAMSG, dwFlags: u32, lpNumberOfBytesSent: *u32, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE) -> s32 #foreign ws2_32;

WSASendDisconnect :: (s: SOCKET, lpOutboundDisconnectData: *WSABUF) -> s32 #foreign ws2_32;

WSASendTo :: (s: SOCKET, lpBuffers: *WSABUF, dwBufferCount: u32, lpNumberOfBytesSent: *u32, dwFlags: u32, lpTo: *sockaddr, iTolen: s32, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE) -> s32 #foreign ws2_32;

WSASetEvent :: (hEvent: HANDLE) -> BOOL #foreign ws2_32;

WSASocketA :: (af: s32, type: SOCK, protocol: IPPROTO, lpProtocolInfo: *WSAPROTOCOL_INFOA, g: GROUP, dwFlags: u32) -> SOCKET #foreign ws2_32;

WSASocketW :: (af: s32, type: SOCK, protocol: IPPROTO, lpProtocolInfo: *WSAPROTOCOL_INFOW, g: GROUP, dwFlags: u32) -> SOCKET #foreign ws2_32;

WSAWaitForMultipleEvents :: (cEvents: u32, lphEvents: *HANDLE, fWaitAll: BOOL, dwTimeout: u32, fAlertable: BOOL) -> u32 #foreign ws2_32;

WSAAddressToStringA :: (lpsaAddress: *sockaddr, dwAddressLength: u32, lpProtocolInfo: *WSAPROTOCOL_INFOA, lpszAddressString: *u8, lpdwAddressStringLength: *u32) -> s32 #foreign ws2_32;

WSAAddressToStringW :: (lpsaAddress: *sockaddr, dwAddressLength: u32, lpProtocolInfo: *WSAPROTOCOL_INFOW, lpszAddressString: *s16, lpdwAddressStringLength: *u32) -> s32 #foreign ws2_32;

WSAStringToAddressA :: (AddressString: *u8, AddressFamily: s32, lpProtocolInfo: *WSAPROTOCOL_INFOA, lpAddress: *sockaddr, lpAddressLength: *s32) -> s32 #foreign ws2_32;

WSAStringToAddressW :: (AddressString: *s16, AddressFamily: s32, lpProtocolInfo: *WSAPROTOCOL_INFOW, lpAddress: *sockaddr, lpAddressLength: *s32) -> s32 #foreign ws2_32;

WSANSPIoctl :: (hLookup: HANDLE, dwControlCode: u32, lpvInBuffer: *void, cbInBuffer: u32, lpvOutBuffer: *void, cbOutBuffer: u32, lpcbBytesReturned: *u32, lpCompletion: *WSACOMPLETION) -> s32 #foreign ws2_32;

WSAInstallServiceClassA :: (lpServiceClassInfo: *WSAServiceClassInfoA) -> s32 #foreign ws2_32;

WSAInstallServiceClassW :: (lpServiceClassInfo: *WSAServiceClassInfoW) -> s32 #foreign ws2_32;

WSARemoveServiceClass :: (lpServiceClassId: *GUID) -> s32 #foreign ws2_32;

WSAGetServiceClassInfoA :: (lpProviderId: *GUID, lpServiceClassId: *GUID, lpdwBufSize: *u32, lpServiceClassInfo: *WSAServiceClassInfoA) -> s32 #foreign ws2_32;

WSAGetServiceClassInfoW :: (lpProviderId: *GUID, lpServiceClassId: *GUID, lpdwBufSize: *u32, lpServiceClassInfo: *WSAServiceClassInfoW) -> s32 #foreign ws2_32;

WSAGetServiceClassNameByClassIdA :: (lpServiceClassId: *GUID, lpszServiceClassName: *u8, lpdwBufferLength: *u32) -> s32 #foreign ws2_32;

WSAGetServiceClassNameByClassIdW :: (lpServiceClassId: *GUID, lpszServiceClassName: *s16, lpdwBufferLength: *u32) -> s32 #foreign ws2_32;

WSAProviderConfigChange :: (lpNotificationHandle: *HANDLE, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPWSAOVERLAPPED_COMPLETION_ROUTINE) -> s32 #foreign ws2_32;

WSAPoll :: (fdArray: *pollfd, fds: u32, timeout: s32) -> s32 #foreign ws2_32;

SOCK_NOTIFY_REGISTRATION :: struct {
    socket: SOCKET;
    completionKey: *void;
    eventFilter: u16;
    operation: u8;
    triggerFlags: u8;
    registrationResult: u32;
}

LINGER :: linger;

HOSTENT :: hostent;

SERVENT :: servent;

PROTOENT :: protoent;

TIMEVAL :: timeval;

in6_addr :: struct {
    u: union {
        Byte: [16] u8;
        Word: [8] u16;
    };
}

IN6_ADDR :: in6_addr;

sockaddr_in6_old :: struct {
    sin6_family: s16;
    sin6_port: u16;
    sin6_flowinfo: u32;
    sin6_addr: IN6_ADDR;
}

sockaddr_gen :: union {
    Address: sockaddr;
    AddressIn: sockaddr_in;
    AddressIn6: sockaddr_in6_old;
}

INTERFACE_INFO :: struct {
    iiFlags: u32;
    iiAddress: sockaddr_gen;
    iiBroadcastAddress: sockaddr_gen;
    iiNetmask: sockaddr_gen;
}

INTERFACE_INFO_EX :: struct {
    iiFlags: u32;
    iiAddress: SOCKET_ADDRESS;
    iiBroadcastAddress: SOCKET_ADDRESS;
    iiNetmask: SOCKET_ADDRESS;
}

PMTUD_STATE :: enum s32 {
    NOT_SET :: 0;
    DO :: 1;
    DONT :: 2;
    PROBE :: 3;
    MAX :: 4;

    IP_PMTUDISC_NOT_SET :: NOT_SET;
    IP_PMTUDISC_DO :: DO;
    IP_PMTUDISC_DONT :: DONT;
    IP_PMTUDISC_PROBE :: PROBE;
    IP_PMTUDISC_MAX :: MAX;
}

sockaddr_in6 :: struct {
    sin6_family: ADDRESS_FAMILY;
    sin6_port: u16;
    sin6_flowinfo: u32;
    sin6_addr: IN6_ADDR;
    union {
        sin6_scope_id: u32;
        sin6_scope_struct: SCOPE_ID;
    }
}

SOCKADDR_IN6_LH :: sockaddr_in6;

sockaddr_in6_w2ksp1 :: struct {
    sin6_family: s16;
    sin6_port: u16;
    sin6_flowinfo: u32;
    sin6_addr: in6_addr;
    sin6_scope_id: u32;
}

SOCKADDR_IN6_W2KSP1 :: sockaddr_in6_w2ksp1;

SOCKADDR_IN6 :: SOCKADDR_IN6_LH;

SOCKADDR_INET :: union {
    Ipv4: SOCKADDR_IN;
    Ipv6: SOCKADDR_IN6;
    si_family: ADDRESS_FAMILY;
}

sockaddr_in6_pair :: struct {
    SourceAddress: *SOCKADDR_IN6_LH;
    DestinationAddress: *SOCKADDR_IN6_LH;
}

SOCKADDR_IN6_PAIR :: sockaddr_in6_pair;

scopeid_unspecified: SCOPE_ID;

in4addr_any: IN_ADDR;
in4addr_loopback: IN_ADDR;
in4addr_broadcast: IN_ADDR;
in4addr_allnodesonlink: IN_ADDR;
in4addr_allroutersonlink: IN_ADDR;
in4addr_alligmpv3routersonlink: IN_ADDR;
in4addr_allteredohostsonlink: IN_ADDR;
in4addr_linklocalprefix: IN_ADDR;
in4addr_multicastprefix: IN_ADDR;

in6addr_any: IN6_ADDR;
in6addr_loopback: IN6_ADDR;
in6addr_allnodesonnode: IN6_ADDR;
in6addr_allnodesonlink: IN6_ADDR;
in6addr_allroutersonlink: IN6_ADDR;
in6addr_allmldv2routersonlink: IN6_ADDR;
in6addr_teredoinitiallinklocaladdress: IN6_ADDR;
in6addr_linklocalprefix: IN6_ADDR;
in6addr_multicastprefix: IN6_ADDR;
in6addr_solicitednodemulticastprefix: IN6_ADDR;
in6addr_v4mappedprefix: IN6_ADDR;
in6addr_6to4prefix: IN6_ADDR;
in6addr_teredoprefix: IN6_ADDR;
in6addr_teredoprefix_old: IN6_ADDR;

MULTICAST_MODE_TYPE :: enum s32 {
    INCLUDE :: 0;
    EXCLUDE :: 1;

    MCAST_INCLUDE :: INCLUDE;
    MCAST_EXCLUDE :: EXCLUDE;
}

ip_mreq :: struct {
    imr_multiaddr: IN_ADDR;
    imr_interface: IN_ADDR;
}

IP_MREQ :: ip_mreq;

ip_mreq_source :: struct {
    imr_multiaddr: IN_ADDR;
    imr_sourceaddr: IN_ADDR;
    imr_interface: IN_ADDR;
}

IP_MREQ_SOURCE :: ip_mreq_source;

ip_msfilter :: struct {
    imsf_multiaddr: IN_ADDR;
    imsf_interface: IN_ADDR;
    imsf_fmode: MULTICAST_MODE_TYPE;
    imsf_numsrc: u32;
    imsf_slist: [1] IN_ADDR;
}

IP_MSFILTER :: ip_msfilter;

ipv6_mreq :: struct {
    ipv6mr_multiaddr: IN6_ADDR;
    ipv6mr_interface: u32;
}

IPV6_MREQ :: ipv6_mreq;

group_req :: struct {
    gr_interface: u32;
    gr_group: SOCKADDR_STORAGE;
}

GROUP_REQ :: group_req;

group_source_req :: struct {
    gsr_interface: u32;
    gsr_group: SOCKADDR_STORAGE;
    gsr_source: SOCKADDR_STORAGE;
}

GROUP_SOURCE_REQ :: group_source_req;

group_filter :: struct {
    gf_interface: u32;
    gf_group: SOCKADDR_STORAGE;
    gf_fmode: MULTICAST_MODE_TYPE;
    gf_numsrc: u32;
    gf_slist: [1] SOCKADDR_STORAGE;
}

GROUP_FILTER :: group_filter;

in_pktinfo :: struct {
    ipi_addr: IN_ADDR;
    ipi_ifindex: u32;
}

IN_PKTINFO :: in_pktinfo;

in6_pktinfo :: struct {
    ipi6_addr: IN6_ADDR;
    ipi6_ifindex: u32;
}

IN6_PKTINFO :: in6_pktinfo;

in_pktinfo_ex :: struct {
    pkt_info: IN_PKTINFO;
    scope_id: SCOPE_ID;
}

IN_PKTINFO_EX :: in_pktinfo_ex;

in6_pktinfo_ex :: struct {
    pkt_info: IN6_PKTINFO;
    scope_id: SCOPE_ID;
}

IN6_PKTINFO_EX :: in6_pktinfo_ex;

in_recverr :: struct {
    protocol: IPPROTO;
    info: u32;
    type: u8;
    code: u8;
}

IN_RECVERR :: in_recverr;

icmp_error_info :: struct {
    srcaddress: SOCKADDR_INET;
    protocol: IPPROTO;
    type: u8;
    code: u8;
}

ICMP_ERROR_INFO :: icmp_error_info;

ADDRINFOT :: ADDRINFOA;

ADDRINFO :: ADDRINFOA;

ADDRINFOEX :: ADDRINFOEXA;

getaddrinfo :: (pNodeName: *u8, pServiceName: *u8, pHints: *ADDRINFOA, ppResult: **addrinfo) -> s32 #foreign ws2_32;

GetAddrInfoW :: (pNodeName: *s16, pServiceName: *s16, pHints: *ADDRINFOW, ppResult: **addrinfoW) -> s32 #foreign ws2_32;

LPLOOKUPSERVICE_COMPLETION_ROUTINE :: #type (dwError: u32, dwBytes: u32, lpOverlapped: *OVERLAPPED) -> void #c_call;

GetAddrInfoExA :: (pName: *u8, pServiceName: *u8, dwNameSpace: u32, lpNspId: *GUID, hints: *ADDRINFOEXA, ppResult: **addrinfoexA, timeout: *timeval, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPLOOKUPSERVICE_COMPLETION_ROUTINE, lpNameHandle: *HANDLE) -> s32 #foreign ws2_32;

GetAddrInfoExW :: (pName: *s16, pServiceName: *s16, dwNameSpace: u32, lpNspId: *GUID, hints: *ADDRINFOEXW, ppResult: **addrinfoexW, timeout: *timeval, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPLOOKUPSERVICE_COMPLETION_ROUTINE, lpHandle: *HANDLE) -> s32 #foreign ws2_32;

GetAddrInfoExCancel :: (lpHandle: *HANDLE) -> s32 #foreign ws2_32;

GetAddrInfoExOverlappedResult :: (lpOverlapped: *OVERLAPPED) -> s32 #foreign ws2_32;

SetAddrInfoExA :: (pName: *u8, pServiceName: *u8, pAddresses: *SOCKET_ADDRESS, dwAddressCount: u32, lpBlob: *BLOB, dwFlags: u32, dwNameSpace: u32, lpNspId: *GUID, timeout: *timeval, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPLOOKUPSERVICE_COMPLETION_ROUTINE, lpNameHandle: *HANDLE) -> s32 #foreign ws2_32;

SetAddrInfoExW :: (pName: *s16, pServiceName: *s16, pAddresses: *SOCKET_ADDRESS, dwAddressCount: u32, lpBlob: *BLOB, dwFlags: u32, dwNameSpace: u32, lpNspId: *GUID, timeout: *timeval, lpOverlapped: *OVERLAPPED, lpCompletionRoutine: LPLOOKUPSERVICE_COMPLETION_ROUTINE, lpNameHandle: *HANDLE) -> s32 #foreign ws2_32;

freeaddrinfo :: (pAddrInfo: *addrinfo) -> void #foreign ws2_32;

FreeAddrInfoW :: (pAddrInfo: *addrinfoW) -> void #foreign ws2_32;

FreeAddrInfoEx :: (pAddrInfoEx: *addrinfoexA) -> void #foreign ws2_32;

FreeAddrInfoExW :: (pAddrInfoEx: *addrinfoexW) -> void #foreign ws2_32;

socklen_t :: s32;

getnameinfo :: (pSockaddr: *SOCKADDR, SockaddrLength: socklen_t, pNodeBuffer: *u8, NodeBufferSize: u32, pServiceBuffer: *u8, ServiceBufferSize: u32, Flags: s32) -> s32 #foreign ws2_32;

GetNameInfoW :: (pSockaddr: *SOCKADDR, SockaddrLength: socklen_t, pNodeBuffer: *s16, NodeBufferSize: u32, pServiceBuffer: *s16, ServiceBufferSize: u32, Flags: s32) -> s32 #foreign ws2_32;

inet_pton :: (Family: s32, pszAddrString: *u8, pAddrBuf: *void) -> s32 #foreign ws2_32;

InetPtonW :: (Family: s32, pszAddrString: *s16, pAddrBuf: *void) -> s32 #foreign ws2_32;

inet_ntop :: (Family: s32, pAddr: *void, pStringBuf: *u8, StringBufSize: u64) -> *u8 #foreign ws2_32;

InetNtopW :: (Family: s32, pAddr: *void, pStringBuf: *s16, StringBufSize: u64) -> *s16 #foreign ws2_32;

SOCKET_DEFAULT2_QM_POLICY: GUID;

REAL_TIME_NOTIFICATION_CAPABILITY: GUID;

REAL_TIME_NOTIFICATION_CAPABILITY_EX: GUID;

ASSOCIATE_NAMERES_CONTEXT: GUID;

TCPSTATE :: enum s32 {
    CLOSED :: 0;
    LISTEN :: 1;
    SYN_SENT :: 2;
    SYN_RCVD :: 3;
    ESTABLISHED :: 4;
    FIN_WAIT_1 :: 5;
    FIN_WAIT_2 :: 6;
    CLOSE_WAIT :: 7;
    CLOSING :: 8;
    LAST_ACK :: 9;
    TIME_WAIT :: 10;
    MAX :: 11;

    TCPSTATE_CLOSED :: CLOSED;
    TCPSTATE_LISTEN :: LISTEN;
    TCPSTATE_SYN_SENT :: SYN_SENT;
    TCPSTATE_SYN_RCVD :: SYN_RCVD;
    TCPSTATE_ESTABLISHED :: ESTABLISHED;
    TCPSTATE_FIN_WAIT_1 :: FIN_WAIT_1;
    TCPSTATE_FIN_WAIT_2 :: FIN_WAIT_2;
    TCPSTATE_CLOSE_WAIT :: CLOSE_WAIT;
    TCPSTATE_CLOSING :: CLOSING;
    TCPSTATE_LAST_ACK :: LAST_ACK;
    TCPSTATE_TIME_WAIT :: TIME_WAIT;
    TCPSTATE_MAX :: MAX;
}

TRANSPORT_SETTING_ID :: struct {
    Guid: GUID;
}

tcp_keepalive :: struct {
    onoff: u32;
    keepalivetime: u32;
    keepaliveinterval: u32;
}

CONTROL_CHANNEL_TRIGGER_STATUS :: enum s32 {
    INVALID :: 0;
    SOFTWARE_SLOT_ALLOCATED :: 1;
    HARDWARE_SLOT_ALLOCATED :: 2;
    POLICY_ERROR :: 3;
    SYSTEM_ERROR :: 4;
    TRANSPORT_DISCONNECTED :: 5;
    SERVICE_UNAVAILABLE :: 6;

    CONTROL_CHANNEL_TRIGGER_STATUS_INVALID :: INVALID;
    CONTROL_CHANNEL_TRIGGER_STATUS_SOFTWARE_SLOT_ALLOCATED :: SOFTWARE_SLOT_ALLOCATED;
    CONTROL_CHANNEL_TRIGGER_STATUS_HARDWARE_SLOT_ALLOCATED :: HARDWARE_SLOT_ALLOCATED;
    CONTROL_CHANNEL_TRIGGER_STATUS_POLICY_ERROR :: POLICY_ERROR;
    CONTROL_CHANNEL_TRIGGER_STATUS_SYSTEM_ERROR :: SYSTEM_ERROR;
    CONTROL_CHANNEL_TRIGGER_STATUS_TRANSPORT_DISCONNECTED :: TRANSPORT_DISCONNECTED;
    CONTROL_CHANNEL_TRIGGER_STATUS_SERVICE_UNAVAILABLE :: SERVICE_UNAVAILABLE;
}

REAL_TIME_NOTIFICATION_SETTING_INPUT :: struct {
    TransportSettingId: TRANSPORT_SETTING_ID;
    BrokerEventGuid: GUID;
}

REAL_TIME_NOTIFICATION_SETTING_INPUT_EX :: struct {
    TransportSettingId: TRANSPORT_SETTING_ID;
    BrokerEventGuid: GUID;
    Unmark: BOOLEAN;
}

REAL_TIME_NOTIFICATION_SETTING_OUTPUT :: struct {
    ChannelStatus: CONTROL_CHANNEL_TRIGGER_STATUS;
}

ASSOCIATE_NAMERES_CONTEXT_INPUT :: struct {
    TransportSettingId: TRANSPORT_SETTING_ID;

    Handle: u64;
}

TIMESTAMPING_CONFIG :: struct {
    Flags: u32;
    TxTimestampsBuffered: u16;
}

SOCKET_PRIORITY_HINT :: enum s32 {
    PriorityHintVeryLow :: 0;
    PriorityHintLow :: 1;
    PriorityHintNormal :: 2;
    MaximumPriorityHintType :: 3;

    SocketPriorityHintVeryLow :: PriorityHintVeryLow;
    SocketPriorityHintLow :: PriorityHintLow;
    SocketPriorityHintNormal :: PriorityHintNormal;
    SocketMaximumPriorityHintType :: MaximumPriorityHintType;
}

PRIORITY_STATUS :: struct {
    Sender: SOCKET_PRIORITY_HINT;
    Receiver: SOCKET_PRIORITY_HINT;
}

RCVALL_VALUE :: enum s32 {
    OFF :: 0;
    ON :: 1;
    SOCKETLEVELONLY :: 2;
    IPLEVEL :: 3;

    RCVALL_OFF :: OFF;
    RCVALL_ON :: ON;
    RCVALL_SOCKETLEVELONLY :: SOCKETLEVELONLY;
    RCVALL_IPLEVEL :: IPLEVEL;
}

RCVALL_IF :: struct {
    Mode: RCVALL_VALUE;
    Interface: u32;
}

TCP_INITIAL_RTO_PARAMETERS :: struct {
    Rtt: u16;

    MaxSynRetransmissions: u8;
}

TCP_ICW_LEVEL :: enum s32 {
    DEFAULT :: 0;
    HIGH :: 1;
    VERY_HIGH :: 2;
    AGGRESSIVE :: 3;
    EXPERIMENTAL :: 4;
    COMPAT :: 254;
    MAX :: 255;

    TCP_ICW_LEVEL_DEFAULT :: DEFAULT;
    TCP_ICW_LEVEL_HIGH :: HIGH;
    TCP_ICW_LEVEL_VERY_HIGH :: VERY_HIGH;
    TCP_ICW_LEVEL_AGGRESSIVE :: AGGRESSIVE;
    TCP_ICW_LEVEL_EXPERIMENTAL :: EXPERIMENTAL;
    TCP_ICW_LEVEL_COMPAT :: COMPAT;
    TCP_ICW_LEVEL_MAX :: MAX;
}

TCP_ICW_PARAMETERS :: struct {
    Level: TCP_ICW_LEVEL;
}

TCP_ACK_FREQUENCY_PARAMETERS :: struct {
    TcpDelayedAckFrequency: u8;
}

TCP_INFO_v0 :: struct {
    State: TCPSTATE;
    Mss: u32;
    ConnectionTimeMs: u64;
    TimestampsEnabled: BOOLEAN;
    RttUs: u32;
    MinRttUs: u32;
    BytesInFlight: u32;
    Cwnd: u32;
    SndWnd: u32;
    RcvWnd: u32;
    RcvBuf: u32;
    BytesOut: u64;
    BytesIn: u64;
    BytesReordered: u32;
    BytesRetrans: u32;
    FastRetrans: u32;
    DupAcksIn: u32;
    TimeoutEpisodes: u32;
    SynRetrans: u8;
}

TCP_INFO_v1 :: struct {
    State: TCPSTATE;
    Mss: u32;
    ConnectionTimeMs: u64;
    TimestampsEnabled: BOOLEAN;
    RttUs: u32;
    MinRttUs: u32;
    BytesInFlight: u32;
    Cwnd: u32;
    SndWnd: u32;
    RcvWnd: u32;
    RcvBuf: u32;
    BytesOut: u64;
    BytesIn: u64;
    BytesReordered: u32;
    BytesRetrans: u32;
    FastRetrans: u32;
    DupAcksIn: u32;
    TimeoutEpisodes: u32;
    SynRetrans: u8;

    SndLimTransRwin: u32;
    SndLimTimeRwin: u32;
    SndLimBytesRwin: u64;
    SndLimTransCwnd: u32;
    SndLimTimeCwnd: u32;
    SndLimBytesCwnd: u64;
    SndLimTransSnd: u32;
    SndLimTimeSnd: u32;
    SndLimBytesSnd: u64;
}

INET_PORT_RANGE :: struct {
    StartPort: u16;
    NumberOfPorts: u16;
}

INET_PORT_RESERVATION :: INET_PORT_RANGE;

INET_PORT_RESERVATION_TOKEN :: struct {
    Token: u64;
}

INET_PORT_RESERVATION_INSTANCE :: struct {
    Reservation: INET_PORT_RESERVATION;
    Token: INET_PORT_RESERVATION_TOKEN;
}

INET_PORT_RESERVATION_INFORMATION :: struct {
    OwningPid: u32;
}

SOCKET_USAGE_TYPE :: enum s32 {
    SYSTEM_CRITICAL_SOCKET :: 1;
}

SOCKET_SECURITY_PROTOCOL :: enum s32 {
    DEFAULT :: 0;
    IPSEC :: 1;

    IPSEC2 :: 2;

    INVALID :: 3;

    SOCKET_SECURITY_PROTOCOL_DEFAULT :: DEFAULT;
    SOCKET_SECURITY_PROTOCOL_IPSEC :: IPSEC;

    SOCKET_SECURITY_PROTOCOL_IPSEC2 :: IPSEC2;

    SOCKET_SECURITY_PROTOCOL_INVALID :: INVALID;
}

SOCKET_SECURITY_SETTINGS :: struct {
    SecurityProtocol: SOCKET_SECURITY_PROTOCOL;
    SecurityFlags: u32;
}

SOCKET_SECURITY_SETTINGS_IPSEC :: struct {
    SecurityProtocol: SOCKET_SECURITY_PROTOCOL;
    SecurityFlags: u32;
    IpsecFlags: u32;
    AuthipMMPolicyKey: GUID;
    AuthipQMPolicyKey: GUID;
    Reserved: GUID;
    Reserved2: u64;
    UserNameStringLen: u32;
    DomainNameStringLen: u32;
    PasswordStringLen: u32;
    AllStrings: [0] s16;
}

SOCKET_PEER_TARGET_NAME :: struct {
    SecurityProtocol: SOCKET_SECURITY_PROTOCOL;
    PeerAddress: SOCKADDR_STORAGE;
    PeerTargetNameStringLen: u32;
    AllStrings: [0] s16;
}

SOCKET_SECURITY_QUERY_TEMPLATE :: struct {
    SecurityProtocol: SOCKET_SECURITY_PROTOCOL;
    PeerAddress: SOCKADDR_STORAGE;
    PeerTokenAccessMask: u32;
}

SOCKET_SECURITY_QUERY_TEMPLATE_IPSEC2 :: struct {
    SecurityProtocol: SOCKET_SECURITY_PROTOCOL;
    PeerAddress: SOCKADDR_STORAGE;
    PeerTokenAccessMask: u32;
    Flags: u32;
    FieldMask: u32;
}

SOCKET_SECURITY_QUERY_INFO :: struct {
    SecurityProtocol: SOCKET_SECURITY_PROTOCOL;
    Flags: u32;
    PeerApplicationAccessTokenHandle: u64;
    PeerMachineAccessTokenHandle: u64;
}

SOCKET_SECURITY_QUERY_INFO_IPSEC2 :: struct {
    SecurityProtocol: SOCKET_SECURITY_PROTOCOL;
    Flags: u32;
    PeerApplicationAccessTokenHandle: u64;
    PeerMachineAccessTokenHandle: u64;
    MmSaId: u64;
    QmSaId: u64;
    NegotiationWinerr: u32;
    SaLookupContext: GUID;
}

RSS_SCALABILITY_INFO :: struct {
    RssEnabled: BOOLEAN;
}

DL_EUI48 :: union {}

#scope_file

ws2_32 :: #system_library "ws2_32";
