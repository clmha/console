#MAKEFILE Transform source files into deliverables

docs = $(addprefix build/, \
	CN1-MFG-001.pdf \
	CN1-REQ-001.pdf \
	)
drawings = $(addprefix build/, \
	CN1-ASY-001.pdf \
	CN1-PRT-001.pdf \
	)

sheets = $(sort $(patsubst drawing/%,sheet/%,$(patsubst %.dxf,%.pdf,$(wildcard drawing/*.dxf))))

# *
# * Office
# *
# The toolchain only uses soffice and assumes there is one document per PDF:
#
#                 soffice      1
# doc/*.od?-------------------->build/*.pdf
#          1

# Spreadsheets
build/%.pdf: doc/%.ods
	soffice --convert-to pdf --outdir build/ $^

# Text documents
build/%.pdf: doc/%.odt
	soffice --convert-to pdf --outdir build/ $^

# *
# * Drawings
# *
# The toolchain from drawings to built artefact is:
#
#               dwg2pdf  1             pdftk  1
# drawing/*.dxf---------->sheet/*.pdf--------->build/*.pdf
#              1                     1..*

# Pattern rule for converting a sheet DXF into a sheet PDF
sheet/%.pdf: drawing/%.dxf
	dwg2pdf -f -o $@ $<

all: directories $(docs) $(drawings)

build/CN1-ASY-001.pdf: $(filter sheet/CN1-ASY-001%,$(sheets))
	pdftk $^ cat output $@

build/CN1-PRT-001.pdf: $(filter sheet/CN1-PRT-001%,$(sheets))
	pdftk $^ cat output $@

.PHONY: clean directories

clean:
	del build\*.pdf
	del sheet\*.pdf

directories: build sheet

build:
	mkdir build

sheet:
	mkdir sheet
