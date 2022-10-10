# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gshim <gshim@student.42.fr>                +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/08/30 18:07:40 by gshim             #+#    #+#              #
#    Updated: 2022/10/07 12:48:32 by gshim            ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# =============================================================================
# Color Variables
# =============================================================================
BLACK		= 	"\033[0;30m"
GRAY		= 	"\033[1;30m"
RED			=	"\033[0;31m"
GREEN		=	"\033[0;32m"
YELLOW		=	"\033[1;33m"
PURPLE		=	"\033[0;35m"
CYAN		=	"\033[0;36m"
WHITE		=	"\033[1;37m"
EOC			=	"\033[0;0m"
LINE_CLEAR	=	"\x1b[1A\x1b[M"

# =============================================================================
# Command Variables
# =============================================================================
CXX			=	c++
#CFLAGS		=	-Wall -Wextra -Werror -std=c++98
CDEBUG		=	-g -fsanitize=address

# =============================================================================
# File Variables
# =============================================================================
NAME		=	webserv

SRCS		=	$(addprefix $(SRCS_DIR), $(SRC_LIST))
OBJS		=	$(SRCS:.cpp=.o)

# =============================================================================
# Target Generating
# =============================================================================
$(NAME)			:
	@echo $(YELLOW) "Composing docker system from docker-compose.yml..." $(EOC)
	@docker-compose -f ./srcs/docker-compose.yml up
	@echo $(GREEN) "Docker compose complete!" $(EOC)

$(SRCS_DIR)/%.o	:	$(SRCS_DIR)/%.cpp
	@echo $(YELLOW) "Compiling...\t" $< $(EOC) $(LINE_CLEAR)
	@$(CXX) $(CFLAGS) $(CDEBUG) -c $< -o $@

# =============================================================================
# Rules
# =============================================================================
all			:	$(NAME)


bash		:
				@echo $(YELLOW) "Open bash on first container..." $(EOC)
				@docker exec -it `docker ps | awk 'NR == 2{print $1}'` bash
				@echo $(RED) "Bash closed! 🧹 🧹\n" $(EOC)

fclean		:
				@echo $(YELLOW) "Removing All Docker things..." $(EOC)
				@echo y | docker system prune -a
				@echo $(RED) "All Docker things are removed! 🗑 🗑\n" $(EOC)

re			: fclean all

.PHONY		: all clean fclean re
