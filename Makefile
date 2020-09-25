#MAKEFILE Transform source files into deliverables

odir = build
docs = \
	$(odir)\CN1-MFG-001.pdf \
	$(odir)\CN1-REQ-001.pdf
drawings = \
	$(odir)\CN1-ASY-001.pdf \
	$(odir)\CN1-PRT-001.pdf

all: directories $(docs) $(drawings)

$(odir)\CN1-ASY-001.pdf: sheet\CN1-ASY-001.pdf
	pdftk $? cat output $@

$(odir)\CN1-PRT-001.pdf: sheet\CN1-PRT-001.pdf
	pdftk $? cat output $@

.PHONY: clean directories

clean:
	del $(odir)\*.pdf
	del sheet\*.pdf

directories: $(odir) sheet

$(odir):
	mkdir $(odir)

sheet:
	mkdir sheet

# *
# * Office
# *
# The toolchain only uses soffice and assumes there is one document per PDF:
#
#                 soffice      1
# doc/*.od?-------------------->build/*.pdf
#          1
.SUFFIXES: .ods .odt

# Spreadsheets
{doc\}.ods{$(odir)\}.pdf:
	soffice --convert-to pdf --outdir $(@D) $<

# Text documents
{doc\}.odt{$(odir)\}.pdf:
	soffice --convert-to pdf --outdir $(@D) $<

# *
# * Drawings
# *
# The toolchain from drawings to built artefact is:
#
#               dwg2pdf  1             pdftk  1
# drawing/*.dxf---------->sheet/*.pdf--------->build/*.pdf
#              1                     1..*
.SUFFIXES: .dxf

# Pattern rule for converting a sheet DXF into a sheet PDF
{drawing\}.dxf{sheet\}.pdf:
	dwg2pdf -f -o $@ $<
