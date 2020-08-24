ad_library {

        Automated tests for the dotlrn-assessment package.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10

}

aa_register_case \
    -cats {api smoke production_safe} \
    -procs {
        dotlrn_assessment::package_key
        dotlrn_assessment::my_package_key
        dotlrn_assessment::applet_key
    } \
    dotlrn_assessment__keys {

        Simple test for the various dotlrn_assessment::..._key procs.

        @author Héctor Romojaro <hector.romojaro@gmail.com>
        @creation-date 2019-09-10
} {
    aa_equals "Package key" "[dotlrn_assessment::package_key]" "assessment"
    aa_equals "My Package key" "[dotlrn_assessment::my_package_key]" "dotlrn-assessment"
    aa_equals "Applet key" "[dotlrn_assessment::applet_key]" "dotlrn_assessment"
}

aa_register_case -procs {
        dotlrn_assessment::get_pretty_name
    } -cats {
        api
        production_safe
    } dotlrn_assessment__names {
        Test diverse name procs.
} {
    aa_equals "Pretty name" "[dotlrn_assessment::get_pretty_name]" "#assessment.Applet#"
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
