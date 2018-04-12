NAME = rngseed
OBJ = rngseed.o

all: $(NAME)

$(NAME): $(OBJ)
	$(CC) $(LDFLAGS) -o $(NAME) $(OBJ)

.PHONY: clean
clean:
	rm -f $(NAME) $(OBJ)
