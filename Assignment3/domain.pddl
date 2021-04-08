(define (domain restaurant)
  (:requirements :strips :typing :action-costs)
  (:types hand container food - object
    salad  ingredient riceWithVegetables meatWithRice pastaWithVegetables meatWithSalad - food 
  	vegetable garnish meat - ingredient
  	tomato onion cucumber garlic - vegetable
  	rice pasta - garnish
  	pot mixingbowl chopper plate - container)
 
  (:predicates  (ontable ?c - container)
                (holding ?h - hand ?o - object)
                (chopped ?v - vegetable)
                (boiled ?g - garnish)
                (cooked ?m - meat)
		        (handempty ?h - hand)
		        (contains ?c - container ?f - food)
		        (inFridge ?i - ingredient)
		        (clean ?c - container)
		        (readyToServe ?f - food))
		        

(:functions (total-cost) - number)
		
  (:action grab-from-table
             :parameters (?h - hand ?c - container)
             :precondition (and (ontable ?c)
                                (handempty ?h))
             :effect (and (not (ontable ?c))
	     	     	      (not (handempty ?h))
			              (holding ?h ?c)
			  (increase (total-cost) 1)))

  (:action drop-on-table
             :parameters (?h - hand ?c - container)
             :precondition (holding ?h ?c)
             :effect (and (not (holding ?h ?c))
	     	     	      (handempty ?h)
			              (ontable ?c)
			(increase (total-cost) 1)))
			
	(:action grab-from-fridge
             :parameters (?h - hand ?i - ingredient)
             :precondition (and (inFridge ?i) 
                                (handempty ?h))
             :effect (and (not (inFridge ?i))
	     	     	      (not (handempty ?h))
			              (holding ?h ?i)
			  (increase (total-cost) 1)))
			  
	(:action drop-ingredient
             :parameters (?h1 ?h2 - hand ?i - ingredient ?c - container)
             :precondition (and (holding ?h1 ?i) 
                                (holding ?h2 ?c))
             :effect (and (contains ?c ?i)
	     	     	      (handempty ?h1)
			              (not (holding ?h1 ?i))
			  (increase (total-cost) 1)))
			  
	(:action switch-container
             :parameters (?h1 ?h2 - hand ?f - food ?c1 ?c2 - container)
             :precondition (and (holding ?h1 ?c1) 
                                (holding ?h2 ?c2)
                                (contains ?c1 ?f)
                               ( not(contains ?c2 ?f)))
             :effect (and (contains ?c2 ?f)
                          (not (contains ?c1 ?f))
			  (increase (total-cost) 1)))
	
	(:action chop-ingredient
             :parameters (?h1 ?h2 - hand ?v - vegetable ?c - chopper)
             :precondition (and (holding ?h1 ?c) 
                                (contains ?c ?v)
                                (handempty ?h2)
                                (not(chopped ?v)))
             :effect (and (chopped ?v)
			  (increase (total-cost) 8)))
			  
	(:action boil-ingredient
             :parameters (?h1 ?h2 - hand ?g - garnish ?p - pot)
             :precondition (and (holding ?h1 ?p) 
                                (contains ?p ?g)
                                (handempty ?h2)
                                )
             :effect (and (boiled ?g)
			  (increase (total-cost) 10)))
			  
	(:action cook-meat
              :parameters (?h1 ?h2 - hand ?m - meat ?p - pot)
              :precondition (and (holding ?h1 ?p) 
                                 (contains ?p ?m)
                                 (handempty ?h2))
                    :effect (and (cooked ?m)
 			  (increase (total-cost) 15)))
			  

			  

    (:action make-salad
             :parameters (?h1 ?h2 - hand  ?t - tomato ?c - cucumber ?o - onion ?g - garlic ?mb - mixingbowl ?f - salad )
             :precondition (and (holding ?h1 ?mb) 
                                (contains ?mb ?t)
                                (contains ?mb ?c)
                                (contains ?mb ?o)
                                (contains ?mb ?g)
                                (chopped ?t)
                                (chopped ?c)
                                (chopped ?o)
                                (chopped ?g)
                                (handempty ?h2)
                                
                               )
             :effect (and 
                          (contains ?mb ?f)
			  (increase (total-cost) 3)))
			  
			  
	(:action serve-salad
             :parameters (?h1  - hand ?s - salad  ?p - plate)
             :precondition (and (holding ?h1 ?p)
                                (clean ?p)
                                (contains ?p ?s))
             :effect (and 
                          (not (clean ?p))
                          (readyToServe ?s)
			  (increase (total-cost) 1)))
			  

	
     (:action make-rice
             :parameters (?h1 ?h2 - hand ?r - rice  ?o - onion ?g - garlic ?mb - mixingbowl ?f - riceWithVegetables)
             :precondition (and (holding ?h1 ?mb)  
                                (contains ?mb ?o)
                                (contains ?mb ?g)
                                (contains ?mb ?r)
                                (boiled ?r)
                                (chopped ?o)
                                (chopped ?g)
                               (handempty ?h2) )
             :effect (and (contains ?mb ?f)
			  (increase (total-cost) 3)))
			  

	(:action serve-rice
             :parameters (?h1  - hand ?r - riceWithVegetables  ?p - plate)
             :precondition (and (holding ?h1 ?p)
                                (clean ?p)
                                (contains ?p ?r))
             :effect (and 
                          (not (clean ?p))
                          (readyToServe ?r)
			  (increase (total-cost) 1)))
			  
			  
    
     (:action make-pasta
             :parameters (?h1 ?h2 - hand ?p - pasta  ?t - tomato ?g - garlic ?mb - mixingbowl ?f - pastaWithVegetables)
             :precondition (and (holding ?h1 ?mb)  
                                (contains ?mb ?t)
                                (contains ?mb ?g)
                                (contains ?mb ?p)
                                (boiled ?p)
                                (chopped ?t)
                                (chopped ?g)
                               (handempty ?h2) )
             :effect (and (contains ?mb ?f)
			  (increase (total-cost) 3)))
			  

	(:action serve-pasta
             :parameters (?h1  - hand ?f - pastaWithVegetables  ?p - plate)
             :precondition (and (holding ?h1 ?p)
                                (clean ?p)
                                (contains ?p ?f))
             :effect (and 
                          (not (clean ?p))
                          (readyToServe ?f)
			  (increase (total-cost) 1)))	



 (:action make-rice-with-meat
             :parameters (?h1 ?h2 - hand ?r - rice  ?o - onion ?g - garlic ?m - meat ?mb - mixingbowl ?f - meatWithRice)
             :precondition (and (holding ?h1 ?mb)  
                                (contains ?mb ?o)
                                (contains ?mb ?g)
                                (contains ?mb ?r)
                                (contains ?mb ?m)
                                (cooked ?m)
                                (boiled ?r)
                                (chopped ?o)
                                (chopped ?g)
                               (handempty ?h2) )
             :effect (and (contains ?mb ?f)
			  (increase (total-cost) 3)))	
			  
 		  
			  
			  
 (:action serve-rice-with-meat
             :parameters (?h1  - hand ?m - meatWithRice  ?p - plate)
             :precondition (and (holding ?h1 ?p)
                                (clean ?p)
                                (contains ?p ?m))
             :effect (and (not (clean ?p))
                          (readyToServe ?m)
			  (increase (total-cost) 1)))		  

			  
  (:action make-salad-with-meat
             :parameters (?h1 ?h2 - hand  ?t - tomato ?c - cucumber ?o - onion ?g - garlic ?m - meat ?mb - mixingbowl ?f - meatWithSalad)
             :precondition (and (holding ?h1 ?mb) 
                                (contains ?mb ?t)
                                (contains ?mb ?c)
                                (contains ?mb ?o)
                                (contains ?mb ?g)
                                (contains ?mb ?m)
                                (cooked ?m)
                                (chopped ?t)
                                (chopped ?c)
                                (chopped ?o)
                                (chopped ?g)
                                (handempty ?h2)
                                
                               )
             :effect (and 
                          (contains ?mb ?f)
			  (increase (total-cost) 3)))
			  
			  
	(:action serve-salad-with-meat
             :parameters (?h1  - hand ?s - meatWithSalad ?p - plate)
             :precondition (and (holding ?h1 ?p)
                                (clean ?p)
                                (contains ?p ?s))
             :effect (and 
                          (not (clean ?p))
                          (readyToServe ?s)
			  (increase (total-cost) 1)))
			  

			  
    (:action clean-container
  	       :parameters (?h1 ?h2 - hand ?c - container)
           :precondition (and (holding ?h1 ?c)
                              ;(handempty ?h2)
                              (not (empty ?c))
                              (not (clean ?c)))
           :effect (and (clean ?c)
                        (empty ?c)
			(increase (total-cost) 5)))
)