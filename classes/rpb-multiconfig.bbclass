# rpb-multiconfig.bb: Enables 64 bit kernel with 32 bits userspace, this class adds task
# to copy 64 bit kernel output (Image, DTB, Modules) into 32 bits deployment dir and adds
# modules into 32 bits userspace. The RPB_MULTICONFIG_MACHINE_KERNEL needs to be define and
# set to be 64 bits kernel MACHINE.

MC_ARM64_TMPDIR = "${TOPDIR}/tmp-${DISTRO}-${RPB_MULTICONFIG_MACHINE_KERNEL}-${TCLIBC}"
MC_ARM64_DEPLOY_DIR_IMAGE = "${MC_ARM64_TMPDIR}/deploy/images/${RPB_MULTICONFIG_MACHINE_KERNEL}"
MC_ARM64_PKGDATA_DIR = "${MC_ARM64_TMPDIR}/pkgdata/${RPB_MULTICONFIG_MACHINE_KERNEL}"
install_arm64_kernel() {
	cp -P ${MC_ARM64_DEPLOY_DIR_IMAGE}/* ${DEPLOY_DIR_IMAGE}

	tar -xpf ${DEPLOY_DIR_IMAGE}/modules-${RPB_MULTICONFIG_MACHINE_KERNEL}.tgz -C ${IMAGE_ROOTFS}
	chown -R root:root ${IMAGE_ROOTFS}/lib/modules 

	# Make a symlink to kernel-depmod information because is needed to run depmod in rootfs
	ln -sf ${MC_ARM64_PKGDATA_DIR}/kernel-depmod ${PKGDATA_DIR}/kernel-depmod
}
ROOTFS_POSTPROCESS_COMMAND += "install_arm64_kernel; "
do_rootfs[mcdepends] = "mc::arm64:virtual/kernel:do_deploy"
