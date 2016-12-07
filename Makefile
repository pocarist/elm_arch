PKGS = lwt.ppx,js_of_ocaml,js_of_ocaml.ppx,js_of_ocaml.tyxml,tyxml,ppx_deriving,js_of_ocaml.deriving.ppx,js_of_ocaml.deriving,react,reactiveData
CFLAGS = -w,-40 #-w,A-4-32-39-42
OUTPUT = button.js
SRCS = button.ml elm_arch.ml

all: $(OUTPUT)

$(OUTPUT): $(SRCS)

# Compile OCaml source file to OCaml bytecode
%.byte: %.ml
	ocamlbuild -use-ocamlfind -cflags $(CFLAGS) -pkgs $(PKGS) $@

# Build JS code from the OCaml bytecode
%.js: %.byte
	js_of_ocaml +weak.js --opt 3 -o $@ $<

clean:
	rm -f $(OUTPUT)
	ocamlbuild -clean

