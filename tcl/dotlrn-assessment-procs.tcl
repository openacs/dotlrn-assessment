ad_library {
    
    Procs to set up the dotLRN assessment applet
    
    @author jopez@galileo.edu
    @cvs_id $Id$
}

namespace eval dotlrn_assessment {}

ad_proc -public dotlrn_assessment::applet_key {} {
    What's my applet key?
} {
    return dotlrn_assessment
}

ad_proc -public dotlrn_assessment::package_key {} {
    What package do I deal with?
} {
    return "assessment"
}

ad_proc -public dotlrn_assessment::my_package_key {} {
    What package do I deal with?
} {
    return "dotlrn-assessment"
}

ad_proc -public dotlrn_assessment::get_pretty_name {} {
    returns the pretty name
} {
    return "#assessment.Applet#"
}

ad_proc -public dotlrn_assessment::add_applet {} {
    One time init - must be repeatable!
} {
    dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key] -package_key [my_package_key]
}

ad_proc -public dotlrn_assessment::remove_applet {} {
    One time destroy. 
} {
    set applet_id [dotlrn_applet::get_applet_id_from_key [my_package_key]]
    db_exec_plsql delete_applet_from_communities { *SQL* } 
    db_exec_plsql delete_applet { *SQL* } 
}

ad_proc -public dotlrn_assessment::add_applet_to_community {
    community_id
} {
    Add the assessment applet to a specifc dotlrn community
} {
    set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

    # create the assessment package instance 
    set package_id [dotlrn::instantiate_and_mount $community_id [package_key]]

    # set up the admin portal
    set admin_portal_id [dotlrn_community::get_admin_portal_id \
                             -community_id $community_id
                        ]

    assessment_admin_portlet::add_self_to_page \
        -portal_id $admin_portal_id \
        -package_id $package_id
    
    set args [ns_set create]
    ns_set put $args package_id $package_id
    add_portlet_helper $portal_id $args

    return $package_id
}

ad_proc -public dotlrn_assessment::remove_applet_from_community {
    community_id
} {
    remove the applet from the community
} {
    ad_return_complaint 1 "[applet_key] remove_applet_from_community not implimented!"
}

ad_proc -public dotlrn_assessment::add_user {
    user_id
} {
    one time user-specifuc init
} {
    # noop
}

ad_proc -public dotlrn_assessment::remove_user {
    user_id
} {
} {
    ad_return_complaint 1 "[applet_key] remove_user not implimented!"
}

ad_proc -public dotlrn_assessment::add_user_to_community {
    community_id
    user_id
} {
    Add a user to a specifc dotlrn community
} {
    set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
    set portal_id [dotlrn::get_portal_id -user_id $user_id]
    
    # use "append" here since we want to aggregate
    set args [ns_set create]
    ns_set put $args package_id $package_id
    ns_set put $args param_action append
    add_portlet_helper $portal_id $args
}

ad_proc -public dotlrn_assessment::remove_user_from_community {
    community_id
    user_id
} {
    Remove a user from a community
} {
    set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
    set portal_id [dotlrn::get_portal_id -user_id $user_id]

    set args [ns_set create]
    ns_set put $args package_id $package_id

    remove_portlet $portal_id $args
}

ad_proc -public dotlrn_assessment::add_portlet {
    portal_id
} {
    A helper proc to add the underlying portlet to the given portal. 
    
    @param portal_id
} {
    # simple, no type specific stuff, just set some dummy values

    set args [ns_set create]
    ns_set put $args package_id 0
    ns_set put $args param_action overwrite
    add_portlet_helper $portal_id $args
}

ad_proc -public dotlrn_assessment::add_portlet_helper {
    portal_id
    args
} {
    A helper proc to add the underlying portlet to the given portal.

    @param portal_id
    @param args an ns_set
} {
    assessment_portlet::add_self_to_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id] \
        -param_action [ns_set get $args param_action]
}

ad_proc -public dotlrn_assessment::remove_portlet {
    portal_id
    args
} {
    A helper proc to remove the underlying portlet from the given portal. 
    
    @param portal_id
    @param args A list of key-value pairs (possibly user_id, community_id, and more)
} { 
    assessment_portlet::remove_self_from_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id]
}

ad_proc -public dotlrn_assessment::clone {
    old_community_id
    new_community_id
} {
    Clone this applet's content from the old community to the new one
} {
    ns_log notice "Cloning: [applet_key]"
    set new_package_id [add_applet_to_community $new_community_id]
    set old_package_id [dotlrn_community::get_applet_package_id \
                            -community_id $old_community_id \
                            -applet_key [applet_key]
                       ]

    db_exec_plsql call_assessment_clone {}
    return $new_package_id
}

ad_proc -public dotlrn_assessment::change_event_handler {
    community_id
    event
    old_value
    new_value
} { 
    listens for the following events: 
} { 
}   
