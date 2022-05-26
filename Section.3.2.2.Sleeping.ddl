##################
# Reserved words #
#################################################################
#                                                               #
#   Head                                                        #
#   Resource                                                    #
#   Sensor                                                      #
#   ContextVariable                                             #
#   SimpleOperator                                              #
#   SimpleDomain                                                #
#   Constraint                                                  #
#   RequiredState						#
#   AchievedState						#
#   RequriedResoruce						#
#   All AllenIntervalConstraint types                           #
#   '[' and ']' should be used only for constraint bounds       #
#   '(' and ')' are used for parsing                            #
#                                                               #
#################################################################

(SimpleDomain TestMonarchProactivePlanning)
(ContextVariable ChildState)
(ContextVariable OtherChildState)

(Sensor ChildLocation)
(Sensor OtherChild)

######## Other Child States ######### ###### ###### ######

(SimpleOperator
 (Head OtherChildState::NoContext())
 (RequiredState req1 OtherChild::None())
 (Constraint Finishes(Head,req1))
)

(SimpleOperator
 (Head OtherChildState::Sleeping())
 (RequiredState req1 OtherChild::Sleeping())
 (Constraint Finishes(Head,req1))
)

######## CHILD STATES ######### ###### ###### ######

### Child is skipping school if child location is in bedroom ###
(SimpleOperator
 (Head ChildState::SkippingSchool())
 (RequiredState req1 ChildLocation::Bedroom())
# (RequiredState req2 RobotGoal::Goal1())
# (RequiredState req3 RobotGoal::DoFollowMe())
 (Constraint Finishes(Head,req1))
# (Constraint FinishedBy(Head,req3))
)

### Child is engaged when it is willing to follow the robot to the school, when he/she goes to coridor
(SimpleOperator
 (Head ChildState::Engaged())
 (RequiredState req1 ChildLocation::Coridor())
 (RequiredState req2 RobotMoveTo::School())
 (Constraint Finishes(Head,req1))
 (Constraint Duration[1500,INF](req2))
)

### Child in the school
(SimpleOperator
 (Head ChildState::InTheSchool())
 (RequiredState req1 ChildLocation::School())
 (RequiredState req2 RobotInteraction::Welcome())
 (Constraint Finishes(Head,req1))
 (Constraint Duration[1500,INF](req2))
)


###### ROBOT INTERACTIONS ###### ###### ############

### Robot can say 'follow me', but only when:
### the ChildState is skippingSchool
### when first it moves to bedroom
### and if the other child has no particular state
(SimpleOperator
 (Head RobotInteraction::FollowMe())
 (RequiredState req1 RobotMoveTo::Bedroom())
 (RequiredState req2 ChildState::SkippingSchool())
 (RequiredState req3 OtherChildState::NoContext()) 
 (Constraint After(Head,req1))
 (Constraint Duration[1500,INF](req1))
)

### Robot can say 'follow me', but only when:
### the ChildState is skippingSchool
### when first it moves to bedroom
### and if the other schiled state is: sleeping
(SimpleOperator
 (Head RobotInteraction::DisplayFollowMe())
 (RequiredState req1 RobotMoveTo::Bedroom())
 (RequiredState req2 ChildState::SkippingSchool())
 (RequiredState req3 OtherChildState::Sleeping())
 (Constraint After(Head,req1))
 (Constraint Duration[1500,INF](req1))
)

###### ROBOT GOALS ###### ###### ###### ######

(SimpleOperator 
 (Head RobotGoal::DoFollowMe())
 (RequiredState req1 RobotInteraction::DisplayFollowMe())
 (Constraint After(Head,req1))
 (Constraint Duration[1500,INF](req1))
)

(SimpleOperator 
 (Head RobotGoal::DoFollowMe())
 (RequiredState req1 RobotInteraction::FollowMe())
 (Constraint After(Head,req1))
 (Constraint Duration[1500,INF](req1))
)

(SimpleOperator
 (Head RobotGoal::Goal1())
 (RequiredState req1 RobotGoal::DoFollowMe())
 (Constraint After(Head,req1))
 (Constraint Duration[1500,INF](req1))
)
