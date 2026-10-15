/* Independent ABI checks against the actual native glibc public header. */
#define _DEFAULT_SOURCE 1
#include <netinet/tcp.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

_Static_assert(sizeof(struct tcphdr) == 20, "TCP header ABI");
_Static_assert(offsetof(struct tcp_info, tcpi_rto) == 8, "TCP scale byte ABI");
_Static_assert(offsetof(struct tcp_info, tcpi_total_retrans) == 100,
               "Reviewed TCP info prefix ABI");

int main(void) {
    for (uint32_t value = 0; value <= UINT16_MAX; ++value) {
        struct tcphdr packet;
        unsigned char *bytes = (unsigned char *)&packet;
        memset(&packet, 0xa5, sizeof(packet));
        packet.th_x2 = value;
        packet.th_off = value >> 4;
        if (bytes[12] != (value & 255) || bytes[13] != 0xa5)
            return 1;
        packet.res1 = value;
        packet.doff = value >> 4;
        packet.fin = value >> 8;
        packet.syn = value >> 9;
        packet.rst = value >> 10;
        packet.psh = value >> 11;
        packet.ack = value >> 12;
        packet.urg = value >> 13;
        packet.res2 = value >> 14;
        uint16_t word;
        memcpy(&word, bytes + 12, sizeof(word));
        if (word != value)
            return 2;
        for (size_t i = 0; i < sizeof(packet); ++i)
            if (i != 12 && i != 13 && bytes[i] != 0xa5)
                return 3;
        struct tcp_info info;
        memset(&info, 0xa5, sizeof(info));
        info.tcpi_snd_wscale = value;
        info.tcpi_rcv_wscale = value >> 4;
        if (((unsigned char *)&info)[6] != (value & 255))
            return 4;
        for (size_t i = 0; i < sizeof(info); ++i)
            if (i != 6 && ((unsigned char *)&info)[i] != 0xa5)
                return 5;
    }
    return 0;
}
