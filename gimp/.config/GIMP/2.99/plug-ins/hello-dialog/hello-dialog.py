#!/usr/bin/env python3
import gi
gi.require_version('Gimp', '3.0')
from gi.repository import Gimp
gi.require_version('GimpUi', '3.0')
from gi.repository import GimpUi
from gi.repository import GObject
from gi.repository import GLib
import sys


'''
A Python plugin to display a simple dialog.
'''

def test_dialog(procedure, run_mode, image, n_drawables, drawables, args, data):
	config = procedure.create_config()
	config.begin_run(image, run_mode, args)

	if run_mode == Gimp.RunMode.INTERACTIVE:
		GimpUi.init('python-fu-hello-world')
		dialog = GimpUi.ProcedureDialog(procedure=procedure, config=config)
		dialog.fill(None)
		if not dialog.run():
			dialog.destroy()
			config.end_run(Gimp.PDBStatusType.CANCEL)
			return procedure.new_return_values(Gimp.PDBStatusType.CANCEL, GLib.Error())
		else:
			dialog.destroy()

	minimum = config.get_property('minimum')

	Gimp.context_push()

	Gimp.message("Hello World")

	Gimp.displays_flush()
	Gimp.context_pop()
	config.end_run(Gimp.PDBStatusType.SUCCESS)
	return procedure.new_return_values(Gimp.PDBStatusType.SUCCESS, GLib.Error())


class HelloDialogPlugin (Gimp.PlugIn):
	## Parameters ##
	minimum = GObject.Property(type = float, nick = "Mi_nimum", blurb = "Minimum")

	## GimpPlugIn virtual methods ##
	def do_set_i18n(self, procname):
		return True, 'gimp30-python', None

	def do_query_procedures(self):
		return [ 'python-fu-hello-world' ]

	def do_create_procedure(self, name):
		procedure = Gimp.ImageProcedure.new(self, name,
		                                    Gimp.PDBProcType.PLUGIN,
		                                    test_dialog, None)
		procedure.set_sensitivity_mask (Gimp.ProcedureSensitivityMask.NO_IMAGE)
		procedure.set_documentation ("Hello dialog", #short
		                             "Hello dialog", #long
		                             name)
		procedure.set_menu_label("Hello dialog...") #underscore before shortcut, ... signifies a dialog
		procedure.set_attribution("oliva", #name
		                          "oliva", #name again?
		                          "2023")  #date
		procedure.add_menu_path ("<Image>/Test")#"<Image>/Filters/Light and Shadow")

		procedure.add_argument_from_property(self, "minimum")

		return procedure

# register plugin
Gimp.main(HelloDialogPlugin.__gtype__, sys.argv)
