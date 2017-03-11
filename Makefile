all: vim git
	@echo "All done!"

vim:
	test -e ~/.config/nvim || ln -s $(PWD)/nvim ~/.config/nvim
	test -e ~/.vim         || ln -s $(PWD)/nvim ~/.vim
	test -e ~/.vimrc       || ln -s $(PWD)/nvim/init.vim ~/.vimrc

git:
	test -e ~/.gitconfig || ln -s $(PWD)/gitconfig ~/.gitconfig

clean:
	rm -rf ~/.config/nvim
	rm -rf ~/.vim
	rm -rf ~/.vimrc
	rm -rf ~/.gitconfig
	@echo "Cleanup done!"

.PHONY: all vim git clean
