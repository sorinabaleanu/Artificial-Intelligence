# multiAgents.py
# --------------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


from util import manhattanDistance
from game import Directions
import random, util

from game import Agent

class RandomAgent(Agent):

    def getAction(selfself, gameState):
        legalMoves = gameState.getLegalActions()

        chosenAction = random.choice(legalMoves)

        return chosenAction


class ReflexAgent(Agent):
    """
    A reflex agent chooses an action at each choice point by examining
    its alternatives via a state evaluation function.

    The code below is provided as a guide.  You are welcome to change
    it in any way you see fit, so long as you don't touch our method
    headers.
    """


    def getAction(self, gameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {NORTH, SOUTH, WEST, EAST, STOP}
        """
        # Collect legal moves and successor states
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the state, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of moves that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (pacman.py)
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        newFood = successorGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

        "*** YOUR CODE HERE ***"

        ghost_positions = currentGameState.getGhostPositions()

        distToGhosts = [manhattanDistance(newPos, ghostPos) for ghostPos in ghost_positions]
        distToFood = [manhattanDistance(newPos, foodPos) for foodPos in newFood.asList()]

        d1 = min(distToFood) if len(distToFood) > 0  else float("inf")
        d2 = min(distToGhosts)

        if d1 == 0:
            d1 = float("inf")
        if d2 == 0:
            d2 = float("inf")

        for ghost in successorGameState.getGhostPositions():
            if manhattanDistance(newPos, ghost) == 1:
                return -float("inf")

        return successorGameState.getScore() + 1. / d1 - 1. / d2


def scoreEvaluationFunction(currentGameState):
    """
    This default evaluation function just returns the score of the state.
    The score is the same one displayed in the Pacman GUI.

    This evaluation function is meant for use with adversarial search agents
    (not reflex agents).
    """
    return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
    """
    This class provides some common elements to all of your
    multi-agent searchers.  Any methods defined here will be available
    to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

    You *do not* need to make any changes here, but you can if you want to
    add functionality to all your adversarial search agents.  Please do not
    remove anything, however.

    Note: this is an abstract class: one that should not be instantiated.  It's
    only partially specified, and designed to be extended.  Agent (game.py)
    is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
    """
    Your minimax agent (question 2)
    """

    def getAction(self, gameState):
        """
        Returns the minimax action from the current gameState using self.depth
        and self.evaluationFunction.

        Here are some method calls that might be useful when implementing minimax.

        gameState.getLegalActions(agentIndex):
        Returns a list of legal actions for an agent
        agentIndex=0 means Pacman, ghosts are >= 1

        gameState.generateSuccessor(agentIndex, action):
        Returns the successor game state after an agent takes an action

        gameState.getNumAgents():
        Returns the total number of agents in the game

        gameState.isWin():
        Returns whether or not the game state is a winning state

        gameState.isLose():
        Returns whether or not the game state is a losing state
        """
        "*** YOUR CODE HERE ***"

        def minimax_decision(current, next_state, depth, agent):

            if agent < current.getNumAgents() - 1:
                return min_value(next_state, depth, agent + 1)
            else:
                return max_value(next_state, depth + 1, 0)

        def max_value(current, depth, agent):

            actions = current.getLegalActions(agent)

            if current.isWin() or current.isLose() or depth == self.depth:
                return self.evaluationFunction(current), None

            max_val = -float("inf")
            max_action = None

            for action in actions:

                next_state = current.generateSuccessor(agent, action)
                value = minimax_decision(current, next_state, depth, agent)[0]

                if value > max_val:
                    max_val = value
                    max_action = action

            return max_val, max_action

        def min_value(current, depth, agent):

            actions = current.getLegalActions(agent)

            if current.isWin() or current.isLose() or depth == self.depth:
                return self.evaluationFunction(current), None

            min_val = float("inf")
            min_action = None

            for action in actions:

                next_state = current.generateSuccessor(agent, action)
                value = minimax_decision(current, next_state, depth, agent)[0]

                if value < min_val:
                    min_val = value
                    min_action = action

            return min_val, min_action

        return max_value(gameState, 0, 0)[1]

        util.raiseNotDefined()

class AlphaBetaAgent(MultiAgentSearchAgent):
    """
    Your minimax agent with alpha-beta pruning (question 3)
    """

    def getAction(self, gameState):
        """
        Returns the minimax action using self.depth and self.evaluationFunction
        """
        "*** YOUR CODE HERE ***"
        def alphabeta_search(current, next_state, depth, agent, alpha, beta):

            if agent < current.getNumAgents() - 1:
                return min_value(next_state, depth, agent + 1, alpha, beta)
            else:
                return max_value(next_state, depth + 1, 0, alpha, beta)

        def max_value(current, depth, agent, alpha, beta):

            actions = current.getLegalActions(agent)
            max_val = -float("inf")

            max_action = None

            if current.isWin() or current.isLose() or depth == self.depth:
                return self.evaluationFunction(current), None

            for action in actions:
                next_state = current.generateSuccessor(agent, action)
                value = alphabeta_search(current, next_state, depth, agent, alpha, beta)[0]
                if value > max_val:
                    max_val = value
                    max_action = action

                alpha = max(alpha, max_val)

                if alpha > beta:
                    return max_val, max_action

            return max_val, max_action

        def min_value(current, depth, agent, alpha, beta):
            actions = current.getLegalActions(agent)

            if current.isWin() or current.isLose() or depth == self.depth:
                return self.evaluationFunction(current), None

            min_val = float("inf")
            min_action = None

            for action in actions:
                newState = current.generateSuccessor(agent, action)
                value = alphabeta_search(current, newState, depth, agent, alpha, beta)[0]

                if value < min_val:
                    min_val = value
                    min_action = action

                beta = min(beta, min_val)

                if beta < alpha:
                    return min_val, min_action



            return min_val, min_action

        alpha = -float("inf")
        beta = float("inf")

        return max_value(gameState, 0, 0, alpha, beta)[1]
        util.raiseNotDefined()

class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """

    def getAction(self, gameState):
        """
        Returns the expectimax action using self.depth and self.evaluationFunction

        All ghosts should be modeled as choosing uniformly at random from their
        legal moves.
        """
        "*** YOUR CODE HERE ***"
        util.raiseNotDefined()

def betterEvaluationFunction(currentGameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    DESCRIPTION: <write something here so we know what you did>
    """
    "*** YOUR CODE HERE ***"
    util.raiseNotDefined()

# Abbreviation
better = betterEvaluationFunction
