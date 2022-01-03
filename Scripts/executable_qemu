qemu-system-x86_64 \
-m 10G \
-net nic -net user,smb=/home/lyh/Qemu/share \
-audiodev pa,id=snd0,server=unix:/run/user/1000/pulse/native,out.frequency=44100 \
-device ich9-intel-hda -device hda-output,audiodev=snd0 \
-enable-kvm \
-cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time \
-smp 4 \
/home/lyh/Qemu/Win10LTSC_main.qcow2
