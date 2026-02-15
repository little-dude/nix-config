{pkgs, ...}: {
  home.packages = with pkgs; [
    sniffnet
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc
    wireshark
  ];
}
