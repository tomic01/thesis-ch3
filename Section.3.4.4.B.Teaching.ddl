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

(Domain teaching)


# SENSORS

# someone's request to change contexts
(Sensor command)
# command uttered by someone
(Sensor command_issued_by)

(Sensor markers_not_in)
(Sensor children_not_in)
(Sensor children_in)
(Sensor teacher_not_in)

# Positions of two robots
(Sensor mbot1_at)
(Sensor mbot1_not_at)
(Sensor mbot2_in)
(Sensor mbot2_not_in)


# UNARY RESOURCES

(Resource mbot1_resource 1)
(Resource mbot2_resource 1)


# ACTUATORS

(Actuator mbot1)
(Actuator mbot2)


# CONTEXT VARIABLES

# detect when we change contexts (new Institution Activity)
(ContextVariable inference_activity)
# markers used for teaching
(ContextVariable inference_markers_not_in)
# children present in classroom for teaching
(ContextVariable inference_children_not_in)
# teacher present in classroom for teaching
(ContextVariable inference_teacher_not_in)
# teacher assistant present in classroom for teaching
(ContextVariable inference_mbot2_not_in)



# PLANNING OPERATORS


# A nurse announces "School time!"
(SimpleOperator

(Head inference_activity::teaching)

(RequiredState req0 command::school_time)
(RequiredState req1 command_issued_by::nurse)

(Constraint Duration[26000,900000](Head))

(Constraint Overlaps(req0,Head))
(Constraint Overlaps(req1,Head))

)


# Bring the markers if they are not in the classroom
(SimpleOperator

(Head inference_markers_not_in::classroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 markers_not_in::classroom)
(RequiredState req2 mbot1::go_to_and_interact_with_a_nurse)
(RequiredState req3 mbot1_mobility::used)

(Constraint During(Head,req0))
(Constraint During(req2,Head))
(Constraint Overlaps(req1,Head))
(Constraint During(req2,req3))

(Constraint Duration[3000,3000](req2))

)

# Markers, pure inference
(SimpleOperator

(Head inference_markers_not_in::null)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 markers_not_in::null)

(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))

)


# Lead the children to the classroom
# mbot2 is already in the playroom
# mbot1 is already at the classroom door
(SimpleOperator

(Head inference_children_not_in::classroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 children_not_in::classroom)
(RequiredState req2 mbot2::lead_children_from_playroom_to_classroom)
(RequiredState req3 children_in::playroom)
(RequiredState req4 mbot2_in::playroom)
(RequiredState req5 mbot1_at::classroom_door)
(RequiredState req6 mbot2_mobility::used)

(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))
(Constraint During(req2,req6))
(Constraint Overlaps(req3,Head))
(Constraint Overlaps(req4,Head))
(Constraint Overlaps(req5,Head))

(Constraint Duration[4000,4000](req2))

)


# Lead the children to the classroom
# mbot2 is already in the playroom
# mbot1 is not yet at the classroom door
(SimpleOperator

(Head inference_children_not_in::classroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 children_not_in::classroom)
(RequiredState req2 mbot2::lead_children_from_playroom_to_classroom)
(RequiredState req3 children_in::playroom)
(RequiredState req4 mbot2_in::playroom)
(RequiredState req5 mbot1_not_at::classroom_door)
(RequiredState req6 mbot2_mobility::used)
(RequiredState req7 mbot1::go_to_classroom_door)
(RequiredState req8 mbot1_mobility::used)

(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))
(Constraint During(req2,req6))
(Constraint Overlaps(req3,Head))
(Constraint Overlaps(req4,Head))
(Constraint Overlaps(req5,Head))
(Constraint Before(req7,req2))
(Constraint During(req7,req8))

(Constraint Duration[4000,4000](req2))
(Constraint Duration[5000,5000](req7))

)


# Go to the playroom and then lead the children to the classroom
# mbot2 is not yet in the playroom
# mbot1 is already at the classroom door
(SimpleOperator

(Head inference_children_not_in::classroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 children_not_in::classroom)
(RequiredState req2 mbot2::lead_children_from_playroom_to_classroom)
(RequiredState req3 children_in::playroom)
(RequiredState req4 mbot2_not_in::playroom)
(RequiredState req5 mbot1_at::classroom_door)
(RequiredState req6 mbot2_mobility::used)
(RequiredState req7 mbot2::go_to_playroom)

(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))
(Constraint During(req2,req6))
(Constraint Overlaps(req3,Head))
(Constraint Overlaps(req4,Head))
(Constraint Overlaps(req5,Head))
(Constraint Before(req7,req2))
(Constraint During(req7,req6))

(Constraint Duration[4000,4000](req2))
(Constraint Duration[3000,3000](req7))

)


# Go to the playroom and then lead the children to the classroom
# mbot2 is not yet in the playroom
# mbot1 is not yet at the door of the classroom
(SimpleOperator

(Head inference_children_not_in::classroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 children_not_in::classroom)
(RequiredState req2 mbot2::lead_children_from_playroom_to_classroom)
(RequiredState req3 children_in::playroom)
(RequiredState req4 mbot2_not_in::playroom)
(RequiredState req5 mbot1_not_at::classroom_door)
(RequiredState req6 mbot2_mobility::used)
(RequiredState req7 mbot2::go_to_playroom)
(RequiredState req8 mbot1::go_to_classroom_door)
(RequiredState req9 mbot1_mobility::used)

(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))
(Constraint During(req2,req6))
(Constraint Overlaps(req3,Head))
(Constraint Overlaps(req4,Head))
(Constraint Overlaps(req5,Head))
(Constraint Before(req7,req2))
(Constraint During(req7,req6))
(Constraint Before(req8,req2))
(Constraint During(req8,req9))

(Constraint Duration[4000,4000](req2))
(Constraint Duration[3000,3000](req7))
(Constraint Duration[5000,5000](req8))

)


# Children in classroom, pure inference
(SimpleOperator

(Head inference_children_not_in::playroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 children_not_in::playroom)
(RequiredState req2 children_in::classroom)

(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))
(Constraint Overlaps(req2,Head))

)


# Teacher in the classroom
(SimpleOperator

(Head inference_teacher_not_in::classroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 teacher_not_in::classroom)
(RequiredState req2 mbot2::go_to_and_interact_with_teacher)
(RequiredState req3 mbot2_mobility::used)

(Constraint During(Head,req0))
(Constraint During(req2,Head))
(Constraint Overlaps(req1,Head))
(Constraint During(req2,req3))

(Constraint Duration[5000,5000](req2))

)


# Teacher in the classroom, pure inference
(SimpleOperator

(Head inference_teacher_not_in::null)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 teacher_not_in::null)

(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))

)


# Teaching assistant in the classroom
(SimpleOperator

(Head inference_mbot2_not_in::classroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 mbot2_not_in::classroom)
(RequiredState req2 mbot2::go_to_classroom)
(RequiredState req3 mbot2_mobility::used)

(Constraint During(Head,req0))
(Constaint During(req2,Head))
(Constraint Overlaps(req1,Head))
(Constraint During(req2,req3))

(Constraint Duration[6000,6000](req2))

)


# Teaching assistant in the classroom, pure inference
(SimpleOperator

(Head inference_mbot2_not_in::playroom)

(RequiredState req0 inference_activity::teaching)
(RequiredState req1 mbot2_not_in::playroom)

(Constraint During(Head,req0))
(Constraint Overlaps(req1,Head))

)



(SimpleOperator

(Head mbot1_mobility::used)

(RequiredResource mbot1_resource(1))

)


(SimpleOperator

(Head mbot2_mobility::used)

(RequiredResource mbot2_resource(1))

)