##################
# Reserved words #
#################################################################
#                                                               #
#   Head                                                        #
#   Resource                                                    #
#   Sensor                                                      #
#   Actuator                                                    #
#   ContextVariable                                             #
#   SimpleOperator                                              #
#   PlanningOperator                                            #
#   Domain                                                      #
#   Constraint                                                  #
#   RequiredState                                               #
#   AchievedState                                               #
#   RequiredResource                                            #
#   All AllenIntervalConstraint types                           #
#   '[' and ']' should be used only for constraint bounds       #
#   '(' and ')' are used for parsing                            #
#                                                               #
#################################################################

(Domain Institutions)


# (TimelinesToShow Time robot1 command)
# (TimelinesToShow Time command inference_menu)


# SENSORS

# someone's request to change contexts (institutions)
(Sensor command)
(Sensor child_detected)
(Sensor human_detected_in_playroom)

# Sensors (true/false)
(Sensor teacher_in_classroom)
(Sensor children_in_classroom)

# ACTUATORS

(Actuator robot1)

# CONTEXT VARIABLES

# detect when we change contexts (a new Institution Activity starts)
(ContextVariable inference_activity)
# children present in classroom for teaching
(ContextVariable inference_children_not_in)
# display a menu on the touch screen for choosing the scenario
(ContextVariable inference_menu)
# an unknown human (unknown ID) is detected in the playroom
(ContextVariable inference_unknown_human)
# inference school room activity
(ContextVariable inference_school_activity)

# PLANNING OPERATORS

# Implemented storyboards: Interactive Game, School Teaching Assistant

# Displaying the menu on the touch screen for selecting a scenario
(SimpleOperator

(Head inference_menu::displaying)

(RequiredState req1 robot1::display_menu)

(Constraint Duration[3000,INF](Head))
(Constraint Duration[3000,INF](req1))
(Constraint During(req1,Head))

)


# A nurse selects the item (touch screen) corresponding to the
# interactive game
(SimpleOperator
 
(Head inference_activity::interactiveGame)

(RequiredState req0 command::interactive_game)

(RequiredState req1 robot1::interactive_game)

(Constraint Duration[3000,INF](Head))
(Constraint Duration[3000,INF](req1))
(Constraint Overlaps(req0,Head))
(Constraint During(req1,Head))

)


# A nurse announces or selects the item (touch screen) "School time!"
(SimpleOperator

(Head inference_activity::teaching)

(RequiredState req0 command::school_time)

(Constraint Duration[3000,INF](Head))
(Constraint Overlaps(req0,Head))
 
)


# Get RFID of the person detected in the playroom
(SimpleOperator

(Head inference_unknown_human::true)
 
(RequiredState req0 inference_activity::teaching)
 
(RequiredState req1 human_detected_in_playroom::true)
(RequiredState req2 child_detected::no_detection)

(RequiredState req3 robot1::get_rfid)

(Constraint Duration[3000,INF](Head))
(Constraint Duration[3000,INF](req3))
(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))
(Constraint Overlaps(req2,Head))
(Constraint During(req3,Head))
 
)


# Tell the child to go to the classroom and then lead them to the
# classroom
 (SimpleOperator
 
(Head inference_children_not_in::classroom)

(RequiredState req0 inference_activity::teaching)

(RequiredState req1 child_detected::true)

(RequiredState req2 robot1::tell_child_to_go_to_classroom)
(RequiredState req3 robot1::lead_child_to_classroom)

(Constraint Duration[3000,INF](Head))
(Constraint Duration[3000,INF](req2))
(Constraint Duration[3000,INF](req3))
(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))
(Constraint During(req2,Head))
(Constraint During(req3,Head))
(Constraint Meets(req2,req3))
)

# ------------------------HANDLE Q/A plans----------------------------

# If it is a teaching scenario, children are in the room
# and the teacher is not in the room
 
(SimpleOperator

(Head inference_school_activity::quiz)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 teacher_in_classroom::false)
(RequiredState req2 children_in_classroom::true)
(RequiredState req3 robot1::quiz)
(RequiredState req4 robot1::abortAll)

(Constraint Duration[3000,INF](Head))
(Constraint Duration[3000,INF](req3))
(Constraint During(Head,req0))
(Constraint StartsOr...(req1,Head))
(Constraint StartsOr...(req2,Head))
(Constraint Contains(Head,req3))
(Constraint Before(req4,req3))

 
)

# If it is a teaching scenario, children are in the room
# and the teacher is in the room, then it is not time for quizz

(SimpleOperator

(Head inference_school_activity::ta_behavior)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 teacher_in_classroom::true)
(RequiredState req2 children_in_classroom::true)
(RequiredState req3 robot1::teaching_assistant)

(Constraint Duration[3000,INF](Head))
(Constraint Duration[3000,INF](req3))
(Constraint During(Head,req0))
(Constraint During(req3,Head))
(Constraint Overlaps(req1,Head))
(Constraint Overlaps(req2,Head))
 
)

# ---   End Quizz/TA    ---------------------------




