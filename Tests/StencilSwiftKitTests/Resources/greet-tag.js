function greet(parser, token) {
    var bits = token.components();
    if (bits.length != 2) {
        throw "'greet' tag takes one argument"
    }
    
    this.variable = bits[1].split("|")[0];
    this.nodes = parser.parseUntil(["endgreet"], function(e) { throw e });
    
    if (parser.nextToken() === null) {
        throw "'endgreet' not found"
    };
    
    this.resolvable = parser.compileFilter(bits[1], function(e) { throw e });
    
    this.render = function(context) {
        var resolvable = this.resolvable;
        var nodes = this.nodes;
        var dict = {};
        dict[this.variable] = resolvable.resolve(context, function(e) { throw e });
        
        return context.push(dict, function() {
                            return renderNodes(nodes, context, function(e) { throw e });
                            })
    }
}
