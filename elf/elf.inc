struc sh i
{
	virtual at i
		.sh_name dd ?
		.sh_type dd ?
		.sh_flags dd ?
		.sh_addr dd ?
		.sh_offset dd ?
		.sh_size dd ?
		.sh_info dd ?
		.sh_addralign dd ?
		.sh_entsize dd ?
	end virtual
}