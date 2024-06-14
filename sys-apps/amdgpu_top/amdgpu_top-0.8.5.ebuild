# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.2

EAPI=8

CRATES="
	ab_glyph@0.2.26
	ab_glyph_rasterizer@0.1.8
	accesskit@0.12.3
	adler@1.0.2
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.18
	android-activity@0.5.2
	android-properties@0.2.2
	android_system_properties@0.1.5
	anyhow@1.0.86
	arboard@3.4.0
	arc-swap@1.7.1
	arrayvec@0.7.4
	as-raw-xcb-connection@1.0.1
	ash@0.37.3+1.3.251
	atomic-waker@1.1.2
	autocfg@1.3.0
	base64@0.21.7
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.5.0
	block-buffer@0.10.4
	block-sys@0.2.1
	block2@0.3.0
	block2@0.5.0
	block@0.1.6
	bstr@1.9.1
	bumpalo@3.16.0
	bytemuck@1.16.0
	bytemuck_derive@1.6.0
	byteorder@1.5.0
	bytes@1.6.0
	calloop-wayland-source@0.2.0
	calloop@0.12.4
	cc@1.0.97
	cesu8@1.1.0
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	cgl@0.3.2
	clipboard-win@5.3.1
	clru@0.6.2
	cocoa-foundation@0.1.2
	cocoa@0.25.0
	codespan-reporting@0.11.1
	color_quant@1.1.0
	com@0.6.0
	com_macros@0.6.0
	com_macros_support@0.6.0
	combine@4.6.7
	concurrent-queue@2.5.0
	core-foundation-sys@0.8.6
	core-foundation@0.9.4
	core-graphics-types@0.1.3
	core-graphics@0.23.2
	cpufeatures@0.2.12
	crc32fast@1.4.0
	crossbeam-channel@0.5.12
	crossbeam-utils@0.8.19
	crossterm@0.25.0
	crossterm_winapi@0.9.1
	crypto-common@0.1.6
	cursive@0.20.0
	cursive_core@0.3.7
	cursor-icon@1.1.0
	darling@0.20.9
	darling_core@0.20.9
	darling_macro@0.20.9
	dashmap@5.5.3
	deranged@0.3.11
	digest@0.10.7
	directories-next@2.0.0
	dirs-sys-next@0.1.2
	dispatch@0.2.0
	displaydoc@0.2.4
	dlib@0.5.2
	document-features@0.2.8
	downcast-rs@1.2.1
	dunce@1.0.4
	ecolor@0.27.2
	eframe@0.27.2
	egui-wgpu@0.27.2
	egui-winit@0.27.2
	egui@0.27.2
	egui_glow@0.27.2
	egui_plot@0.27.2
	emath@0.27.2
	enum-map-derive@0.17.0
	enum-map@2.7.3
	enumn@0.1.13
	enumset@1.1.3
	enumset_derive@0.8.1
	epaint@0.27.2
	equivalent@1.0.1
	errno@0.3.9
	error-code@3.2.0
	faster-hex@0.9.0
	fastrand@2.1.0
	fdeflate@0.3.4
	find-crate@0.6.3
	flate2@1.0.30
	fluent-bundle@0.15.3
	fluent-langneg@0.13.0
	fluent-syntax@0.11.1
	fluent@0.16.1
	fnv@1.0.7
	foreign-types-macros@0.2.3
	foreign-types-shared@0.3.1
	foreign-types@0.5.0
	form_urlencoded@1.2.1
	generic-array@0.14.7
	gethostname@0.4.3
	getrandom@0.2.15
	gix-actor@0.31.1
	gix-chunk@0.4.8
	gix-commitgraph@0.24.2
	gix-config-value@0.14.6
	gix-config@0.36.1
	gix-date@0.8.6
	gix-diff@0.42.0
	gix-discover@0.31.0
	gix-features@0.38.1
	gix-fs@0.10.2
	gix-glob@0.16.2
	gix-hash@0.14.2
	gix-hashtable@0.5.2
	gix-lock@13.1.1
	gix-macros@0.1.4
	gix-object@0.42.1
	gix-odb@0.59.0
	gix-pack@0.49.0
	gix-path@0.10.7
	gix-quote@0.4.12
	gix-ref@0.43.0
	gix-refspec@0.23.0
	gix-revision@0.27.0
	gix-revwalk@0.13.0
	gix-sec@0.10.6
	gix-tempfile@13.1.1
	gix-trace@0.1.9
	gix-traverse@0.38.0
	gix-url@0.27.3
	gix-utils@0.1.12
	gix-validate@0.8.4
	gix@0.61.0
	gl_generator@0.14.0
	glow@0.13.1
	glutin-winit@0.4.2
	glutin@0.31.3
	glutin_egl_sys@0.6.0
	glutin_glx_sys@0.5.0
	glutin_wgl_sys@0.5.0
	gpu-alloc-types@0.3.0
	gpu-alloc@0.6.0
	gpu-allocator@0.25.0
	gpu-descriptor-types@0.1.2
	gpu-descriptor@0.2.4
	hashbrown@0.14.5
	hassle-rs@0.11.0
	hermit-abi@0.3.9
	hexf-parse@0.2.1
	home@0.5.9
	i18n-config@0.4.6
	i18n-embed-fl@0.7.0
	i18n-embed-impl@0.8.3
	i18n-embed@0.14.1
	icrate@0.0.4
	ident_case@1.0.1
	idna@0.5.0
	image@0.24.9
	indexmap@2.2.6
	intl-memoizer@0.5.2
	intl_pluralrules@7.0.2
	itoa@1.0.11
	jni-sys@0.3.0
	jni@0.21.1
	jobserver@0.1.31
	js-sys@0.3.69
	khronos-egl@6.0.0
	khronos_api@3.1.0
	lazy_static@1.4.0
	libc@0.2.154
	libloading@0.7.4
	libloading@0.8.3
	libredox@0.0.2
	libredox@0.1.3
	linux-raw-sys@0.4.13
	litrs@0.4.1
	locale_config@0.3.0
	lock_api@0.4.12
	log@0.4.21
	malloc_buf@0.0.6
	memchr@2.7.2
	memmap2@0.9.4
	memoffset@0.9.1
	metal@0.27.0
	miniz_oxide@0.7.2
	mio@0.8.11
	naga@0.19.2
	ndk-context@0.1.1
	ndk-sys@0.5.0+25.2.9519653
	ndk@0.8.0
	nohash-hasher@0.2.0
	num-complex@0.4.6
	num-conv@0.1.0
	num-integer@0.1.46
	num-iter@0.1.45
	num-rational@0.4.2
	num-traits@0.2.19
	num@0.4.3
	num_enum@0.7.2
	num_enum_derive@0.7.2
	num_threads@0.1.7
	objc-foundation@0.1.1
	objc-sys@0.3.3
	objc2-app-kit@0.2.0
	objc2-core-data@0.2.0
	objc2-encode@3.0.0
	objc2-encode@4.0.1
	objc2-foundation@0.2.0
	objc2@0.4.1
	objc2@0.5.1
	objc@0.2.7
	objc_exception@0.1.2
	objc_id@0.1.1
	once_cell@1.19.0
	orbclient@0.3.47
	owned_ttf_parser@0.21.0
	owning_ref@0.4.1
	parking_lot@0.12.2
	parking_lot_core@0.9.10
	paste@1.0.15
	percent-encoding@2.3.1
	pin-project-lite@0.2.14
	pkg-config@0.3.30
	png@0.17.13
	polling@3.7.0
	powerfmt@0.2.0
	presser@0.3.1
	proc-macro-crate@3.1.0
	proc-macro-error-attr@1.0.4
	proc-macro-error@1.0.4
	proc-macro2@1.0.82
	prodash@28.0.0
	profiling@1.0.15
	quick-xml@0.31.0
	quote@1.0.36
	raw-window-handle@0.5.2
	raw-window-handle@0.6.1
	redox_syscall@0.3.5
	redox_syscall@0.4.1
	redox_syscall@0.5.1
	redox_users@0.4.5
	regex-automata@0.4.6
	regex-syntax@0.8.3
	regex@1.10.4
	renderdoc-sys@1.1.0
	ron@0.8.1
	rust-embed-impl@8.4.0
	rust-embed-utils@8.4.0
	rust-embed@8.4.0
	rustc-hash@1.1.0
	rustix@0.38.34
	ryu@1.0.18
	same-file@1.0.6
	scoped-tls@1.0.1
	scopeguard@1.2.0
	self_cell@0.10.3
	self_cell@1.0.4
	serde@1.0.202
	serde_derive@1.0.202
	serde_json@1.0.117
	serde_spanned@0.6.6
	sha1_smol@1.0.0
	sha2@0.10.8
	signal-hook-mio@0.2.3
	signal-hook-registry@1.4.2
	signal-hook@0.3.17
	simd-adler32@0.3.7
	slab@0.4.9
	slotmap@1.0.7
	smallvec@1.13.2
	smithay-client-toolkit@0.18.1
	smithay-clipboard@0.7.1
	smol_str@0.2.2
	spirv@0.3.0+sdk-1.3.268.0
	stable_deref_trait@1.2.0
	static_assertions@1.1.0
	strsim@0.10.0
	syn@1.0.109
	syn@2.0.63
	tempfile@3.10.1
	termcolor@1.4.1
	thiserror-impl@1.0.60
	thiserror@1.0.60
	time-core@0.1.2
	time-macros@0.2.18
	time@0.3.36
	tinystr@0.7.5
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	toml@0.5.11
	toml@0.8.13
	toml_datetime@0.6.6
	toml_edit@0.21.1
	toml_edit@0.22.13
	tracing-core@0.1.32
	tracing@0.1.40
	ttf-parser@0.21.1
	type-map@0.5.0
	typenum@1.17.0
	unic-langid-impl@0.9.5
	unic-langid@0.9.5
	unicode-bidi@0.3.15
	unicode-bom@2.0.3
	unicode-ident@1.0.12
	unicode-normalization@0.1.23
	unicode-segmentation@1.11.0
	unicode-width@0.1.12
	unicode-xid@0.2.4
	url@2.5.0
	version_check@0.9.4
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-futures@0.4.42
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	wayland-backend@0.3.3
	wayland-client@0.31.2
	wayland-csd-frame@0.3.0
	wayland-cursor@0.31.1
	wayland-protocols-plasma@0.2.0
	wayland-protocols-wlr@0.2.0
	wayland-protocols@0.31.2
	wayland-scanner@0.31.1
	wayland-sys@0.31.1
	web-sys@0.3.69
	web-time@0.2.4
	webbrowser@0.8.15
	wgpu-core@0.19.4
	wgpu-hal@0.19.4
	wgpu-types@0.19.2
	wgpu@0.19.4
	widestring@1.1.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.8
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.42.2
	windows-targets@0.48.5
	windows-targets@0.52.5
	windows@0.52.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.5
	winit@0.29.15
	winnow@0.5.40
	winnow@0.6.8
	x11-dl@2.21.0
	x11rb-protocol@0.13.1
	x11rb@0.13.1
	xcursor@0.3.5
	xi-unicode@0.3.0
	xkbcommon-dl@0.4.2
	xkeysym@0.2.0
	xml-rs@0.8.20
	zerocopy-derive@0.7.34
	zerocopy@0.7.34
"

declare -A GIT_CRATES=(
	[libdrm_amdgpu_sys]='https://github.com/Umio-Yasuno/libdrm-amdgpu-sys-rs;b5e281176c6ba5c15379b2bb832d1b37e83e673f;libdrm-amdgpu-sys-rs-%commit%'
)

inherit desktop cargo

DESCRIPTION="Tool to displays AMDGPU usage."
HOMEPAGE="https://github.com/Umio-Yasuno/amdgpu_top"
SRC_URI="
	https://github.com/Umio-Yasuno/amdgpu_top/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC MIT OFL-1.1 Unicode-DFS-2016
	ZLIB
"
# tinystr
LICENSE+="
	Apache-2.0 MIT
"

SLOT="0"
KEYWORDS="~amd64"

IUSE="man"

BDEPEND="
	man? (
		|| (
			app-text/lowdown
			virtual/pandoc
		)
	)
"

QA_PRESTRIPPED="/usr/bin/amdgpu_top"

DOCS=(
	README.md
)

src_compile() {
	cargo_src_compile

	if use man; then
		local docgen=lowdown

		# prefer pandoc if it's installed
		has_version virtual/pandoc && docgen=pandoc

		"${docgen}" docs/man.${PN}.md -s -t man -o docs/${PN}.1 \
			|| die "failed to generate man page with ${docgen}"
	fi
}

src_install() {
	cargo_src_install

	use man && doman docs/${PN}.1
	domenu assets/*.desktop
	dodoc "${DOCS[@]}" docs/*
}
