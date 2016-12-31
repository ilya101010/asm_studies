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