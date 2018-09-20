include 'include_library.inc'
include 'ez80.inc'
include 'ti84pceg.inc'
include 'tiformat.inc'

macro library? name*, version*, magic: <192,193>
	local lib
	iterate section, exports, dependencies, relocations
		virtual
			lib.section.area::
		end virtual
	end iterate
	virtual as 'lib'
		lib.exports.file::
		repeat 1, string: version
			db 'library', 9, '"', name, '", ', `string, 10
		end repeat
	end virtual

	format ti archived appvar name
	org 0
	db magic,version
	dw lib.exports
	element lib.relative
	lib.absolute:
	lib.offset := $%
	dw lib.dependencies
	db $B5
	dl lib.bss

	macro disable_relocations?
		org $% - lib.offset + lib.absolute
	end macro
	macro enable_relocations?
		org $% - lib.offset + lib.relative
	end macro
	enable_relocations?

	iterate each, export, export_pointer
		macro each? function*
			local offset
			virtual lib.exports.area
				dw function-lib.relative
				offset = $-$$
			end virtual
			virtual lib.exports.file
				repeat 1, string: offset
					db 9, `each, 9, `function, ' ; ', `string, 10
				end repeat
			end virtual
		end macro
	end iterate

	macro include_library? file*
		virtual lib.dependencies.area
			include_library? file
		end virtual
	end macro

	macro @ez80.word @value*
		local value, address
		value = @value
		address = $
		if value relativeto lib.relative
			virtual lib.relocations.area
				dw address-lib.relative
			end virtual
			@ez80.word value-lib.relative
		else
			@ez80.word value
		end if
	end macro

	postpone
		iterate section, exports, dependencies, relocations
			virtual lib.section.area
				load lib.section: $-$$ from $$
			end virtual
		end iterate

		lib.end := $%%
		lib.bss := $ - $@
		section 0
		dw lib.relocations
		dl lib.absolute
		dl lib.end - lib.offset
	end postpone

	purge library?
end macro
