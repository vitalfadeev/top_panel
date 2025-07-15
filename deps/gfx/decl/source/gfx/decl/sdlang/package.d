// SDLang-D
// Written in the D programming language.

/++
$(H2 SDLang-D v0.10.1)

Library for parsing and generating SDL (Simple Declarative Language).

Import this module to use SDLang-D as a library.

For the list of officially supported compiler versions, see the
$(LINK2 https://github.com/Abscissa/SDLang-D/blob/master/.travis.yml, .travis.yml)
file included with your version of SDLang-D.

Links:
$(UL
	$(LI $(LINK2 http://sdlang.org/, SDLang Language Homepage) )
	$(LI $(LINK2 https://github.com/Abscissa/SDLang-D, SDLang-D Homepage) )
	$(LI $(LINK2 http://semitwist.com/sdlang-d, SDLang-D API Reference (latest version) ) )
	$(LI $(LINK2 http://semitwist.com/sdlang-d-docs, SDLang-D API Reference (earlier versions) ) )
	$(LI $(LINK2 http://sdl.ikayzo.org/display/SDL/Language+Guide, Old Official SDL Site) [$(LINK2 http://semitwist.com/sdl-mirror/Language+Guide.html, mirror)] )
)

Authors: Nick Sabalausky ("Abscissa") http://semitwist.com/contact
Copyright:
Copyright (C) 2012-2016 Nick Sabalausky.

License: $(LINK2 https://github.com/Abscissa/SDLang-D/blob/master/LICENSE.txt, zlib/libpng)
+/

module gfx.decl.sdlang;

import std.array;
import std.datetime;
import std.file;
import std.stdio;

import gfx.decl.sdlang.ast;
import gfx.decl.sdlang.exception;
import gfx.decl.sdlang.lexer;
import gfx.decl.sdlang.parser;
import gfx.decl.sdlang.symbol;
import gfx.decl.sdlang.token;
import gfx.decl.sdlang.util;

// Expose main public API
public import gfx.decl.sdlang.ast       : Attribute, Tag;
public import gfx.decl.sdlang.exception;
public import gfx.decl.sdlang.parser    : parseFile, parseSource;
public import gfx.decl.sdlang.token     : Value, Token, DateTimeFrac, DateTimeFracUnknownZone;
public import gfx.decl.sdlang.util      : sdlangVersion, Location;

version(sdlangUsingBuiltinTestRunner)
	void main() {}

version(sdlangCliApp)
{
	int main(string[] args)
	{
		if(
			args.length != 3 ||
			(args[1] != "lex" && args[1] != "parse" && args[1] != "to-sdl")
		)
		{
			stderr.writeln("SDLang-D v", sdlangVersion);
			stderr.writeln("Usage: sdlang [lex|parse|to-sdl] filename.sdl");
			return 1;
		}

		auto filename = args[2];

		try
		{
			if(args[1] == "lex")
				doLex(filename);
			else if(args[1] == "parse")
				doParse(filename);
			else
				doToSDL(filename);
		}
		catch(ParseException e)
		{
			stderr.writeln(e.msg);
			return 1;
		}

		return 0;
	}

	void doLex(string filename)
	{
		auto source = cast(string)read(filename);
		auto lexer = new Lexer(source, filename);

		foreach(tok; lexer)
		{
			// Value
			string value;
			if(tok.symbol == symbol!"Value")
				value = tok.value.hasValue? toString(tok.value.type) : "{null}";

			value = value==""? "\t" : "("~value~":"~tok.value.toString()~") ";

			// Data
			auto data = tok.data.replace("\n", "").replace("\r", "");
			if(data != "")
				data = "\t|"~tok.data~"|";

			// Display
			writeln(
				tok.location.toString, ":\t",
				tok.symbol.name, value,
				data
			);

			if(tok.symbol.name == "Error")
				break;
		}
	}

	void doParse(string filename)
	{
		auto root = parseFile(filename);
		stdout.rawWrite(root.toDebugString());
		writeln();
	}

	void doToSDL(string filename)
	{
		auto root = parseFile(filename);
		stdout.rawWrite(root.toSDLDocument());
	}
}
