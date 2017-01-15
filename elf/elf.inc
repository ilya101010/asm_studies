; >>> ELF header
struc ehdr i
{
	virtual at i
		.e_ident.ei_mag dd ?
		.e_ident.ei_class db ?
		.e_ident.ei_data db ?
		.e_ident.ei_version db ?
		.e_ident.ei_osabi db ?
		.e_ident.ei_abiversion db ?
		times 7 db ? ; ei_pad - unused
		.e_type dw ?
		.e_machine dw ?
		.e_version dd ?
		.e_entry dd ?
		.e_phoff dd ?
		.e_shoff dd ?
		.e_flags dd ?
		.e_ehsize dw ?
		.e_phentsize dw ?
		.e_phnum dw ?
		.e_shentsize dw ?
		.e_shnum dw ?
		.e_shstrndx dw ?
	end virtual
}

ehdr_size = 32h

; >>> Section Header
struc shdr i
{
	virtual at i
		.sh_name dd ?
		.sh_type dd ?
		.sh_flags dd ?
		.sh_addr dd ?
		.sh_offset dd ?
		.sh_size dd ?
		.sh_link dd ?
		.sh_info dd ?
		.sh_addralign dd ?
		.sh_entsize dd ?
	end virtual
}

shdr_size = 40

; >>> Symbol
struc sym i
{
	virtual at i
		.st_name dd ?
		.st_value dd ?
		.st_size dd ?
		.st_info db ?
		.st_other db ?
		.st_shndx dw ?
	end virtual
}

sym_size = 16

; >>> Program header

struc program i
{
	virtual at i
		.p_type dw ?
		.p_offset dw ?
		.p_vaddr dw ?
		.p_paddr
	end virtual
}

phdr_size = 32