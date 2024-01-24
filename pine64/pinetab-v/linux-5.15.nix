{ pkgs, config, lib
, buildLinux
, fetchpatch
, fetchFromGitHub
, linuxPackagesFor
, callPackage
, ... }@args: let
  fishWaldoSrc = fetchFromGitHub {
    owner = "FishWaldo";
    repo = "Star64_linux";
    rev = "1456c984f15e21e28fb8a9ce96d0ca10e61a71c4";
    hash = "sha256-I5wzmxiY7PWpahYCqTOAmYEiJvpRPpUV7S21Kn9lLwg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/torvalds/linux/commit/215bebc8c6ac438c382a6a56bd2764a2d4e1da72.diff";
      hash = "sha256-1ZqmVOkgcDBRkHvVRPH8I5G1STIS1R/l/63PzQQ0z0I=";
      includes = ["security/keys/dh.c"];
    })
    (fetchpatch {
      url = "https://github.com/starfive-tech/linux/pull/108/commits/9ae8cb751c4d1fd2146b279a8e67887590e9d07a.diff";
      hash = "sha256-EY0lno+HkY5mradBUPII3qqu0xh+BVQRzveCQcaht0M=";
    })
    ./rtc-starfive-irq-desc.patch
    ./drm-img-rogue-common.patch
  ];
  version = "5.15.131";
  
  linux-ptv = {
    inherit version;
    modDirVersion = version;

    # defconfig = "pine64_pinetabv_defconfig";
    
    src = fishWaldoSrc;
    kernelPatches = map (p: {patch = p;}) patches;
    structuredExtraConfig = with lib.kernel; {
# DEFAULT_HOSTNAME="PineTabV";
SYSVIPC=yes;
POSIX_MQUEUE=yes;
USELIB=yes;
NO_HZ_IDLE=yes;
HIGH_RES_TIMERS=yes;
BPF_SYSCALL=yes;
IKCONFIG=yes;
IKCONFIG_PROC=yes;
CGROUPS=yes;
MEMCG=yes;
BLK_CGROUP=yes;
CGROUP_SCHED=yes;
CFS_BANDWIDTH=yes;
# RT_GROUP_SCHED=yes;
CGROUP_PIDS=yes;
CGROUP_RDMA=yes;
CGROUP_FREEZER=yes;
CGROUP_HUGETLB=yes;
CPUSETS=yes;
CGROUP_DEVICE=yes;
CGROUP_CPUACCT=yes;
CGROUP_PERF=yes;
CGROUP_BPF=yes;
CGROUP_MISC=yes;
NAMESPACES=yes;
USER_NS=yes;
CHECKPOINT_RESTORE=yes;
BLK_DEV_INITRD=yes;
EXPERT=yes;
PERF_EVENTS=yes;
SOC_STARFIVE=yes;
SOC_STARFIVE_JH7110=yes;
SMP=yes;
HZ_100=yes;
# CONFIG_EFI is not set
HIBERNATION=yes;
PM_STD_PARTITION=freeform "PARTLABEL=hibernation";
PM_DEBUG=yes;
PM_ADVANCED_DEBUG=yes;
PM_TEST_SUSPEND=yes;
CPU_IDLE=yes;
RISCV_SBI_CPUIDLE=yes;
MODULES=yes;
MODULE_UNLOAD=yes;
BLK_DEV_THROTTLING=yes;
PAGE_REPORTING=yes;
CMA=yes;
NET=yes;
PACKET=yes;
UNIX=yes;
XFRM_USER=module;
XFRM_INTERFACE=module;
NET_KEY=module;
NET_KEY_MIGRATE=yes;
INET=yes;
IP_MULTICAST=yes;
IP_ADVANCED_ROUTER=yes;
#IP_PNP=yes;
#IP_PNP_DHCP=yes;
#IP_PNP_BOOTP=yes;
#IP_PNP_RARP=yes;
NET_IPIP=module;
IP_MROUTE=yes;
INET_ESP=module;
TCP_CONG_ADVANCED=yes;
INET6_ESP=module;
IPV6_SIT=module;
IPV6_TUNNEL=module;
NETLABEL=yes;
NETFILTER=yes;
BRIDGE_NETFILTER=module;
NETFILTER_NETLINK_ACCT=yes;
NETFILTER_NETLINK_QUEUE=yes;
NF_CONNTRACK=module;
NF_CONNTRACK_AMANDA=module;
NF_CONNTRACK_FTP=module;
NF_CONNTRACK_H323=module;
NF_CONNTRACK_IRC=module;
NF_CONNTRACK_NETBIOS_NS=module;
NF_CONNTRACK_SNMP=module;
NF_CONNTRACK_PPTP=module;
NF_CONNTRACK_SANE=module;
NF_CONNTRACK_SIP=module;
NF_CONNTRACK_TFTP=module;
NF_CT_NETLINK=module;
NF_TABLES=module;
NFT_NUMGEN=module;
NFT_CT=module;
NFT_COUNTER=module;
NFT_CONNLIMIT=module;
NFT_LOG=module;
NFT_LIMIT=module;
NFT_MASQ=module;
NFT_REDIR=module;
NFT_NAT=module;
NFT_TUNNEL=module;
NFT_OBJREF=module;
NFT_QUEUE=module;
NFT_QUOTA=module;
NFT_REJECT=module;
NFT_COMPAT=module;
NFT_HASH=module;
NFT_SOCKET=module;
NFT_OSF=module;
NFT_TPROXY=module;
NFT_SYNPROXY=module;
NF_FLOW_TABLE=module;
NETFILTER_XT_MARK=module;
NETFILTER_XT_TARGET_CLASSIFY=module;
NETFILTER_XT_TARGET_CONNMARK=module;
NETFILTER_XT_TARGET_HMARK=module;
NETFILTER_XT_TARGET_IDLETIMER=module;
NETFILTER_XT_TARGET_LED=module;
NETFILTER_XT_TARGET_LOG=module;
NETFILTER_XT_TARGET_MARK=module;
NETFILTER_XT_TARGET_NFLOG=module;
NETFILTER_XT_TARGET_NFQUEUE=module;
NETFILTER_XT_TARGET_TEE=module;
NETFILTER_XT_TARGET_TCPMSS=module;
NETFILTER_XT_MATCH_ADDRTYPE=module;
NETFILTER_XT_MATCH_BPF=module;
NETFILTER_XT_MATCH_CGROUP=module;
NETFILTER_XT_MATCH_CLUSTER=module;
NETFILTER_XT_MATCH_COMMENT=module;
NETFILTER_XT_MATCH_CONNBYTES=module;
NETFILTER_XT_MATCH_CONNLABEL=module;
NETFILTER_XT_MATCH_CONNLIMIT=module;
NETFILTER_XT_MATCH_CONNMARK=module;
NETFILTER_XT_MATCH_CONNTRACK=module;
NETFILTER_XT_MATCH_CPU=module;
NETFILTER_XT_MATCH_DEVGROUP=module;
NETFILTER_XT_MATCH_DSCP=module;
NETFILTER_XT_MATCH_ECN=module;
NETFILTER_XT_MATCH_ESP=module;
NETFILTER_XT_MATCH_HASHLIMIT=module;
NETFILTER_XT_MATCH_HELPER=module;
NETFILTER_XT_MATCH_IPCOMP=module;
NETFILTER_XT_MATCH_IPRANGE=module;
NETFILTER_XT_MATCH_IPVS=module;
NETFILTER_XT_MATCH_LENGTH=module;
NETFILTER_XT_MATCH_LIMIT=module;
NETFILTER_XT_MATCH_MAC=module;
NETFILTER_XT_MATCH_MARK=module;
NETFILTER_XT_MATCH_MULTIPORT=module;
NETFILTER_XT_MATCH_NFACCT=module;
NETFILTER_XT_MATCH_OSF=module;
NETFILTER_XT_MATCH_OWNER=module;
NETFILTER_XT_MATCH_PKTTYPE=module;
NETFILTER_XT_MATCH_QUOTA=module;
NETFILTER_XT_MATCH_RATEEST=module;
NETFILTER_XT_MATCH_REALM=module;
NETFILTER_XT_MATCH_RECENT=module;
NETFILTER_XT_MATCH_SOCKET=module;
NETFILTER_XT_MATCH_STATE=module;
NETFILTER_XT_MATCH_STATISTIC=module;
NETFILTER_XT_MATCH_STRING=module;
NETFILTER_XT_MATCH_TCPMSS=module;
NETFILTER_XT_MATCH_TIME=module;
NETFILTER_XT_MATCH_U32=module;
IP_SET=module;
IP_VS=module;
IP_VS_IPV6=yes;
IP_VS_PROTO_TCP=yes;
IP_VS_PROTO_UDP=yes;
IP_VS_PROTO_ESP=yes;
IP_VS_PROTO_AH=yes;
IP_VS_PROTO_SCTP=yes;
IP_VS_RR=module;
IP_VS_WRR=module;
IP_VS_LC=module;
IP_VS_WLC=module;
IP_VS_FO=module;
IP_VS_OVF=module;
IP_VS_LBLC=module;
IP_VS_LBLCR=module;
IP_VS_DH=module;
IP_VS_SH=module;
IP_VS_MH=module;
IP_VS_SED=module;
IP_VS_NQ=module;
IP_VS_TWOS=module;
IP_VS_FTP=module;
IP_VS_PE_SIP=module;
NF_SOCKET_IPV4=yes;
NF_TABLES_IPV4=yes;
NFT_DUP_IPV4=module;
NFT_FIB_IPV4=module;
IP_NF_IPTABLES=yes;
IP_NF_FILTER=yes;
IP_NF_TARGET_REJECT=yes;
IP_NF_NAT=module;
IP_NF_TARGET_MASQUERADE=module;
IP_NF_TARGET_NETMAP=module;
IP_NF_TARGET_REDIRECT=module;
NF_TABLES_IPV6=yes;
NF_FLOW_TABLE_IPV6=module;
IP6_NF_IPTABLES=module;
IP6_NF_MATCH_AH=module;
IP6_NF_MATCH_EUI64=module;
IP6_NF_MATCH_FRAG=module;
IP6_NF_MATCH_OPTS=module;
IP6_NF_MATCH_HL=module;
IP6_NF_MATCH_IPV6HEADER=module;
IP6_NF_MATCH_MH=module;
IP6_NF_MATCH_RPFILTER=module;
IP6_NF_MATCH_RT=module;
IP6_NF_MATCH_SRH=module;
IP6_NF_TARGET_HL=module;
IP6_NF_FILTER=module;
IP6_NF_TARGET_REJECT=module;
IP6_NF_TARGET_SYNPROXY=module;
IP6_NF_MANGLE=module;
IP6_NF_RAW=module;
IP6_NF_NAT=module;
IP6_NF_TARGET_MASQUERADE=module;
IP6_NF_TARGET_NPT=module;
IP_DCCP=module;
IP_SCTP=module;
L2TP=module;
BRIDGE=module;
BRIDGE_VLAN_FILTERING=yes;
VLAN_8021Q=module;
NET_SCHED=yes;
NET_CLS_CGROUP=module;
NET_CLS_BPF=module;
NET_CLS_MATCHALL=module;
NETLINK_DIAG=yes;
CGROUP_NET_PRIO=yes;
CAN=yes;
IPMS_CAN=module;
BT=module;
BT_RFCOMM=yes;
BT_RFCOMM_TTY=yes;
BT_BNEP=yes;
BT_BNEP_MC_FILTER=yes;
BT_BNEP_PROTO_FILTER=yes;
BT_HIDP=yes;
BT_HS=yes;
BT_LEDS=yes;
BT_MSFTEXT=yes;
BT_AOSPEXT=yes;
BT_HCIBTUSB=module;
BT_HCIUART=module;
BT_HCIUART_H4=yes;
CFG80211=yes;
MAC80211=yes;
MAC80211_LEDS=yes;
RFKILL=yes;
RFKILL_GPIO=yes;
NET_9P=yes;
NET_9P_VIRTIO=yes;
PCI=yes;
# CONFIG_PCIEASPM is not set
PCIE_PLDA=yes;
DEVTMPFS=yes;
DEVTMPFS_MOUNT=yes;
MTD=yes;
MTD_BLOCK=yes;
MTD_SPI_NOR=yes;
OF_CONFIGFS=yes;
BLK_DEV_LOOP=yes;
BLK_DEV_NVME=yes;
# EEPROM_AT24=yes;
EEPROM_93CX6=yes;
SCSI=yes;
BLK_DEV_SD=yes;
BLK_DEV_SR=yes;
# CONFIG_SCSI_LOWLEVEL is not set
NETDEVICES=yes;
DUMMY=module;
WIREGUARD=module;
MACVLAN=module;
MACVTAP=module;
IPVLAN=module;
VXLAN=module;
TUN=module;
VETH=module;
VORTEX=module;
TYPHOON=module;
ADAPTEC_STARFIRE=module;
ET131X=module;
# CONFIG_NET_VENDOR_ALACRITECH is not set
# CONFIG_NET_VENDOR_AMAZON is not set
AMD8111_ETH=module;
PCNET32=module;
# CONFIG_NET_VENDOR_AQUANTIA is not set
# CONFIG_NET_VENDOR_ARC is not set
ATL2=module;
ATL1=module;
ATL1E=module;
ATL1C=module;
ALX=module;
B44=module;
BCMGENET=module;
CNIC=module;
TIGON3=module;
BNX2X=module;
SYSTEMPORT=module;
BNXT=module;
# CONFIG_NET_VENDOR_CADENCE is not set
# CONFIG_NET_VENDOR_CAVIUM is not set
CHELSIO_T1=module;
CHELSIO_T3=module;
CHELSIO_T4=module;
CHELSIO_T4VF=module;
ENIC=module;
# CONFIG_NET_VENDOR_CORTINA is not set
DL2K=module;
SUNDANCE=module;
# CONFIG_NET_VENDOR_EZCHIP is not set
# CONFIG_NET_VENDOR_GOOGLE is not set
# CONFIG_NET_VENDOR_HUAWEI is not set
E100=module;
E1000=module;
E1000E=module;
IGB=module;
IGBVF=module;
IXGB=module;
IXGBE=module;
IXGBEVF=module;
I40E=module;
I40EVF=module;
ICE=module;
FM10K=module;
IGC=module;
SKGE=module;
SKY2=module;
MLX4_EN=module;
MLX5_CORE=module;
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
# CONFIG_NET_VENDOR_MICROSEMI is not set
MYRI10GE=module;
FEALNX=module;
# CONFIG_NET_VENDOR_NI is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
S2IO=module;
VXGE=module;
# CONFIG_NET_VENDOR_NETRONOME is not set
FORCEDETH=module;
# CONFIG_NET_VENDOR_PENSANDO is not set
# CONFIG_NET_VENDOR_QUALCOMM is not set
"8139CP"=module;
"8139TOO"=module;
R8169=yes;
# CONFIG_NET_VENDOR_RENESAS is not set
# CONFIG_NET_VENDOR_ROCKER is not set
# CONFIG_NET_VENDOR_SAMSUNG is not set
# CONFIG_NET_VENDOR_SEEQ is not set
SC92031=module;
SIS900=module;
SIS190=module;
# CONFIG_NET_VENDOR_SOLARFLARE is not set
EPIC100=module;
SMSC911X=module;
SMSC9420=module;
# CONFIG_NET_VENDOR_SOCIONEXT is not set
STMMAC_ETH=yes;
STMMAC_SELFTESTS=yes;
# DWMAC_DWC_QOS_ETH=yes;
# DWMAC_STARFIVE_PLAT=yes;
# CONFIG_NET_VENDOR_SUN is not set
# CONFIG_NET_VENDOR_SYNOPSYS is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
# CONFIG_NET_VENDOR_TI is not set
# CONFIG_NET_VENDOR_VIA is not set
WIZNET_W5100=module;
WIZNET_W5300=module;
WIZNET_W5100_SPI=module;
MARVELL_PHY=module;
MICREL_PHY=yes;
MOTORCOMM_PHY=yes;
PPP=module;
PPP_BSDCOMP=module;
PPP_DEFLATE=module;
PPP_MPPE=module;
PPPOE=module;
PPPOL2TP=module;
PPP_ASYNC=module;
PPP_SYNC_TTY=module;
SLIP=module;
SLIP_COMPRESSED=yes;
SLIP_SMART=yes;
SLIP_MODE_SLIP6=yes;
USB_NET_DRIVERS=module;
USB_CATC=module;
USB_KAWETH=module;
USB_PEGASUS=module;
USB_RTL8150=module;
USB_RTL8152=module;
USB_LAN78XX=module;
USB_USBNET=module;
USB_NET_CDC_EEM=module;
USB_NET_HUAWEI_CDC_NCM=module;
USB_NET_CDC_MBIM=module;
USB_NET_DM9601=module;
USB_NET_SR9700=module;
USB_NET_SR9800=module;
USB_NET_SMSC75XX=module;
USB_NET_SMSC95XX=module;
USB_NET_GL620A=module;
USB_NET_PLUSB=module;
USB_NET_MCS7830=module;
USB_NET_RNDIS_HOST=module;
USB_NET_CX82310_ETH=module;
USB_NET_KALMIA=module;
USB_NET_QMI_WWAN=module;
USB_NET_INT51X1=module;
USB_IPHETH=module;
USB_SIERRA_NET=module;
USB_VL600=module;
USB_NET_CH9200=module;
USB_NET_AQC111=module;
# CONFIG_WLAN_VENDOR_ADMTEK is not set
# CONFIG_WLAN_VENDOR_ATH is not set
# CONFIG_WLAN_VENDOR_ATMEL is not set
# CONFIG_WLAN_VENDOR_BROADCOM is not set
# CONFIG_WLAN_VENDOR_CISCO is not set
# CONFIG_WLAN_VENDOR_INTEL is not set
# CONFIG_WLAN_VENDOR_INTERSIL is not set
# CONFIG_WLAN_VENDOR_MARVELL is not set
# CONFIG_WLAN_VENDOR_MEDIATEK is not set
# CONFIG_WLAN_VENDOR_MICROCHIP is not set
# CONFIG_WLAN_VENDOR_RALINK is not set
# CONFIG_WLAN_VENDOR_REALTEK is not set
# CONFIG_WLAN_VENDOR_RSI is not set
# CONFIG_WLAN_VENDOR_ST is not set
# CONFIG_WLAN_VENDOR_TI is not set
# CONFIG_WLAN_VENDOR_ZYDAS is not set
# CONFIG_WLAN_VENDOR_QUANTENNA is not set
NET_FAILOVER=yes;
INPUT_EVDEV=yes;
# CONFIG_KEYBOARD_ATKBD is not set
KEYBOARD_GPIO=yes;
KEYBOARD_GPIO_POLLED=yes;
KEYBOARD_MATRIX=module;
# CONFIG_MOUSE_PS2 is not set
MOUSE_APPLETOUCH=module;
MOUSE_BCM5974=module;
MOUSE_GPIO=module;
MOUSE_SYNAPTICS_I2C=module;
MOUSE_SYNAPTICS_USB=module;
INPUT_TABLET=yes;
INPUT_TOUCHSCREEN=yes;
# TOUCHSCREEN_GOODIX=yes;
# TOUCHSCREEN_TINKER_FT5406=yes;
SERIAL_8250=yes;
SERIAL_8250_CONSOLE=yes;
SERIAL_8250_NR_UARTS=freeform "6";
SERIAL_8250_RUNTIME_UARTS=freeform "6";
SERIAL_8250_EXTENDED=yes;
SERIAL_8250_MANY_PORTS=yes;
SERIAL_8250_DW=yes;
SERIAL_OF_PLATFORM=yes;
SERIAL_EARLYCON_RISCV_SBI=yes;
HVC_RISCV_SBI=yes;
TTY_PRINTK=yes;
HW_RANDOM=yes;
HW_RANDOM_STARFIVE=yes;
# I2C_CHARDEV=yes;
# I2C_DESIGNWARE_PLATFORM=yes;
I2C_SLAVE=yes;
I2C_SLAVE_EEPROM=module;
I2C_SLAVE_TESTUNIT=module;
SPI=yes;
SPI_CADENCE_QUADSPI=yes;
SPI_PL022_STARFIVE=yes;
SPI_SIFIVE=yes;
SPI_SPIDEV=yes;
# CONFIG_PTP_1588_CLOCK is not set
PINCTRL=yes;
PINCTRL_STARFIVE=yes;
PINCTRL_STARFIVE_JH7110=yes;
GPIO_SYSFS=yes;
GPIO_STARFIVE_JH7110=yes;
GPIO_ADP5588=module;
GPIO_ADNP=module;
GPIO_GW_PLD=module;
GPIO_MAX7300=module;
GPIO_MAX732X=module;
GPIO_PCA953X=module;
GPIO_PCA9570=module;
GPIO_PCF857X=module;
GPIO_TPIC2810=module;
GPIO_BT8XX=module;
GPIO_PCI_IDIO_16=module;
GPIO_PCIE_IDIO_24=module;
GPIO_RDC321X=module;
GPIO_74X164=module;
GPIO_MAX3191X=module;
GPIO_MAX7301=module;
GPIO_MC33880=module;
GPIO_PISOSR=module;
GPIO_XRA1403=module;
W1=module;
W1_MASTER_GPIO=module;
W1_SLAVE_THERM=module;
W1_SLAVE_SMEM=module;
W1_SLAVE_DS2405=module;
W1_SLAVE_DS2408=module;
W1_SLAVE_DS2413=module;
W1_SLAVE_DS2406=module;
W1_SLAVE_DS2423=module;
W1_SLAVE_DS2805=module;
W1_SLAVE_DS2430=module;
W1_SLAVE_DS2431=module;
W1_SLAVE_DS2433=module;
W1_SLAVE_DS2438=module;
W1_SLAVE_DS250X=module;
W1_SLAVE_DS2780=module;
W1_SLAVE_DS2781=module;
W1_SLAVE_DS28E04=module;
W1_SLAVE_DS28E17=module;
POWER_RESET=yes;
POWER_RESET_GPIO_RESTART=yes;
POWER_RESET_SYSCON=yes;
POWER_RESET_SYSCON_POWEROFF=yes;
# BATTERY_CW2015=yes;
# CHARGER_BQ25890=yes;
SENSORS_GPIO_FAN=module;
SENSORS_SFCTEMP=yes;
THERMAL=yes;
THERMAL_WRITABLE_TRIPS=yes;
CPU_THERMAL=yes;
THERMAL_EMULATION=yes;
WATCHDOG=yes;
WATCHDOG_SYSFS=yes;
STARFIVE_WATCHDOG=yes;
REGULATOR=yes;
REGULATOR_FIXED_VOLTAGE=yes;
# REGULATOR_AXP15060=yes;
# CONFIG_MEDIA_CEC_SUPPORT is not set
MEDIA_SUPPORT=yes;
MEDIA_USB_SUPPORT=yes;
# USB_VIDEO_CLASS=yes;
V4L_PLATFORM_DRIVERS=yes;
# VIDEO_STF_VIN=yes;
# VIN_SENSOR_IMX219=yes;
V4L_MEM2MEM_DRIVERS=yes;
VIDEO_WAVE_VPU=module;
VIDEO_GC02M2=module;
VIDEO_OV5640=module;
DRM_PANEL_BOE_TH101MB31UIG002_28A=yes;
DRM_PANEL_JADARD_JD9365DA_H3=yes;
DRM_VERISILICON=yes;
STARFIVE_INNO_HDMI=yes;
STARFIVE_DSI=yes;
DRM_IMG_ROGUE=module;
# DRM_LEGACY=yes;
FB=yes;
BACKLIGHT_CLASS_DEVICE=yes;
BACKLIGHT_PWM=yes;
BACKLIGHT_GPIO=yes;
BACKLIGHT_LED=yes;
FRAMEBUFFER_CONSOLE=yes;
FRAMEBUFFER_CONSOLE_ROTATION=yes;
SOUND=yes;
SND=yes;
SND_USB_AUDIO=yes;
SND_SOC=yes;
SND_DESIGNWARE_I2S=yes;
SND_SOC_STARFIVE=yes;
SND_SOC_STARFIVE_PWMDAC=yes;
SND_SOC_STARFIVE_I2S=yes;
SND_SOC_AC108=yes;
SND_SOC_ES8316=yes;
SND_SOC_SIMPLE_AMPLIFIER=yes;
SND_SOC_WM8960=yes;
SND_SIMPLE_CARD=yes;
HID_BATTERY_STRENGTH=yes;
HID_MULTITOUCH=yes;
USB_LED_TRIG=yes;
USB=yes;
USB_OTG=yes;
USB_OTG_PRODUCTLIST=yes;
USB_OTG_FSM=yes;
USB_XHCI_HCD=yes;
USB_EHCI_HCD=yes;
USB_EHCI_ROOT_HUB_TT=yes;
USB_EHCI_HCD_PLATFORM=yes;
USB_ACM=yes;
USB_WDM=yes;
USB_STORAGE=module;
USB_UAS=module;
USBIP_CORE=module;
USBIP_VHCI_HCD=module;
USBIP_HOST=module;
USB_CDNS_SUPPORT=yes;
USB_CDNS3=yes;
USB_CDNS3_HOST=yes;
USB_CDNS3_STARFIVE=yes;
USB_SERIAL=module;
USB_SERIAL_GENERIC=yes;
USB_SERIAL_SIMPLE=module;
USB_SERIAL_AIRCABLE=module;
USB_SERIAL_ARK3116=module;
USB_SERIAL_BELKIN=module;
USB_SERIAL_CH341=module;
USB_SERIAL_WHITEHEAT=module;
USB_SERIAL_DIGI_ACCELEPORT=module;
USB_SERIAL_CP210X=module;
USB_SERIAL_CYPRESS_M8=module;
USB_SERIAL_EMPEG=module;
USB_SERIAL_FTDI_SIO=module;
USB_SERIAL_VISOR=module;
USB_SERIAL_IPAQ=module;
USB_SERIAL_IR=module;
USB_SERIAL_EDGEPORT=module;
USB_SERIAL_EDGEPORT_TI=module;
USB_SERIAL_F81232=module;
USB_SERIAL_F8153X=module;
USB_SERIAL_GARMIN=module;
USB_SERIAL_IPW=module;
USB_SERIAL_IUU=module;
USB_SERIAL_KEYSPAN_PDA=module;
USB_SERIAL_KEYSPAN=module;
USB_SERIAL_KLSI=module;
USB_SERIAL_KOBIL_SCT=module;
USB_SERIAL_MCT_U232=module;
USB_SERIAL_METRO=module;
USB_SERIAL_MOS7720=module;
USB_SERIAL_MOS7840=module;
USB_SERIAL_MXUPORT=module;
USB_SERIAL_NAVMAN=module;
USB_SERIAL_PL2303=module;
USB_SERIAL_OTI6858=module;
USB_SERIAL_QCAUX=module;
USB_SERIAL_QUALCOMM=module;
USB_SERIAL_SPCP8X5=module;
USB_SERIAL_SAFE=module;
USB_SERIAL_SAFE_PADDED=yes;
USB_SERIAL_SIERRAWIRELESS=module;
USB_SERIAL_SYMBOL=module;
USB_SERIAL_TI=module;
USB_SERIAL_CYBERJACK=module;
USB_SERIAL_OPTION=module;
USB_SERIAL_OMNINET=module;
USB_SERIAL_OPTICON=module;
USB_SERIAL_XSENS_MT=module;
USB_SERIAL_WISHBONE=module;
USB_SERIAL_SSU100=module;
USB_SERIAL_QT2=module;
USB_SERIAL_UPD78F0730=module;
USB_SERIAL_XR=module;
USB_EZUSB_FX2=yes;
NOP_USB_XCEIV=yes;
USB_GPIO_VBUS=yes;
USB_ISP1301=yes;
MMC=yes;
MMC_DEBUG=yes;
MMC_SDHCI=yes;
MMC_SDHCI_PLTFM=yes;
MMC_SDHCI_OF_DWCMSHC=yes;
MMC_SPI=yes;
MMC_DW=yes;
MMC_DW_STARFIVE=yes;
NEW_LEDS=yes;
LEDS_CLASS=yes;
LEDS_GPIO=yes;
LEDS_PWM=module;
LEDS_BLINKM=module;
LEDS_TRIGGER_TIMER=yes;
LEDS_TRIGGER_ONESHOT=yes;
LEDS_TRIGGER_MTD=yes;
LEDS_TRIGGER_HEARTBEAT=yes;
LEDS_TRIGGER_BACKLIGHT=yes;
LEDS_TRIGGER_CPU=yes;
LEDS_TRIGGER_ACTIVITY=yes;
LEDS_TRIGGER_GPIO=yes;
LEDS_TRIGGER_DEFAULT_ON=yes;
LEDS_TRIGGER_TRANSIENT=yes;
LEDS_TRIGGER_CAMERA=yes;
LEDS_TRIGGER_PANIC=yes;
LEDS_TRIGGER_NETDEV=yes;
LEDS_TRIGGER_PATTERN=yes;
LEDS_TRIGGER_AUDIO=yes;
LEDS_TRIGGER_TTY=yes;
RTC_CLASS=yes;
RTC_HCTOSYS_DEVICE=freeform "rtc1";
RTC_DRV_HYM8563=yes;
RTC_DRV_STARFIVE=yes;
DMADEVICES=yes;
DW_AXI_DMAC=yes;
DMATEST=yes;
# CONFIG_VIRTIO_MENU is not set
# CONFIG_VHOST_MENU is not set
STAGING=yes;
RTL8852BU=module;
STARFIVE_TIMER=yes;
MAILBOX=yes;
STARFIVE_MBOX=module;
STARFIVE_MBOX_TEST=module;
# CONFIG_IOMMU_SUPPORT is not set
RPMSG_CHAR=yes;
RPMSG_VIRTIO=yes;
SIFIVE_L2_FLUSH_START=freeform "0x40000000";
SIFIVE_L2_FLUSH_SIZE=freeform "0x400000000";
STARFIVE_PMU=yes;
PWM=yes;
PWM_STARFIVE_PTC=yes;
PHY_M31_DPHY_RX0=yes;
RAS=yes;
CPU_FREQ=yes;
CPU_FREQ_STAT=yes;
CPU_FREQ_DEFAULT_GOV_ONDEMAND=yes;
CPU_FREQ_GOV_POWERSAVE=yes;
CPU_FREQ_GOV_USERSPACE=yes;
CPU_FREQ_GOV_CONSERVATIVE=yes;
CPU_FREQ_GOV_SCHEDUTIL=yes;
CPUFREQ_DT=yes;
EXT4_FS=yes;
EXT4_FS_POSIX_ACL=yes;
EXT4_FS_SECURITY=yes;
XFS_FS=module;
XFS_QUOTA=yes;
XFS_POSIX_ACL=yes;
BTRFS_FS=module;
BTRFS_FS_POSIX_ACL=yes;
AUTOFS4_FS=yes;
FUSE_FS=yes;
CUSE=yes;
VIRTIO_FS=yes;
OVERLAY_FS=yes;
OVERLAY_FS_INDEX=yes;
OVERLAY_FS_XINO_AUTO=yes;
OVERLAY_FS_METACOPY=yes;
ISO9660_FS=module;
JOLIET=yes;
ZISOFS=yes;
UDF_FS=module;
MSDOS_FS=yes;
OAVFAT_FS=yes;
FAT_DEFAULT_UTF8=yes;
EXFAT_FS=yes;
# NTFS_FS=yes;
NTFS_RW=yes;
NTFS3_FS=module;
NTFS3_64BIT_CLUSTER=yes;
NTFS3_LZX_XPRESS=yes;
NTFS3_FS_POSIX_ACL=yes;
TMPFS=yes;
TMPFS_POSIX_ACL=yes;
HUGETLBFS=yes;
JFFS2_FS=yes;
NFS_FS=yes;
NFS_V4=yes;
NFS_V4_1=yes;
NFS_V4_2=yes;
ROOT_NFS=yes;
NFSD=module;
NFSD_V3_ACL=yes;
NFSD_V4=yes;
NFSD_BLOCKLAYOUT=yes;
NFSD_SCSILAYOUT=yes;
NFSD_FLEXFILELAYOUT=yes;
NFSD_V4_2_INTER_SSC=yes;
CIFS=module;
SMB_SERVER=module;
# NLS_CODEPAGE_437=yes;
# NLS_ISO8859_1=yes;
SECURITY=yes;
SECURITY_NETWORK_XFRM=yes;
SECURITY_SELINUX=yes;
SECURITY_APPARMOR=yes;
DEFAULT_SECURITY_DAC=yes;
CRYPTO_USER=yes;
# CRYPTO_TEST=module;
CRYPTO_ECDH=yes;
CRYPTO_ECB=yes;
CRYPTO_MICHAEL_MIC=yes;
CRYPTO_SHA512=yes;
CRYPTO_USER_API_HASH=yes;
CRYPTO_USER_API_SKCIPHER=yes;
CRYPTO_USER_API_RNG=yes;
CRYPTO_USER_API_AEAD=yes;
CRYPTO_USER_API_AKCIPHER=yes;
CRYPTO_DEV_VIRTIO=yes;
CRYPTO_DEV_JH7110_ENCRYPT=yes;
LIBCRC32C=yes;
DMA_CMA=yes;
PRINTK_TIME=yes;
DYNAMIC_DEBUG=yes;
DEBUG_FS=yes;
# CONFIG_DEBUG_MISC is not set
SOFTLOCKUP_DETECTOR=yes;
WQ_WATCHDOG=yes;
STACKTRACE=yes;
# CONFIG_RCU_TRACE is not set
RCU_EQS_DEBUG=yes;
# CONFIG_FTRACE is not set
# CONFIG_RUNTIME_TESTING_MENU is not set
MEMTEST=yes;
    };
    extraMeta.branch = "5.15";
  };
  
in buildLinux (linux-ptv // args.argsOverride or { })
